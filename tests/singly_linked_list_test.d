unittest {
    import std;
    import inthebloom.list;
    auto slist = SinglyLinkedList!(int)();

    const sizes = [1, 2, 3, 4, 10];
    // insert_back(), remove_front()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            assert(slist.length == i);
            slist.insert_back(i);
            assert(slist.length == i + 1);
        }

        auto r = iota(N).array;
        foreach (i; 0..N) {
            assert(slist.length == N - i);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
            slist.remove_front();
            r = r[1..$];
            assert(slist.length == N - i - 1);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
        }
    }

    // inert_front(), remove_front()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            assert(slist.length == i);
            slist.insert_front(i);
            assert(slist.length == i + 1);
        }

        auto r = iota(N).array.reverse;
        foreach (i; 0..N) {
            assert(slist.length == N - i);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
            r = r[1..$];
            slist.remove_front();
            assert(slist.length == N - i - 1);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
        }
    }

    // insert_back(), remove_kth()
    foreach (N; sizes) {
        foreach (i; 0..N) {
            assert(slist.length == i);
            slist.insert_back(i);
            assert(slist.length == i + 1);
        }

        assert(slist.length == N);

        auto r = iota(N).array;
        foreach (i; 0..N) {
            assert(slist.length == N - i);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
            int k = uniform(0, N - i);
            slist.remove_kth(k);
            r = r[0..k] ~ r[k + 1..$];
            assert(slist.length == N - i - 1);
            assert(equal(slist.ptr_input_range().map!((x) => *x), r));
        }
    }
}
