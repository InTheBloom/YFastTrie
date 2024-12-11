// ライブラリを1ファイルにまとめる君
// rdmdが必要です。
// プロジェクトルートで
// $ rdmd bundle.d
// を行うと、onlinejudge/combined.dが作られます。

import std;

string libdir = "inthebloom";
string output_dir = "onlinejudge";
string output_name = "combined.d";

int main () {
    string current = getcwd();
    string target = buildNormalizedPath(current, libdir);

    if (!target.exists() || !target.isDir()) {
        stderr.writefln("lib directory %s is not found.", target);
        return 1;
    }

    auto src = dirEntries(target, SpanMode.depth).filter!((e) => e.isFile() && e.name.endsWith(".d"));
    auto output = File(buildNormalizedPath(output_dir, output_name), "w");
    auto bannedexp = regex("import {1,}inthebloom");
    string[] result;

    foreach (file; src) {
        writefln("bundle file: %s", file.name);
        auto validlines = readText(file.name).split("\n").filter!((line) => line.indexOf("module") == -1 && line.matchFirst(bannedexp).empty);

        foreach (line; validlines) {
            result ~= line;
        }
    }

    // 空行の圧縮
    auto compressed = () {
        auto re = regex("[ |\x3000]{1,}");
        const int N = result.length.to!int;
        foreach (i; 0..N) {
            if (result[i].matchFirst(re).length == result[i].length) {
                result[i] = "";
            }
        }

        string[] res;

        int l = 0, r = 0;
        while (l < N) {
            while (r < N) {
                if (result[l] != result[r]) break;
                r++;
            }

            res ~= result[l];

            l = r;
        }
        return res;
    }();

    foreach (line; compressed) {
        output.writeln(line);
    }

    return 0;
}
