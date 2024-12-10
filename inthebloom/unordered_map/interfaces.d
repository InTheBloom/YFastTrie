module inthebloom.unordered_map.interfaces;

import std.typecons: Tuple;

interface UnorderedMap (keytype, valuetype)
{
    size_t length ();
    bool insert (immutable keytype x, valuetype v);
    bool remove (immutable keytype x);
    Tuple!(immutable keytype, valuetype)* find (immutable keytype x);
};
