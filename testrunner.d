// 簡易テスト君
// プロジェクトルートで
// $ rdmd testrunner.d
// とすることで、tests/*test.dをrdmdにより実行します。フラグは-unittest -mainが渡されます。
// サブプロセスの戻り値が0でない場合、サブプロセスのstdoutとstderrの内容をメインプロセスのstdoutに流します。(なので、通るテストで出力を見たい場合、assertとかで落とす必要があります。)

import std;

string testfile_suffix = "test.d";
string testdir = "tests";

void main () {
    string current = getcwd();
    string target = buildNormalizedPath(current, testdir);
    if (!target.exists) {
        writefln("target dir %s does not exists.", target);
        return;
    }

    auto testfiles = dirEntries(target, SpanMode.shallow).filter!((e) => e.name.endsWith(testfile_suffix) && e.isFile()).array;

    auto status = new int[](testfiles.length);
    auto outputs = new string[](testfiles.length);
    auto errors = new string[](testfiles.length);
    foreach (i, testfile; testfiles.enumerate(0)) {
        writefln("enqueue test: %s", testfile.name);
        auto o = File(randomUUID().toString(), "w");
        auto e = File(randomUUID().toString(), "w");
        scope(exit) {
            outputs[i] = readText(o.name);
            o.name.remove();

            errors[i] = readText(e.name);
            e.name.remove();
        }
        auto pid = spawnProcess(["rdmd", "-unittest", "-main", testfile.name], stdin, o, e);
        scope(exit) status[i] = wait(pid);
    }

    foreach (i; 0..testfiles.length) {
        if (status[i] == 0) {
            writefln("verdict OK: %s", testfiles[i].name);
            continue;
        }

        writefln("verdict NG: %s", testfiles[i].name);
        writeln("stdout:");
        writeln(outputs[i]);
        writeln("stderr:");
        writeln(errors[i]);
    }
}
