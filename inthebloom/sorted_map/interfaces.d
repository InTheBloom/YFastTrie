module inthebloom.sorted_map.interfaces;

import std.typecons: Tuple;

interface SortedMap (keytype, valuetype) {
    @property
    size_t length ();
    bool insert (immutable keytype x, valuetype v);
    bool remove (immutable keytype x);
    Tuple!(immutable keytype, valuetype)* find (immutable keytype x);
    Tuple!(immutable keytype, valuetype)* successor (immutable keytype x);
    Tuple!(immutable keytype, valuetype)* predecessor (immutable keytype x);
};
