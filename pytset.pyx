# distutils: language = c++
# distutils: sources = tset.cpp

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        TSet(int) except +
        void intersection_update(TSet *)
        void add_item(int)

cdef class PyTSet:
    cdef TSet *thisptr
    def __cinit__(self, int length):
        self.thisptr = new TSet(length)
    def intersection_update(self, PyTSet other):
        self.thisptr.intersection_update(other.thisptr)
    def add_item(self, item):
        self.thisptr.add_item(item)
