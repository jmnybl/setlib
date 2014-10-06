# distutils: language = c++
# distutils: sources = tset.cpp
from libcpp cimport bool

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        int tree_length
        TSet(int) except +
        void intersection_update(TSet *)
        void add_item(int)
        bool has_item(int)

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
    def add_item(self, int item):
        self.thisptr.add_item(item)
    def __contains__(self, int item):
        return self.thisptr.has_item(item)
    def __iter__(self):
        cdef int i
        for i in range(self.thisptr.tree_length):
            if self.thisptr.has_item(i):
                yield i
