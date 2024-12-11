import std;
import inthebloom.sorted_map.treap;

unittest {
    auto treap = new Treap!(int, int)();
    const int N = 10;
    foreach (i; 0..N) {
        assert(treap.insert(i, 0));
        writeln(treap.length);
    }

    foreach (i; 0..N) {
        assert(treap.remove(i));
        writeln(treap.length);
    }
}

unittest {
    writeln("test1");
    stdout.flush;
    // insert remove length
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto treap = new Treap!(uint, int)();
        auto key = iota(N).map!((x) => uniform(0, 100)).array;
        int len = 0;
        foreach (count, i; key.enumerate(0)) {
            assert(treap.length == len);
            if (treap.insert(i, 0)) len++;
            assert(treap.length == len);
        }

        key.randomShuffle;
        foreach (count, i; key.enumerate(0)) {
            assert(treap.length == len);
            if (treap.remove(i)) len--;
            assert(treap.length == len);
        }
    }
}

unittest {
    writeln("test2");
    stdout.flush;
    // ユニークな値に対するinsert remove
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto treap = new Treap!(ulong, int)();
        auto key = iota(N).map!((x) => uniform(0, ulong.max)).array.sort.uniq.array;

        foreach (e; key) {
            assert(treap.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!treap.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(treap.remove(e));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!treap.remove(e));
        }
    }
}

unittest {
    writeln("test3");
    stdout.flush;
    auto treap = new Treap!(ulong, ulong)();
    auto key = iota(10).map!((x) => cast(ulong)x).array;
    foreach (k; key) {
        assert(treap.insert(k, k));
        assert((*treap.find(k))[1] == k);
    }
    // 存在しないキーを探す
    assert(treap.find(ulong.max) is null);
}

unittest {
    writeln("test4");
    stdout.flush;
    auto treap = new Treap!(ulong, ulong)();
    auto key = [5UL, 10UL, 15UL, 20UL];
    foreach (k; key) treap.insert(k, k);

    assert((*treap.successor(0))[0] == 5);
    assert((*treap.successor(7))[0] == 10);
    assert(treap.successor(21) is null);

    assert(treap.predecessor(4) is null);
    assert((*treap.predecessor(17))[0] == 15);
    assert((*treap.predecessor(25))[0] == 20);
}

unittest {
    writeln("test5");
    stdout.flush;
    auto treap = new Treap!(ulong, ulong)();
    assert(treap.length == 0);
    assert(treap.find(0) is null);
    assert(treap.successor(0) is null);
    assert(treap.predecessor(0) is null);

    // 最大値の確認
    assert(treap.insert(ulong.max, 1));
    assert((*treap.find(ulong.max))[1] == 1);
    assert(treap.successor(ulong.max) !is null);
    assert((*treap.predecessor(ulong.max))[0] == ulong.max);
}

unittest {
    writeln("test6");
    stdout.flush;
    auto treap = new Treap!(ulong, int)();

    // キーと値を挿入
    auto keys = [5UL, 10UL, 15UL, 20UL, 25UL];
    foreach (k; keys) treap.insert(k, cast(int)k);

    // 挿入確認
    foreach (k; keys) {
        assert((*treap.find(k))[1] == cast(int)k);
    }

    // 削除操作と確認
    assert(treap.remove(15UL)); // 中間キーを削除
    assert(treap.find(15UL) is null); // 削除確認
    assert(treap.remove(15UL) == false); // 再削除は失敗

    assert((*treap.successor(11UL))[0] == 20UL); // 次のキーを確認
    assert((*treap.predecessor(19UL))[0] == 10UL); // 前のキーを確認

    assert(treap.remove(5UL)); // 最小キーを削除
    assert(treap.successor(0UL) !is null && (*treap.successor(0UL))[0] == 10UL);

    assert(treap.remove(25UL)); // 最大キーを削除
    assert(treap.predecessor(30UL) !is null && (*treap.predecessor(30UL))[0] == 20UL);

    // 残りの要素をすべて削除
    assert(treap.remove(10UL));
    assert(treap.remove(20UL));
    assert(treap.length == 0); // 全て削除後の確認
    assert(treap.find(10UL) is null);
}

unittest {
    writeln("test7");
    stdout.flush;
    auto treap = new Treap!(ulong, int)();

    // ランダムキー生成
    auto keys = iota(100).map!((x) => uniform(0, ulong.max)).array;

    // 挿入操作
    foreach (k; keys) treap.insert(k, cast(int)k);

    // 削除対象のランダムキー
    auto deleteKeys = keys.randomSample(keys.length / 2).array;
    foreach (k; deleteKeys) assert(treap.remove(k));

    // 残存キーの確認
    auto remainingKeys = keys.filter!(k => deleteKeys.count(k) == 0).array;
    foreach (k; remainingKeys) {
        assert((*treap.find(k))[1] == cast(int)k);
    }

    // 削除済みキーの確認
    foreach (k; deleteKeys) {
        assert(treap.find(k) is null);
    }

    // 最終的なリストの整合性を確認
    assert(treap.length == remainingKeys.length);
}
