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
    Pid[] pids;
    File[] outputs, errors;
    foreach (testfile; testfiles) {
        writefln("enqueue test: %s", testfile.name);
        auto o = File(randomUUID().toString(), "w");
        auto e = File(randomUUID().toString(), "w");
        scope(exit) o.name.remove();
        scope(exit) e.name.remove();
        auto pid = spawnProcess(["rdmd", "-unittest", "-main", testfile.name], stdin, o, e);
        scope(exit) wait(pid);
        pids ~= pid;
        outputs ~= o;
        errors ~= e;
    }

    foreach (i, pid; pids) {
        auto res = wait(pid);
        if (res == 0) {
            writefln("verdict OK: %s", testfiles[i].name);
            continue;
        }

        writefln("verdict NG: %s", testfiles[i].name);
        writeln("stdout:");
        outputs[i].open(outputs[i].name, "r");
        if (!outputs[i].eof) {
            outputs[i].byLine.each!writeln;
        }
        writeln("stderr:");
        errors[i].open(errors[i].name, "r");
        if (!errors[i].eof) {
            errors[i].byLine.each!writeln;
        }
    }
}
