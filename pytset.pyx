# distutils: language = c++
# distutils: sources = tset.cpp

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        TSet(int) except +

cdef class PyTSet:
    cdef TSet *thisptr
    def __cinit__(self, int length):
        self.thisptr = new TSet(length)
