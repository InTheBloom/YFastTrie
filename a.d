void main () {
}

unittest {
    import std.random;
    import std.range;
    import std.algorithm;
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

    foreach (v; rem) {
        assert(slist.has_equal_value_node(v));
        slist.remove_first_equal_value_node(v);
        assert(!slist.has_equal_value_node(v));
    }
}
