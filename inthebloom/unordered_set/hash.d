module inthebloom.unordered_set.hash;

import std.traits: Unqual;
import std.random: uniform;

int multiplicative_hash (uint x, int d) {
    static uint z = 0;
    if (z == 0) z = uniform(0, uint.max >> 1 + 1) << 1 + 1;
    if (d == 0) return 0;

    auto v = cast(uint)(z) * x;
    return cast(int)((cast(uint)(z) * x) >> (8 * uint.sizeof - d));
}

int multiplicative_hash (ulong x, int d) {
    static ulong z = 0;
    if (z == 0) z = uniform(0, ulong.max >> 1 + 1) << 1 + 1;
    if (d == 0) return 0;

    auto v = cast(ulong)(z) * x;
    return cast(int)((cast(ulong)(z) * x) >> (8 * ulong.sizeof - d));
}
