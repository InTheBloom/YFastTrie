module inthebloom.sorted_map.binarytrie;

import inthebloom.sorted_map.interfaces;

import std.traits: Unqual;
import std.typecons: Tuple, tuple;

struct BinaryTrieNode (V) {
    alias node_ptr = BinaryTrieNode*;
    node_ptr parent = null, left = null, right = null, jump = null;
    alias prev = left;
    alias next = right;
    V* value_ptr = null;
}

class BinaryTrie (K, V): SortedMap!(K, V)
    if (is(Unqual!(K) == uint) ||
        is(Unqual!(K) == ulong))
{
    alias value = Tuple!(immutable K, V);
    alias node = BinaryTrieNode!(value);
    alias node_ptr = node*;
    node_ptr root, head, tail;
    immutable size_t wordsize = 8 * K.sizeof;
    size_t size = 0;

    this () {
        root = new node();
        head = new node();
        tail = new node();
        head.next = tail;
        tail.prev = head;
    }

    @property
    size_t length () {
        return size;
    }

    bool insert (immutable K x, V v) {
        // 一致点の限界までくだる
        int level = 0;
        node_ptr cur = root;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                if (cur.left == null) break;
                cur = cur.left;
            }
            else {
                if (cur.right == null) break;
                cur = cur.right;
            }
            level++;
        }

        // 等しい値があったので、更新して終了
        if (level == wordsize) {
            (*cur.value_ptr)[1] = v;
            return false;
        }
        size++;

        // あとで隣接リストに繋ぐために、分岐点でどっちの枝がないのか確かめる。
        byte bound_direction = 1;
        if (((x >> (wordsize - level - 1)) & 1) == 0) bound_direction = 0;

        // 葉までノードを作成する
        node_ptr to_end = cur;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                to_end.left = new node(parent: to_end);
                to_end = to_end.left;
            }
            else {
                to_end.right = new node(parent: to_end);
                to_end = to_end.right;
            }
            level++;
        }
        // 値を追加
        to_end.value_ptr = new value(x, v);

        // 連結リストにつなぐ(jmpがsuccessorまたはpredecessorになる)
        // ただし、初回挿入(jmpがnull)は必ずsuccessorであるとみなす
        node_ptr jmp = cur.jump;
        if (jmp == null) {
            to_end.next = tail;
            to_end.prev = tail.prev;
            tail.prev.next = to_end;
            tail.prev = to_end;
        }
        else if (bound_direction == 0) {
            to_end.next = jmp;
            to_end.prev = jmp.prev;
            jmp.prev.next = to_end;
            jmp.prev = to_end;
        }
        else {
            to_end.prev = jmp;
            to_end.next = jmp.next;
            jmp.next.prev = to_end;
            jmp.next = to_end;
        }

        // jumpの更新
        // 条件は、
        // - 左の子がなくて、jumpがない or 今のjump先超過
        // - 右の子がなくて、jumpがない or 今のjump先未満
        // のどれか
        cur = to_end.parent;
        while (cur != null) {
            if ((cur.left == null && (cur.jump == null || x < (*cur.jump.value_ptr)[0])) ||
                (cur.right == null && (cur.jump == null || (*cur.jump.value_ptr)[0] < x))) {
                cur.jump = to_end;
            }

            // 子を2個持っていればjumpポインタを外す(不一致境界になりえないので)
            if (cur.left != null && cur.right != null) {
                cur.jump = null;
            }

            cur = cur.parent;
        }
        return true;
    }

    bool remove (immutable K x) {
        // 葉まで掘る
        int level = 0;
        node_ptr cur = root;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                if (cur.left == null) return false;
                cur = cur.left;
            }
            else {
                if (cur.right == null) return false;
                cur = cur.right;
            }
            level++;
        }
        size--;

        // 連結リストをつなぎかえる
        cur.prev.next = cur.next;
        cur.next.prev = cur.prev;

        // ノードの削除
        node_ptr to_root = cur;
        while (0 < level) {
            to_root = to_root.parent;
            level--;
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                to_root.left = null;
            }
            else {
                to_root.right = null;
            }
            if (to_root.left != null || to_root.right != null) break;
        }

        // すべての要素が消滅した場合、nullに設定
        if (level == 0 && size == 0) {
            to_root.jump = null;
            return true;
        }

        // jumpがなかった分岐点からjumpが生える
        if (((x >> (wordsize - level - 1)) & 1) == 0) {
            to_root.jump = cur.next;
        }
        else {
            to_root.jump = cur.prev;
        }

        // jumpとしてcurを指していたノードの更新
        while (0 < level) {
            to_root = to_root.parent;
            level--;
            if (to_root.jump != cur) continue;
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                to_root.jump = cur.next;
            }
            else {
                to_root.jump = cur.prev;
            }
        }

        return true;
    }

    Tuple!(immutable K, V)* find (immutable K x) {
        if (size == 0) return null;
        int level = 0;
        node_ptr cur = root;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                if (cur.left == null) return null;
                cur = cur.left;
            }
            else {
                if (cur.right == null) return null;
                cur = cur.right;
            }
            level++;
        }
        return cur.value_ptr;
    }

    Tuple!(immutable K, V)* successor (immutable K x) {
        if (size == 0) return null;
        int level = 0;
        node_ptr cur = root;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                if (cur.left == null) break;
                cur = cur.left;
            }
            else {
                if (cur.right == null) break;
                cur = cur.right;
            }
            level++;
        }
        if (level == wordsize) return cur.value_ptr;

        // jumpがsuccessor
        if (((x >> (wordsize - level - 1)) & 1) == 0) {
            return cur.jump.value_ptr;
        }
        return cur.jump.next.value_ptr;
    }

    Tuple!(immutable K, V)* predecessor (immutable K x) {
        if (size == 0) return null;
        int level = 0;
        node_ptr cur = root;
        while (level < wordsize) {
            if (((x >> (wordsize - level - 1)) & 1) == 0) {
                if (cur.left == null) break;
                cur = cur.left;
            }
            else {
                if (cur.right == null) break;
                cur = cur.right;
            }
            level++;
        }
        if (level == wordsize) return cur.value_ptr;

        // jumpがsuccessor
        if (((x >> (wordsize - level - 1)) & 1) == 0) {
            return cur.jump.prev.value_ptr;
        }
        return cur.jump.value_ptr;
    }
}
