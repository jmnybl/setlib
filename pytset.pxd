from libcpp cimport bool

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        int tree_length
        TSet(int) except +
        void intersection_update(TSet *)
        void minus_update(TSet *)
        void union_update(TSet *)
        void add_item(int)
        bool has_item(int)
        void start_iteration()
        bool next_item(TSet *)
        char * get_data_as_char(int *)
        void fill_ones()
        bool is_empty()

    cdef cppclass TSetArray:
        int tree_length
        int array_len
        TSetArray(int length) except +
        void intersection_update(TSetArray *other)
        void union_update(TSetArray *other)
        void erase()
        void get_set(int index, TSet *result)
        void deserialize(const void *data, int size)
        void print_array()

cdef class PyTSet:
    cdef TSet *thisptr
    cdef acquire_thisptr(self,TSet *thisptr)
    cdef bool dealloc_thisptr

cdef class PyTSetArray:
    cdef TSetArray *thisptr


