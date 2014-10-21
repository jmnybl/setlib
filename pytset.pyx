# distutils: language = c++
# distutils: sources = tset.cpp
from libcpp cimport bool
import struct

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

cdef class PyTSet:
    cdef TSet *thisptr
    def __cinit__(self, int length, it=None):
        self.thisptr = new TSet(length)
    def __init__(self, int length, it=None):
        cdef int i
        if it:
            for i in it:
                self.add_item(i)
    def intersection_update(self, PyTSet other):
        self.thisptr.intersection_update(other.thisptr)
    def minus_update(self, PyTSet other):
        self.thisptr.minus_update(other.thisptr)
    def union_update(self, PyTSet other):
        self.thisptr.union_update(other.thisptr)
    def add_item(self, int item):
        self.thisptr.add_item(item)
    def __contains__(self, int item):
        return self.thisptr.has_item(item)
##    def __iter__(self):
##        cdef int i
##        for i in range(self.thisptr.tree_length):
##            if self.thisptr.has_item(i):
##                yield i

    def __iter__(self):
        cdef int i
        cdef TSet *result = new TSet(self.thisptr.tree_length)
        self.thisptr.start_iteration()
        while self.thisptr.next_item(result):
            for i in range(result.tree_length):
                if result.has_item(i):
                    yield i
                    break

    def __iand__(self, PyTSet other):
        self.intersection_update(other)
        return self
    def __isub__(self, PyTSet other):
        self.minus_update(other)
        return self
    def __ior__(self, PyTSet other):
        self.union_update(other)
        return self

    def __del__(self):
        print "del"

    def tobytes(self):
        cdef int size
        cdef char *b = self.thisptr.get_data_as_char(&size)
        cdef bytes result=b[:size]
        tree_len=struct.pack("@H",self.thisptr.tree_length)

        return tree_len+result
    
