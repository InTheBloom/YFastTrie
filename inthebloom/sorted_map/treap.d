module inthebloom.sorted_map.treap;

import inthebloom.sorted_map.interfaces;
import inthebloom.unordered_map;

import std.traits: Unqual;
import std.typecons: Tuple, tuple;

struct TreapNode (V) {
    alias node = TreapNode!(V);
    alias node_ptr = node*;

    long priority = 0;
    int size = 0;
    V *value;
    node_ptr left = null, right = null;
}

// treapに関しては整数に絞る必要ないが、実装上の都合で制限を行う。
class Treap (K, V): SortedMap!(K, V)
    if (is(Unqual!(K) == uint) ||
        is(Unqual!(K) == ulong) ||
        is(Unqual!(K) == int) ||
        is(Unqual!(K) == long))
{
    alias value = Tuple!(immutable K, V);
    alias node = TreapNode!(value);
    alias node_ptr = node*;

    node_ptr root = null;

    this () {
    }

    @property
    size_t length () {
        if (root == null) return 0;
        return root.size;
    }

    static node_ptr internal_merge (node_ptr lt, node_ptr rt) {
        if (lt == null || rt == null) return lt == null ? rt : lt;
        import std.algorithm: swap;
        if ((*rt.value)[0] < (*lt.value)[0]) swap(lt, rt);

        if (rt.priority < lt.priority) {
            lt.size += rt.size;
            auto rsub = internal_split(rt, (*lt.value)[0]);
            lt.left = internal_merge(lt.left, rsub[0]);
            lt.right = internal_merge(lt.right, rsub[1]);
            return lt;
        }

        rt.size += lt.size;
        auto lsub = internal_split(lt, (*rt.value)[0]);
        rt.left = internal_merge(rt.left, lsub[0]);
        rt.right = internal_merge(rt.right, lsub[1]);
        return rt;
    }

    static Tuple!(node_ptr, node_ptr) internal_split (node_ptr t, K bound) {
        if (t == null) return tuple(t, t);
        if (bound <= (*t.value)[0]) {
            auto v = internal_split(t.left, bound);
            if (v[0] != null) t.size -= v[0].size;
            t.left = v[1];
            return tuple(v[0], t);
        }

        auto v = internal_split(t.right, bound);
        if (v[1] != null) t.size -= v[1].size;
        t.right = v[0];
        return tuple(t, v[1]);
    }

    // 外部向け
    Treap!(K, V) split (K x) {
        auto v = internal_split(root, x);
        root = v[0];
        auto res = new Treap!(K, V)();
        res.root = v[1];
        return res;
    }

    void merge (Treap!(K, V) x) {
        root = internal_merge(root, x.root);
    }

    bool insert (immutable K x, V v) {
        auto search = find(x);
        if (search != null) {
            (*search)[1] = v;
            return false;
        }

        import std.random: uniform;
        node_ptr new_node = new node();
        new_node.priority = uniform!"[]"(long.min, long.max);
        new_node.size = 1;
        new_node.value = new value(x, v);

        root = internal_merge(root, new_node);
        return true;
    }

    bool remove (immutable K x) {
        auto t1 = internal_split(root, x);
        if (x == K.max) {
            root = t1[0];
            return t1[1] != null;
        }

        auto t2 = internal_split(t1[1], x + 1);
        root = internal_merge(t1[0], t2[1]);
        return t2[0] != null;
    }

    Tuple!(immutable K, V)* find (immutable K x) {
        auto search = successor(x);
        if (search == null) return null;
        return (*search)[0] == x ? search : null;
    }
    Tuple!(immutable K, V)* successor (immutable K x) {
        node_ptr cur = root;
        node_ptr last = null;
        // ピッタリを探す過程で、「現在位置の値がxより大きい」が最後に発生したノードを覚えておけばよい。
        while (cur != null) {
            auto v = (*cur.value)[0];
            if (v == x) return cur.value;
            if (x < v) {
                last = cur;
                cur = cur.left;
            }
            else {
                cur = cur.right;
            }
        }

        return last == null ? null : last.value;
    }

    Tuple!(immutable K, V)* predecessor (immutable K x) {
        node_ptr cur = root;
        node_ptr last = null;
        while (cur != null) {
            auto v = (*cur.value)[0];
            if (v == x) return cur.value;
            if (v < x) {
                last = cur;
                cur = cur.right;
            }
            else {
                cur = cur.left;
            }
        }

        return last == null ? null : last.value;
    }
}
