module inthebloom.unordered_set.hash;

import std.traits: Unqual;
import std.random: uniform;

int multiplicative_hash (T) (T x, int d)
    if (is(Unqual!(T) == uint) ||
        is(Unqual!(T) == ulong))
{
    static if (is(Unqual!(T) == T)) {
        static T z = 0;
        if (z == 0) z = uniform(0, T.max >> 1 + 1) << 1 + 1;
        if (d == 0) return 0;

        import std.stdio;
        writeln(8 * T.sizeof - d);
        auto v = cast(Unqual!(T))(z) * x;
        return (cast(Unqual!(T))(z) * x) >>> (8 * T.sizeof - d);
    }
    else {
        return multiplicative_hash!(Unqual!(T))(x, d);
    }
}
