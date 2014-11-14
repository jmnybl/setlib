# distutils: language = c++
# distutils: sources = tset.cpp query_functions.cpp

from libcpp cimport bool
from db_util cimport DB
from pytset cimport PyTSet
from libc.stdlib cimport malloc

cdef extern from "tset.h" namespace "tset":
    cdef cppclass TSet:
        int tree_length
        int array_len
        TSet(int) except +
        void intersection_update(TSet *)
        void minus_update(TSet *)
        void union_update(TSet *)
        void add_item(int)
        bool has_item(int)
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

cdef extern from "query_functions.h":
    void pairing(TSet *index_set, TSet *other_set, TSetArray *mapping, bool negated)

cdef class Search:  # base class for all searches
    cdef void **sets  #Pointers to stuff coming from the DB: array 1 and set 2 (we don't need 0)
    cdef int *set_types

    cdef TSet* exec_search(self):
        pass

    cdef initialize(self):
        pass

cdef class  SimpleSearch(Search):
    """
    _ <aux V
    0   1  2 <--- set number for variable names below
    """

    cdef TSet *set0 #declare the sets needed in the query
    cdef TSetArray *seta1
    cdef TSet *set2
    cdef public object query_fields

    def __cinit__(self):
        #This runs only once per search, creates the data structures, etc.
        self.sets=<void**>malloc(2*sizeof(void*))
        self.set_types=<int*>malloc(2*sizeof(int))
        self.set_types[0],self.set_types[1]=2,1 #Types of stuff we grab from the DB, so we'll be grabbing 1 and 2, i.e. array and set
        self.set0,self.seta1,self.set2=new TSet(312), new TSetArray(312), new TSet(312) ## all sets needed in the query must be created 
        self.sets[0]=self.seta1 #...feed the pointers into the sets[] array so the DB can fill them with data for us
        self.sets[1]=self.set2 #...
        self.query_fields=[u"!dep_a_aux",u"!tag_s_POS_V"] #we want the sentence to have an aux and a V (these must come in the order in which sets[] and set_types[] come)

    cdef initialize(self):
        """
        Called before every sentence to be processed. Must initialize sets which are not fetched from the DB. Be efficient here, whatever you do!
        """
        self.set0.tree_length=self.set2.tree_length
        self.set0.array_len=self.set2.array_len
        self.set0.fill_ones()
        #set1 and set2 we get from the DB, so no need to mess with them

    cdef TSet* exec_search(self):
        """
        This runs the actual query. I.e. initialize() has been called for us and all sets are filled with valid data.
        """
        pairing(self.set0,self.set2,self.seta1,False) #Filter set0 by set2 through the seta1 mapping
        return self.set0 #...and that's where we have the result

def iterate_results(Search search, DB database):
    cdef int size=len(search.query_fields)
    cdef TSet* r
    cdef PyTSet s
    s=PyTSet(320)
    counter=0
    while database.next() == 0:
        counter+=1
        database.fill_sets(search.sets,search.set_types,size)
        search.initialize()
        r=search.exec_search()
        s.thisptr=r
        if not s.is_empty():
            print "HIT"



# cpdef main():
#     cdef Search s
#     s = Search()
#     db=DB()
#     db.open_db(u"delme.db")
#     q=u"select tagsets.set_data, setarrays.setarray_data from tagsets join setarrays on tagsets.sent_id=setarrays.sent_id where tagsets.tag_name='V' and setarrays.dep_name='aux_dependents'"
#     print "A", db.exec_query(q)
#     print "B",db.next()
#     s.initialize()
#     print "ok"
#     db.fill_sets(s.sets,s.set_types,2)
#     print "ok2"
#     cdef TSet *result
#     result=s.exec_search()
#     r = PyTSet(3)
#     print "result:",result.is_empty()
#     r.thisptr=result
#     for item in r:
#         print "token:",item
    
    
