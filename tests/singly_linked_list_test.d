unittest {
    import std;
    import inthebloom.list;
    auto slist = SinglyLinkedList!(int)();

    const sizes = [1, 2, 3, 4, 10];
    // insert_back(), remove_front()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            slist.insert_back(i);
        }

        assert(slist.length == N);

        auto r = iota(N).array;
        foreach (i; 0..N) {
            assert(equal(slist.input_range(), r));
            slist.remove_front();
            r = r[1..$];
            assert(equal(slist.input_range(), r));
        }
    }

    // inert_front(), remove_front()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            slist.insert_front(i);
        }

        assert(slist.length == N);

        auto r = iota(N).array.reverse;
        foreach (i; 0..N) {
            assert(equal(slist.input_range(), r));
            r = r[1..$];
            slist.remove_front();
            assert(equal(slist.input_range(), r));
        }
    }

    // insert_back(), remove_kth()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            slist.insert_back(i);
        }

        assert(slist.length == N);

        auto r = iota(N).array;
        foreach (i; 0..N) {
            assert(equal(slist.input_range(), r));
            int k = uniform(0, N - i);
            slist.remove_kth(k);
            r = r[0..k] ~ r[k + 1..$];
            assert(equal(slist.input_range(), r));
        }
    }
}
