unittest {
    import inthebloom.unordered_set;
    import std;
    auto mp = new NonNegativeKeyChainedHashTable!(Tuple!(uint, string))();
    const int N = 100;
    auto key = new uint[](N);
    auto str = new string[](N);
    foreach (i; 0..N) {
        key[i] = uniform(0, uint.max);
        str[i] = iota(uniform(0, 10)).map!((x) => cast(char)('a' + uniform(0, 26))).array.idup;
    }

    foreach (i; 0..N) {
        assert(mp.length == i);
        mp.insert(tuple(key[i], str[i]));
        assert(mp.length == i + 1);
    }

    foreach (i; 0..N) {
        assert((*mp.find(key[i]))[1] == str[i]);
    }

    foreach (i; 0..N) {
        assert(mp.length == N - i);
        mp.remove(key[i]);
        assert(mp.length == N - i - 1);
    }

    foreach (i; 0..N) {
        assert(mp.find(key[i]) == null);
    }
}
