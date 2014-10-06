# distutils: language = c++
# distutils: sources = tset.cpp
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

cpdef main():
    cdef TSet *s
    s = new TSet(50)
    print s.tree_length
    
