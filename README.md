# YFastTrie

# 内容

- 単方向連結リスト (inthebloom/list/singly\_linked\_list.d)
- 乗算ハッシュ法 (inthebloom/unordered\_map/hash.d)
- チェイン法 + 乗算ハッシュ法を用いたmap (inthebloom/unordered\_map/chained\_hash\_table.d)
- successorクエリとpredecessorクエリをサポートするbinary trieによるmap (inthebloom/sorted\_map/binarytrie.d)
- 乱数により定まる優先度を用いて高さの期待値を抑える平衡二分探索木treapによるmap (inthebloom/sorted\_map/treap.d)
- 各層に存在するノードををハッシュで持ち、一致点の境界を二分探索することでO(log w)時間の検索をサポートするbinary trie (inthebloom/sorted\_map/xfasttrie.d)
- X-Fast Trieと二分探索木の二次構造を用いることにより、空間O(N)と追加/削除O(log w)を達成するbinary trie (inthebloom/sorted\_map/yfasttrie.d)

# その他ファイル
- dubに依存しない簡易テストランナー (testrunner.d)
- 競技プログラミング向けソースコードバンドラ (bundle.d)
- ありえないほど雑な各種テスト (tests/\*)

# 参考資料 (あなたもY-Fast Trie組みませんか？)
- みんなのデータ構造、Pat Morin著、堀江慧、陣内佑、田中康隆訳、ラムダノート
    - 5章、6章、7章、13章が特に関係します。
    - なんと、[ここで](https://sites.google.com/view/open-data-structures-ja/home)無料で読めます。私が2000円払っておいたので是非覗いてください。

- プログラミングコンテストでのデータ構造2 ～平衡二分探索木編～、秋葉拓哉著、[https://www.slideshare.net/slideshow/2-12188757/12188757](https://www.slideshare.net/slideshow/2-12188757/12188757)
    - さっくりと解説されているので、初めての人はこれだけ見て組むのはしんどいです。(1敗) 他のリソースも活用することをお勧めします。

- Predecessorを高速に解くデータ構造: Y-Fast Trie、goonew著、[https://qiita.com/goonew/items/6ffac4b5e48dc05ca884](https://qiita.com/goonew/items/6ffac4b5e48dc05ca884)
    - たくさんの図があり、丁寧に解説されています。binary trieでsuccessorクエリをサポートする方法が特にわかりやすいです。

- Predecessor Problem、[https://judge.yosupo.jp/problem/predecessor\_problem](https://judge.yosupo.jp/problem/predecessor_problem)
    - 自力で行うより信頼性が高いテストを行うことができます。

- Associative Array、[https://judge.yosupo.jp/problem/associative\_array](https://judge.yosupo.jp/problem/associative_array)
    - 同様です。

# ライセンス
NYSL Version 0.9982
[NYSL](https://www.kmonos.net/nysl/)
