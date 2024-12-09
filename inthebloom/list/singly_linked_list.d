module inthebloom.list.singly_linked_list;

class EmptyListException : Exception {
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

    bool has_equal_value_node (T value) {
        node_ptr_type cur = head;
        while (cur != null) {
            if (cur.value == value) return true;
            cur = cur.next;
        }
        return false;
    }

    bool remove_first_equal_value_node (T value) {
        node_ptr_type pre = null, cur = head;
        while (cur != null) {
            if (cur.value != value) {
                pre = cur;
                cur = cur.next;
                continue;
            }
            size--;
            if (cur == head && cur == tail) {
                head = null, tail = null;
                return true;
            }
            if (cur == head) {
                head = head.next;
                return true;
            }
            if (cur == tail) {
                tail = pre;
                return true;
            }

            pre.next = head.next;
            return true;
        }
        return false;
    }

    @property
    size_t length () {
        return size;
    }
}
