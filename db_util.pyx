# distutils: language = c++
# distutils: libraries = sqlite3
# distutils: sources = tset.cpp
from libcpp cimport bool
#http://www.sqlite.org/cintro.html
from pytset cimport PyTSet, PyTSetArray 

cdef class DB:

    def open_db(self,unicode db_name):
        db_name_u8=db_name.encode("utf-8") #Need to make a variable for this one, because .encode() produces only a temporary object
        sqlite3_open_v2(db_name_u8,&self.db,SQLITE_OPEN_READONLY,NULL)

    def close_db(self):
        sqlite3_close(self.db)

    def exec_query(self,unicode query):
        """Runs sqlite3_prepare, use .next() to iterate through the rows"""
        query_u8=query.encode("utf-8")
        result=sqlite3_prepare_v2(self.db,query_u8,len(query_u8),&self.stmt,NULL)
        if result!=SQLITE_OK:
            print sqlite3_errmsg(self.db)
            return False, result
        else:
            return True

    cpdef int next(self):
        cdef int result = sqlite3_step(self.stmt)
        if result==SQLITE_ROW:
            return 0
        elif result==SQLITE_DONE:
            return 1
        else:
            return result

    cdef void fill_tset(self,TSet *out, int column_index):
        cdef const void *data
        data=sqlite3_column_blob(self.stmt, column_index)
        out.add_serialized_data(data)

    cdef void fill_tsetarray(self, TSetArray *out, int column_index):
        cdef int blob_len
        cdef const void *data
        data=sqlite3_column_blob(self.stmt,column_index)
        blob_len=sqlite3_column_bytes(self.stmt, column_index);
        out.deserialize(data,blob_len)

    def fill_pytset(self, PyTSet s, int column_index):
        self.fill_tset(s.thisptr, column_index)

    def fill_pytsetarray(self, PyTSetArray s, int column_index):
        self.fill_tsetarray(s.thisptr, column_index)

    cdef void fill_sets(self, void **set_pointers, int *types, int size):
        cdef int i
        for i in range(size):
            if types[i]==1: # TODO fix
                self.fill_tset(<TSet *>set_pointers[i],i)
            elif types[i]==2:
                self.fill_tsetarray(<TSetArray *>set_pointers[i],i)
            else:
                print "C",types[i]
                assert False
            
