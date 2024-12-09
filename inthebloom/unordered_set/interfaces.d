module inthebloom.unordered_set.interfaces;

interface UnorderedSet (T)
    if (is(immutable(T): T))
{
    size_t length ();
    bool insert (T x);
    bool remove (keytype) (keytype x);
    T* find (keytype) (keytype x);
};
