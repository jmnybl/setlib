# distutils: language = c++
# distutils: libraries = sqlite3

#http://www.sqlite.org/cintro.html

#...import stuff from this header file
cdef extern from "sqlite3.h":
	int sqlite3_open(const char *filename, sqlite3 **ppDb) 
	int sqlite3_close(sqlite3*)
	int sqlite3_prepare_v2(sqlite3 *db, const char *zSql, int nByte, sqlite3_stmt **ppStmt, const char **pzTail);
	int sqlite3_step(sqlite3_stmt*);
	struct sqlite3: #Defines the type. We never touch it directly, so an empty struct is apparently enough
		pass     
	struct sqlite3_stmt:
		pass

cdef sqlite3 *db #Pointer to the open DB

cpdef open_db(unicode db_name):
	global db	
	db_name_u8=db_name.encode("utf-8") #Need to make a variable for this one, because .encode() produces only a temporary object
	sqlite3_open(db_name_u8,&db)

cpdef close_db():
	global db
	sqlite3_close(db)

cdef exec_query(unicode q):
	global db
	pass
