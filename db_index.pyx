# distutils: language = c++
# distutils: libraries = sqlite3
from libcpp cimport bool
#http://www.sqlite.org/cintro.html

#...import stuff from this header file
cdef extern from "sqlite3.h":
    int sqlite3_open(const char *filename, sqlite3 **ppDb) 
    int sqlite3_close(sqlite3*)
    int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail)
    int sqlite3_step(sqlite3_stmt*)
    const void * sqlite3_column_blob(sqlite3_stmt*,int)
    struct sqlite3: #Defines the type. We never touch it directly, so an empty struct is apparently enough
        pass     
    struct sqlite3_stmt:
        pass
    int SQLITE_OK
    int SQLITE_DONE
    int SQLITE_ROW

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

cdef sqlite3 *db #Pointer to the open DB
cdef sqlite3_stmt *stmt # Pointer to the statement

cpdef open_db(unicode db_name):
    global db    
    db_name_u8=db_name.encode("utf-8") #Need to make a variable for this one, because .encode() produces only a temporary object
    sqlite3_open(db_name_u8,&db)

cpdef close_db():
    global db
    sqlite3_close(db)

def exec_query(unicode q):
    global db,stmt
    
    query=q.encode("utf-8")
    result=sqlite3_prepare_v2(db,query,len(query),&stmt,NULL)
    if result!=SQLITE_OK:
        return False
    else:
        return True

cdef int fill_next(TSet *out):
    global db,stmt
    cdef int result = sqlite3_step(stmt)
    cdef const void *data
    if result==SQLITE_ROW:
        data=sqlite3_column_blob(stmt,0)
        # TODO
    return 0
