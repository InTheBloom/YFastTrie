module inthebloom.unordered_set.chained_hash_table;

import inthebloom.unordered_set.interfaces;
import std.traits: Unqual;

class NonNegativeKeyChainedHashTable (T) : UnorderedSet!(T)
    if (is(Unqual!(T) == uint) ||
        is(Unqual!(T) == ulong) ||
        is(Unqual!(typeof(T.init[0])) == uint) ||
        is(Unqual!(typeof(T.init[0])) == ulong)
        )
{
    static if (is(Unqual!(T) == uint) ||
               is(Unqual!(T) == ulong)) {
        alias uintof = (T x) => x;
    }
    static if (is(Unqual!(typeof(T.init[0])) == uint) ||
               is(Unqual!(typeof(T.init[0])) == ulong)) {
        alias uintof = (T x) => x[0];
    }

    import inthebloom.unordered_set.hash;
    import inthebloom.list;
    alias list = SinglyLinkedList!(T);

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
                new_table[multiplicative_hash(uintof(*element_ptr), table_size_bits)].insert_back(*element_ptr);
            }
        }
        table = new_table;
    }

    bool insert (T x) {
        // 見つかれば更新
        auto ret = find(uintof(x));
        if (ret != null) {
            *ret = x;
            return false;
        }

        // 不変条件: (要素数) <= (テーブルサイズ)を保つ。
        if ((1 << table_size_bits) < size) {
            resize();
        }

        table[multiplicative_hash(uintof(x), table_size_bits)].insert_back(x);
        size++;
        return true;
    }

    bool remove (typeof(uintof(T.init)) x) {
        int index = multiplicative_hash(x, table_size_bits);
        auto r = table[index].ptr_input_range();
        while (!r.empty()) {
            if (x == uintof(*r.front())) {
                table[index].remove_kth(r.position);
                size--;
                return true;
            }
            r.popFront();
        }
        return false;
    }

    T* find (typeof(uintof(T.init)) x) {
        int index = multiplicative_hash(x, table_size_bits);
        auto r = table[index].ptr_input_range();
        foreach (element_ptr; r) {
            if (x == uintof(*element_ptr)) return element_ptr;
        }
        return null;
    }
}
