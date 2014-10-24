# distutils: language = c++
# distutils: sources = tset.cpp query_functions.cpp
from libcpp cimport bool
from db_util cimport DB

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        int tree_length
        TSet(int) except +
        void intersection_update(TSet *)
        void minus_update(TSet *)
        void union_update(TSet *)
        void add_item(int)
        bool has_item(int)
        void fill_ones()

    cdef cppclass TSetArray:
        int tree_length
        int array_len
        TSetArray(int length) except +
        void intersection_update(TSetArray *other)
        void union_update(TSetArray *other)
        void erase()
        void get_set(int index, TSet *result)
        void deserialize(const void *data, int size)

cdef extern from "query_functions.h":
    void pairing(TSet *index_set, TSet *other_set, TSetArray *mapping)

cdef class Search:

    cdef void *sets[2]
    cdef int set_types[2]
    cdef TSet *set1

    def __cinit__(self):
        self.set_types[0],self.set_types[1]=1,2
        self.sets[0],self.sets[1]=new TSet(3),new TSetArray(3)
        self.set1=new TSet(3)

    cdef initialize(self):
        self.set1.fill_ones()

    cdef TSet* exec_search(self):
        pairing(<TSet *>self.sets[0],self.set1,<TSetArray *>self.sets[1])
        return <TSet *>self.sets[0]

cpdef main():
    cdef Search s
    s = Search()
    db=DB()
    db.open_db(u"delme.db")
    q=u"select tagsets.set_data, setarrays.setarray_data from tagsets join setarrays on tagsets.sent_id=setarrays.sent_id where tagsets.tag_name='V' and setarrays.dep_name='aux_governors'"
    print "A", db.exec_query(q)
    print "B",db.next()
    s.initialize()
    db.fill_sets(s.sets,s.set_types,2)
    
    
