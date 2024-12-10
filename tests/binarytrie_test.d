import inthebloom.sorted_map;
import std;

unittest {
    // insert remove length
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto btrie = new BinaryTrie!(ulong, int)();
        auto key = iota(N).map!((x) => uniform(0, ulong.max)).array;
        int len = 0;
        foreach (count, i; key.enumerate(0)) {
            assert(btrie.length == len);
            if (btrie.insert(i, 0)) len++;
            assert(btrie.length == len);
        }

        key.randomShuffle;
        foreach (count, i; key.enumerate(0)) {
            assert(btrie.length == len);
            if (btrie.remove(i)) len--;
            assert(btrie.length == len);
        }

        assert(btrie.head.next == btrie.tail);
        assert(btrie.tail.prev == btrie.head);
    }
}

unittest {
    // ユニークな値に対するinsert remove
    const size = [1, 2, 3, 4, 10, 10000];
    foreach (N; size) {
        auto btrie = new BinaryTrie!(ulong, int)();
        auto key = iota(N).map!((x) => uniform(0, ulong.max)).array.sort.uniq.array;

        foreach (e; key) {
            assert(btrie.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!btrie.insert(e, 0));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(btrie.remove(e));
        }
        key.randomShuffle;
        foreach (e; key) {
            assert(!btrie.remove(e));
        }
    }
}

unittest {
    auto btrie = new BinaryTrie!(ulong, ulong)();
    auto key = iota(10).map!((x) => cast(ulong)x).array;
    foreach (k; key) {
        assert(btrie.insert(k, k));
        assert((*btrie.find(k))[1] == k);
    }
    // 存在しないキーを探す
    assert(btrie.find(ulong.max) is null);
}

unittest {
    auto btrie = new BinaryTrie!(ulong, ulong)();
    auto key = [5UL, 10UL, 15UL, 20UL];
    foreach (k; key) btrie.insert(k, k);

    assert((*btrie.successor(0))[0] == 5);
    assert((*btrie.successor(7))[0] == 10);
    assert(btrie.successor(21) is null);

    assert(btrie.predecessor(4) is null);
    assert((*btrie.predecessor(17))[0] == 15);
    assert((*btrie.predecessor(25))[0] == 20);
}

unittest {
    auto btrie = new BinaryTrie!(ulong, ulong)();
    assert(btrie.length == 0);
    assert(btrie.find(0) is null);
    assert(btrie.successor(0) is null);
    assert(btrie.predecessor(0) is null);

    // 最大値の確認
    assert(btrie.insert(ulong.max, 1));
    assert((*btrie.find(ulong.max))[1] == 1);
    assert(btrie.successor(ulong.max) !is null);
    assert((*btrie.predecessor(ulong.max))[0] == ulong.max);
}

unittest {
    auto btrie = new BinaryTrie!(ulong, int)();

    // キーと値を挿入
    auto keys = [5UL, 10UL, 15UL, 20UL, 25UL];
    foreach (k; keys) btrie.insert(k, cast(int)k);

    // 挿入確認
    foreach (k; keys) {
        assert((*btrie.find(k))[1] == cast(int)k);
    }

    // 削除操作と確認
    assert(btrie.remove(15UL)); // 中間キーを削除
    assert(btrie.find(15UL) is null); // 削除確認
    assert(btrie.remove(15UL) == false); // 再削除は失敗

    assert((*btrie.successor(11UL))[0] == 20UL); // 次のキーを確認
    assert((*btrie.predecessor(19UL))[0] == 10UL); // 前のキーを確認

    assert(btrie.remove(5UL)); // 最小キーを削除
    assert(btrie.successor(0UL) !is null && (*btrie.successor(0UL))[0] == 10UL);

    assert(btrie.remove(25UL)); // 最大キーを削除
    assert(btrie.predecessor(30UL) !is null && (*btrie.predecessor(30UL))[0] == 20UL);

    // 残りの要素をすべて削除
    assert(btrie.remove(10UL));
    assert(btrie.remove(20UL));
    assert(btrie.length == 0); // 全て削除後の確認
    assert(btrie.find(10UL) is null);
    assert(btrie.head.next == btrie.tail); // リスト状態確認
    assert(btrie.tail.prev == btrie.head);
}

unittest {
    auto btrie = new BinaryTrie!(ulong, int)();

    // ランダムキー生成
    auto keys = iota(100).map!((x) => uniform(0, ulong.max)).array;

    // 挿入操作
    foreach (k; keys) btrie.insert(k, cast(int)k);

    // 削除対象のランダムキー
    auto deleteKeys = keys.randomSample(keys.length / 2).array;
    foreach (k; deleteKeys) assert(btrie.remove(k));

    // 残存キーの確認
    auto remainingKeys = keys.filter!(k => deleteKeys.count(k) == 0).array;
    foreach (k; remainingKeys) {
        assert((*btrie.find(k))[1] == cast(int)k);
    }

    // 削除済みキーの確認
    foreach (k; deleteKeys) {
        assert(btrie.find(k) is null);
    }

    // 最終的なリストの整合性を確認
    assert(btrie.length == remainingKeys.length);
    assert(btrie.head.next !is btrie.tail); // リストが空ではない
    assert(btrie.tail.prev !is btrie.head);
}
