module inthebloom.unordered_map.chained_hash_table;

import inthebloom.unordered_map.interfaces;
import std.traits: Unqual;
import std.typecons: Tuple, tuple;

class NonNegativeKeyChainedHashTable (K, V) : UnorderedMap!(K, V)
    if (is(Unqual!(K) == uint) ||
        is(Unqual!(K) == ulong))
{
    import inthebloom.unordered_map.hash;
    import inthebloom.list;
    alias list = SinglyLinkedList!(Tuple!(immutable(K), V));

    size_t size = 0;
    int table_size_bits = 0;
    list[] table;

    this () {
        table = new list[](1 << table_size_bits);
    }

    size_t length () {
        return size;
    }

    void resize () {
        table_size_bits++;
        list[] new_table = new list[](1 << table_size_bits);

        foreach (cell; table) {
            foreach (element_ptr; cell.ptr_input_range()) {
                new_table[multiplicative_hash((*element_ptr)[0], table_size_bits)].insert_back(*element_ptr);
            }
        }
        table = new_table;
    }

    bool insert (immutable K x, V v) {
        // 見つかれば更新
        auto ret = find(x);
        if (ret != null) {
            (*ret)[1] = v;
            return false;
        }

        // 不変条件: (要素数) <= (テーブルサイズ)を保つ。
        if ((1 << table_size_bits) < size) {
            resize();
        }

        table[multiplicative_hash(x, table_size_bits)].insert_back(tuple(x, v));
        size++;
        return true;
    }

    bool remove (immutable K x) {
        int index = multiplicative_hash(x, table_size_bits);
        auto r = table[index].ptr_input_range();
        while (!r.empty()) {
            if (x == (*r.front())[0]) {
                table[index].remove_kth(r.position);
                size--;
                return true;
            }
            r.popFront();
        }
        return false;
    }

    Tuple!(immutable K, V)* find (immutable K x) {
        int index = multiplicative_hash(x, table_size_bits);
        auto r = table[index].ptr_input_range();
        foreach (element_ptr; r) {
            if (x == (*element_ptr)[0]) return element_ptr;
        }
        return null;
    }
}
