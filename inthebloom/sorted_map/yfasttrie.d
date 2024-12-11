module inthebloom.sorted_map.yfasttrie;

import inthebloom.sorted_map.interfaces;
import inthebloom.sorted_map.treap;
import inthebloom.sorted_map.xfasttrie;
import inthebloom.unordered_map;

import std.traits: Unqual;
import std.typecons: Tuple, tuple;

class YFastTrie (K, V): SortedMap!(K, V)
    if (is(Unqual!(K) == uint) ||
        is(Unqual!(K) == ulong))
{
    size_t size = 0;

    alias treap_type = Treap!(K, V);
    alias xft_type = XFastTrie!(K, treap_type);

    xft_type xft;
    size_t wordsize = 8 * K.sizeof;

    this () {
        xft = new xft_type();
    }

    @property
    size_t length () {
        return size;
    }

    bool insert (immutable K x, V v) {
        auto suc = xft.successor(x);
        // もしsuccessorがいなければ、K.maxにTreapを追加し、そこに格納
        if (suc == null) {
            size++;
            auto tr = new treap_type();
            tr.insert(x, v);
            xft.insert(K.max, tr);
            return true;
        }

        // 追加
        auto tr = (*suc)[1];
        if (tr.insert(x, v)) {
            size++;

            // 確率1 / wで新しいTreapにsplitする。そうでなければsuccessorで見つかったTreapを利用。
            import std.random: uniform;
            if (uniform(0, wordsize) == 0) {
                // x以下を引き受ける
                auto ntr = tr.split(x + 1);
                xft.insert(x, ntr);
            }
            return true;
        }

        return false;
    }

    bool remove (immutable K x) {
        auto suc = xft.successor(x);
        if (suc == null) return false;

        // まず削除を試みる。
        if (!(*suc)[1].remove(x)) return false;
        size--;

        // xftにおける登録キーであるか確かめる。
        if ((*suc)[0] != x) return true;

        // K.maxのtreapであれば消さない
        if (x == K.max) return true;

        // 有効なinsertの後であることを仮定できるので、必ず次のtreapが存在。
        auto merge_to = xft.successor(x + 1);
        assert(merge_to != null);

        // マージ
        (*merge_to)[1].merge((*suc)[1]);

        // もとのtreapを消す
        xft.remove(x);

        return true;
    }

    Tuple!(immutable K, V)* find (immutable K x) {
        auto suc = xft.successor(x);
        if (suc == null) return null;
        return (*suc)[1].find(x);
    }

    Tuple!(immutable K, V)* successor (immutable K x) {
        auto suc = xft.successor(x);
        if (suc == null) return null;
        return (*suc)[1].successor(x);
    }

    // predecessorは単に仕事を投げればよいわけではないので注意
    Tuple!(immutable K, V)* predecessor (immutable K x) {
        auto suc = xft.successor(x);
        if (suc != null) {
            auto p = (*suc)[1].predecessor(x);
            if (p != null) return p;
        }
        if (x == 0) return null;

        auto pre = xft.predecessor(x - 1);
        if (pre == null) return null;
        return (*pre)[1].predecessor(x);
    }
}
