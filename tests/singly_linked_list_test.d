unittest {
    import std;
    import inthebloom.list;
    auto slist = SinglyLinkedList!(int)();

    const int N = 10;
    foreach (i; 0..N) {
        slist.insert_back(i);
    }

    assert(slist.length == N);

    auto rem = iota(N).array;
    foreach (i; 0..N) {
        int j = uniform(i, N);
        swap(i, j);
    }

    writeln(slist.input_range());
    slist.remove_kth(N - 1);
    slist.remove_kth(N - 2);
    writeln(slist.input_range());
}
