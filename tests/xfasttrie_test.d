import std;
import inthebloom.sorted_map.xfasttrie;

unittest {
    writeln("test1");
    stdout.flush;
    // insert remove length
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto xfasttrie = new XFastTrie!(uint, int)();
        auto key = iota(N).map!((x) => uniform(0, uint.max)).array;
        int len = 0;
        foreach (count, i; key.enumerate(0)) {
            assert(xfasttrie.length == len);
            if (xfasttrie.insert(i, 0)) len++;
            assert(xfasttrie.length == len);
        }

        key.randomShuffle;
        foreach (count, i; key.enumerate(0)) {
            assert(xfasttrie.length == len);
            if (xfasttrie.remove(i)) len--;
            assert(xfasttrie.length == len);
        }

        assert(xfasttrie.head.next == xfasttrie.tail);
        assert(xfasttrie.tail.prev == xfasttrie.head);
    }
}

unittest {
    writeln("test2");
    stdout.flush;
    // ユニークな値に対するinsert remove
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto xfasttrie = new XFastTrie!(ulong, int)();
        auto key = iota(N).map!((x) => uniform(0, ulong.max)).array.sort.uniq.array;

        foreach (e; key) {
            assert(xfasttrie.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!xfasttrie.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(xfasttrie.remove(e));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!xfasttrie.remove(e));
        }
    }
}

unittest {
    writeln("test3");
    stdout.flush;
    auto xfasttrie = new XFastTrie!(ulong, ulong)();
    auto key = iota(10).map!((x) => cast(ulong)x).array;
    foreach (k; key) {
        assert(xfasttrie.insert(k, k));
        assert((*xfasttrie.find(k))[1] == k);
    }
    // 存在しないキーを探す
    assert(xfasttrie.find(ulong.max) is null);
}

unittest {
    writeln("test4");
    stdout.flush;
    auto xfasttrie = new XFastTrie!(ulong, ulong)();
    auto key = [5UL, 10UL, 15UL, 20UL];
    foreach (k; key) xfasttrie.insert(k, k);

    assert((*xfasttrie.successor(0))[0] == 5);
    assert((*xfasttrie.successor(7))[0] == 10);
    assert(xfasttrie.successor(21) is null);

    assert(xfasttrie.predecessor(4) is null);
    assert((*xfasttrie.predecessor(17))[0] == 15);
    assert((*xfasttrie.predecessor(25))[0] == 20);
}

unittest {
    writeln("test5");
    stdout.flush;
    auto xfasttrie = new XFastTrie!(ulong, ulong)();
    assert(xfasttrie.length == 0);
    assert(xfasttrie.find(0) is null);
    assert(xfasttrie.successor(0) is null);
    assert(xfasttrie.predecessor(0) is null);

    // 最大値の確認
    assert(xfasttrie.insert(ulong.max, 1));
    assert((*xfasttrie.find(ulong.max))[1] == 1);
    assert(xfasttrie.successor(ulong.max) !is null);
    assert((*xfasttrie.predecessor(ulong.max))[0] == ulong.max);
}

unittest {
    writeln("test6");
    stdout.flush;
    auto xfasttrie = new XFastTrie!(ulong, int)();

    // キーと値を挿入
    auto keys = [5UL, 10UL, 15UL, 20UL, 25UL];
    foreach (k; keys) xfasttrie.insert(k, cast(int)k);

    // 挿入確認
    foreach (k; keys) {
        assert((*xfasttrie.find(k))[1] == cast(int)k);
    }

    // 削除操作と確認
    assert(xfasttrie.remove(15UL)); // 中間キーを削除
    assert(xfasttrie.find(15UL) is null); // 削除確認
    assert(xfasttrie.remove(15UL) == false); // 再削除は失敗

    assert((*xfasttrie.successor(11UL))[0] == 20UL); // 次のキーを確認
    assert((*xfasttrie.predecessor(19UL))[0] == 10UL); // 前のキーを確認

    assert(xfasttrie.remove(5UL)); // 最小キーを削除
    assert(xfasttrie.successor(0UL) !is null && (*xfasttrie.successor(0UL))[0] == 10UL);

    assert(xfasttrie.remove(25UL)); // 最大キーを削除
    assert(xfasttrie.predecessor(30UL) !is null && (*xfasttrie.predecessor(30UL))[0] == 20UL);

    // 残りの要素をすべて削除
    assert(xfasttrie.remove(10UL));
    assert(xfasttrie.remove(20UL));
    assert(xfasttrie.length == 0); // 全て削除後の確認
    assert(xfasttrie.find(10UL) is null);
    assert(xfasttrie.head.next == xfasttrie.tail); // リスト状態確認
    assert(xfasttrie.tail.prev == xfasttrie.head);
}

unittest {
    writeln("test7");
    stdout.flush;
    auto xfasttrie = new XFastTrie!(ulong, int)();

    // ランダムキー生成
    auto keys = iota(100).map!((x) => uniform(0, ulong.max)).array;

    // 挿入操作
    foreach (k; keys) xfasttrie.insert(k, cast(int)k);

    // 削除対象のランダムキー
    auto deleteKeys = keys.randomSample(keys.length / 2).array;
    foreach (k; deleteKeys) assert(xfasttrie.remove(k));

    // 残存キーの確認
    auto remainingKeys = keys.filter!(k => deleteKeys.count(k) == 0).array;
    foreach (k; remainingKeys) {
        assert((*xfasttrie.find(k))[1] == cast(int)k);
    }

    // 削除済みキーの確認
    foreach (k; deleteKeys) {
        assert(xfasttrie.find(k) is null);
    }

    // 最終的なリストの整合性を確認
    assert(xfasttrie.length == remainingKeys.length);
    assert(xfasttrie.head.next !is xfasttrie.tail); // リストが空ではない
    assert(xfasttrie.tail.prev !is xfasttrie.head);
}
