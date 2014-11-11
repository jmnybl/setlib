# distutils: language = c++
# distutils: sources = tset.cpp
from libcpp cimport bool
import struct

cdef class PyTSet:
    #cdef TSet *thisptr ## defined in pytset.pxd

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

    def __dealloc__(self):
        del self.thisptr
        

    def tobytes(self):
        cdef int size
        cdef char *b = self.thisptr.get_data_as_char(&size)
        cdef bytes result=b[:size]
        tree_len=struct.pack("@H",self.thisptr.tree_length)

        return tree_len+result

cdef class PyTSetArray:
    #cdef TSetArray *thisptr #defined in pytset.pxd

    def __cinit__(self, int length):
        self.thisptr = new TSetArray(length)

    def deserialize(self,bytes ser_data): #note the bytes type
        cdef char *ser_data_c=ser_data
        self.thisptr.deserialize(ser_data_c,len(ser_data))        
    
    def __iter__(self):
        cdef PyTSet s=PyTSet(self.thisptr.tree_length)
        cdef int i
        for i in range(self.thisptr.tree_length):
            self.thisptr.get_set(i,s.thisptr)
            for x in s:
                yield (i,x)

    def to_string(self):
        return " ".join(str(x) for x in self)

    def __dealloc__(self):
        del self.thisptr

