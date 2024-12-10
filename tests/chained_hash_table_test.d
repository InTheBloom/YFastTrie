unittest {
    import inthebloom.unordered_set;
    import std;
    auto mp = new NonNegativeKeyChainedHashTable!(uint, int[])();
    const int N = 100;
    auto key = new uint[](N);
    auto arr = new int[][](N);
    foreach (i; 0..N) {
        key[i] = uniform(0, uint.max);
        arr[i] = iota(uniform(0, 10)).map!((x) => uniform(0, 20)).array;
    }

    foreach (i; 0..N) {
        assert(mp.length == i);
        mp.insert(key[i], arr[i]);
        assert(mp.length == i + 1);
    }

    foreach (i; 0..N) {
        assert((*mp.find(key[i]))[1] == arr[i]);
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
