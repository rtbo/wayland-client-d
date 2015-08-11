/+
 +  Wayland copyright:
 +  Copyright © 2008 Kristian Høgsberg
 +
 +  Permission is hereby granted, free of charge, to any person
 +  obtaining a copy of this software and associated documentation files
 +  (the "Software"), to deal in the Software without restriction,
 +  including without limitation the rights to use, copy, modify, merge,
 +  publish, distribute, sublicense, and/or sell copies of the Software,
 +  and to permit persons to whom the Software is furnished to do so,
 +  subject to the following conditions:
 +
 +  The above copyright notice and this permission notice (including the
 +  next paragraph) shall be included in all copies or substantial
 +  portions of the Software.
 +
 +  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 +  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 +  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 +  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 +  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 +  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 +  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 +  SOFTWARE.
 +/
/+
 +  D bindings copyright:
 +  Copyright © 2015 Rémi Thebault
 +/
module wayland.client.util;

import wayland.client.opaque_types;
import std.range;


enum WAYLAND_VERSION_MAJOR = 1;
enum WAYLAND_VERSION_MINOR = 8;
enum WAYLAND_VERSION_MICRO = 90;
enum WAYLAND_VERSION = "1.8.90";



extern (C) {



    struct wl_message {
        const (char*) name;
        const (char*) signature;
        const (wl_interface*)* types;
    }

    struct wl_interface {
        const (char*) name;
        int ver;
        int method_count;
        const (wl_message*) methods;
        int event_count;
        const (wl_message*) events;
    }

    /** \class wl_list
    *
    * \brief doubly-linked list
    *
    * The list head is of "struct wl_list" type, and must be initialized
    * using wl_list_init().  All entries in the list must be of the same
    * type.  The item type must have a "struct wl_list" member. This
    * member will be initialized by wl_list_insert(). There is no need to
    * call wl_list_init() on the individual item. To query if the list is
    * empty in O(1), use wl_list_empty().
    *
    * Let's call the list reference "struct wl_list foo_list", the item type as
    * "item_t", and the item member as "struct wl_list link".
    *
    * The following code will initialize a list:
    * \code
    * struct wl_list foo_list;
    *
    * struct item_t {
    *     int foo;
    *     struct wl_list link;
    * };
    * struct item_t item1, item2, item3;
    *
    * wl_list_init(&foo_list);
    * wl_list_insert(&foo_list, &item1.link);    // Pushes item1 at the head
    * wl_list_insert(&foo_list, &item2.link);    // Pushes item2 at the head
    * wl_list_insert(&item2.link, &item3.link);    // Pushes item3 after item2
    * \endcode
    *
    * The list now looks like [item2, item3, item1]
    *
    * Iterate the list in ascending order:
    * \code
    * item_t *item;
    * wl_list_for_each(item, foo_list, link) {
    *     Do_something_with_item(item);
    * }
    * \endcode
    */
    struct wl_list {
        wl_list *prev;
        wl_list *next;
    }



    struct wl_array {
        size_t size;
        size_t alloc;
        void *data;
    }




    alias wl_fixed_t = int;



    /**
    * \brief A union representing all of the basic data types that can be passed
    * along the wayland wire format.
    *
    * This union represents all of the basic data types that can be passed in the
    * wayland wire format.  It is used by dispatchers and runtime-friendly
    * versions of the event and request marshaling functions.
    */
    union wl_argument {
        int i; /**< signed integer */
        uint u; /**< unsigned integer */
        wl_fixed_t f; /**< fixed point */
        const (char*) s; /**< string */
        wl_object *o; /**< object */
        uint n; /**< new_id */
        wl_array *a; /**< array */
        int h; /**< file descriptor */
    }

    /**
    * \brief A function pointer type for a dispatcher.
    *
    * A dispatcher is a function that handles the emitting of callbacks in client
    * code.  For programs directly using the C library, this is done by using
    * libffi to call function pointers.  When binding to languages other than C,
    * dispatchers provide a way to abstract the function calling process to be
    * friendlier to other function calling systems.
    *
    * A dispatcher takes five arguments:  The first is the dispatcher-specific
    * implementation data associated with the target object.  The second is the
    * object on which the callback is being invoked (either wl_proxy or
    * wl_resource).  The third and fourth arguments are the opcode the wl_messsage
    * structure corresponding to the callback being emitted.  The final argument
    * is an array of arguments received from the other process via the wire
    * protocol.
    */
    alias wl_dispatcher_func_t = int function (const (void*), void*, uint,
            const (wl_message*), wl_argument*);

    alias wl_log_func_t = void function (const (char*), ...);

}

/**
 * Retrieves a pointer to the containing struct of a given member item.
 *
 * This macro allows conversion from a pointer to a item to its containing
 * struct. This is useful if you have a contained item like a wl_list,
 * wl_listener, or wl_signal, provided via a callback or other means and would
 * like to retrieve the struct that contains it.
 *
 * To demonstrate, the following example retrieves a pointer to
 * `example_container` given only its `destroy_listener` member:
 *
 * \code
 * struct example_container {
 *     struct wl_listener destroy_listener;
 *     // other members...
 * };
 *
 * void example_container_destroy(struct wl_listener *listener, void *data)
 * {
 *     struct example_container *ctr;
 *
 *     ctr = wl_container_of(listener, ctr, destroy_listener);
 *     // destroy ctr...
 * }
 * \endcode
 *
 * \param ptr A valid pointer to the contained item.
 *
 * \param sample A pointer to the type of content that the list item
 * stores. Sample does not need be a valid pointer; a null or
 * an uninitialised pointer will suffice.
 *
 * \param member The named location of ptr within the sample type.
 *
 * \return The container for the specified pointer.
 */
template wl_container_of(alias member)
{
    static ParentOf!member* wl_container_of(T)(T* ptr)
    {
        return cast(ParentOf!member*)(cast(ptrdiff_t)(ptr)-member.offsetof);
    }
}

unittest {

    struct S {
        string foo;
        int bar;
    }

    S s;
    assert(wl_container_of!(S.bar)(&s.bar) == &s);
}


template wl_range(alias member)
{
    static WlListRange!member wl_range(wl_list *head)
    {
        return WlListRange!member(head);
    }
}

unittest
{
    struct Item
    {
        int num;
        wl_list link;

        this(int num) { this.num = num; }
    }
    auto i1 = Item(1);
    auto i2 = Item(2);
    auto i3 = Item(3);

    wl_list lst;
    wl_list_init(&lst);
    wl_list_insert(&lst, &i1.link);
    wl_list_insert(&lst, &i2.link);
    wl_list_insert(&i2.link, &i3.link);

    int[] forw_arr;
    foreach(it; wl_range!(Item.link)(&lst)) {
        forw_arr ~= it.num;
    }
    assert(forw_arr == [2, 3, 1]);

    int[] back_arr;
    foreach_reverse(it; wl_range!(Item.link)(&lst)) {
        back_arr ~= it.num;
    }
    assert(back_arr == [1, 3, 2]);
}




template wl_range(T)
{
    static WlArrayRange!T wl_range(wl_array *arr)
    {
        return WlArrayRange!T(arr);
    }
}

unittest
{
    wl_array arr;
    wl_array_init(&arr);

    foreach(i; 0..1342) {
        int *ptr = cast(int*)wl_array_add(&arr, int.sizeof);
        *ptr = i*12 - 15;

    }

    int ind=0;
    foreach(pi; wl_range!(int)(&arr)) {
        assert(*pi == ind++*12-15);
    }
    assert(ind==1342);

    wl_array_release(&arr);
}



double
wl_fixed_to_double (wl_fixed_t f)
{
    union di {
        double d;
        long i;
    }
    di u;

    u.i = ((1023L + 44L) << 52) + (1L << 51) + f;

    return u.d - (3L << 43);
}

wl_fixed_t
wl_fixed_from_double(double d)
{
    union di {
        double d;
        long i;
    }
    di u;

    u.d = d + (3L << (51 - 8));

    return cast(wl_fixed_t)u.i;
}

int wl_fixed_to_int(wl_fixed_t f)
{
    return f / 256;
}
wl_fixed_t wl_fixed_from_int(int i)
{
    return i * 256;
}




private {

    template Id(alias a) { alias Id = a; }


    template ParentOf(alias member)
    {
        alias ParentOf = Id!(__traits(parent, member));
    }

    struct WlListRange(alias member)
    {
        wl_list *head;
        wl_list *fpos;
        wl_list *bpos;

        alias ElType = ParentOf!member;

        this(wl_list *head)
        {
            this.head = head;
            fpos = head.next;
            bpos = head.prev;
        }

        // input

        @property bool empty() const {
            return fpos == head || bpos == head;
        }

        @property ElType *front() {
            return wl_container_of!member(fpos);
        }

        void popFront() {
            fpos = fpos.next;
        }

        // forward

        @property WlListRange!member save() {
            return this;
        }

        // bidirectional

        @property ElType *back() {
            return wl_container_of!member(bpos);
        }

        void popBack() {
            bpos = bpos.prev;
        }
    }


    struct Item
    {
        int num;
        wl_list link;

        this(int num) { this.num = num; }
    }

    static assert(isBidirectionalRange!(WlListRange!(Item.link)));


    struct WlArrayRange(T)
    {
        wl_array *arr;
        size_t fpos;
        size_t bpos;

        this (wl_array *arr)
        {
            assert(arr.size % T.sizeof == 0);
            this.arr = arr;
            fpos = 0;
            bpos = arr.size / T.sizeof;
        }

        // input

        @property bool empty() const {
            return fpos == arr.size / T.sizeof || bpos == 0;
        }

        @property inout(T)* front() inout {
            return cast(inout(T)*)(arr.data + fpos*T.sizeof);
        }

        void popFront() {
            ++fpos;
        }


        // forward

        @property WlArrayRange!T save() {
            return this;
        }


        // bidirectional

        @property inout(T)* back() inout {
            return cast(inout(T)*)(arr.data + bpos*T.sizeof);
        }

        void popBack() {
            --bpos;
        }


        // random access

        @property size_t length() const {
            return arr.size / T.sizeof;
        }

        inout(T)* opIndex(size_t n) inout {
            return cast(inout(T)*)(arr.data + n*T.sizeof);
        }

    }

    static assert(isRandomAccessRange!(WlArrayRange!int));


}


version (Dynamic) {
    extern (C) {
        alias da_wl_list_init           = void  function (wl_list *list);
        alias da_wl_list_insert         = void  function (wl_list *list, wl_list *elm);
        alias da_wl_list_remove         = void  function (wl_list *elm);
        alias da_wl_list_length         = int   function (const (wl_list*) list);
        alias da_wl_list_empty          = int   function (const (wl_list*) list);
        alias da_wl_list_insert_list    = void  function (wl_list *list, wl_list *other);

        alias da_wl_array_init          = void  function (wl_array *array);
        alias da_wl_array_release       = void  function (wl_array *array);
        alias da_wl_array_add           = void *function (wl_array *array, size_t size);
        alias da_wl_array_copy          = int   function (wl_array *array, wl_array *source);
    }
    __gshared {

        da_wl_list_init         wl_list_init;
        da_wl_list_insert       wl_list_insert;
        da_wl_list_remove       wl_list_remove;
        da_wl_list_length       wl_list_length;
        da_wl_list_empty        wl_list_empty;
        da_wl_list_insert_list  wl_list_insert_list;

        da_wl_array_init        wl_array_init;
        da_wl_array_release     wl_array_release;
        da_wl_array_add         wl_array_add;
        da_wl_array_copy        wl_array_copy;
    }

}
else {
    extern (C) {
        void    wl_list_init        (wl_list *list);
        void    wl_list_insert      (wl_list *list, wl_list *elm);
        void    wl_list_remove      (wl_list *elm);
        int     wl_list_length      (const (wl_list*) list);
        int     wl_list_empty       (const (wl_list*) list);
        void    wl_list_insert_list (wl_list *list, wl_list *other);

        void    wl_array_init       (wl_array *array);
        void    wl_array_release    (wl_array *array);
        void *  wl_array_add        (wl_array *array, size_t size);
        int     wl_array_copy       (wl_array *array, wl_array *source);
    }
}



