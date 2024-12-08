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

    this () {
    }

    size_t length () {
        return 0;
    }

    bool insert (T x) {
        return true;
    }

    bool remove (T x) {
        return true;
    }

    T find (T x) {
        return T.init;
    }
}
