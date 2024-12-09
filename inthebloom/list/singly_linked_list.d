module inthebloom.list.singly_linked_list;

class EmptyListException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

class ListSizeExceededException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

struct SinglyLinkedListNode (T) {
    alias node_type = SinglyLinkedListNode!(T);
    alias node_ptr_type = node_type *;
    T value;
    node_ptr_type next = null;
}

struct SinglyLinkedList (T) {
    alias node_type = SinglyLinkedListNode!(T);
    alias node_ptr_type = node_type *;

    node_ptr_type head, tail;
    size_t size = 0;

    void insert_front (T value) {
        size++;
        if (size == 1) {
            head = new node_type(value, null);
            tail = head;
            return;
        }

        auto sec = head;
        head = new node_type(value, null);
        head.next = sec;
    }

    void insert_back (T value) {
        size++;
        if (size == 1) {
            tail = new node_type(value, null);
            head = tail;
            return;
        }

        auto last = new node_type(value, null);
        tail.next = last;
        tail = last;
    }

    void remove_front () {
        if (size == 0) {
            throw new EmptyListException("Cannot remove an element from an empty list.");
        }

        size--;
        if (size == 0) {
            head = null, tail = null;
            return;
        }
        head = head.next;
    }

    void remove_kth (size_t k) {
        if (size <= k) {
            import std.format: format;
            throw new ListSizeExceededException(format("Attempted to access index k = %s, but the list has only %s elements.", k, size));
        }
        node_ptr_type pre = null, cur = head;
        foreach (i; 0..k) {
            pre = cur;
            cur = cur.next;
        }

        size--;
        if (cur == head && cur == tail) {
            head = null, tail = null;
            return;
        }
        if (cur == head) {
            head = head.next;
            return;
        }
        if (cur == tail) {
            tail = pre;
            tail.next = null;
            return;
        }

        pre.next = cur.next;
    }

    @property
    size_t length () {
        return size;
    }

    auto input_range () {
        struct SinglyLinkedListRange (T) {
            // input range
            node_ptr_type head = null;
            size_t size = 0;

            @property
            bool empty () {
                return size == 0;
            }

            T front () {
                if (size == 0) {
                    throw new EmptyListException("Cannot access front element from an empty list.");
                }
                return head.value;
            }
            void popFront () {
                if (size == 0) {
                    throw new EmptyListException("Cannot remove an element from an empty list.");
                }
                head = head.next;
                size--;
            }
        }

        return SinglyLinkedListRange!(T)(head, size);
    }
}
