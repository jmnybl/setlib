# distutils: language = c++
# distutils: libraries = sqlite3

cdef extern from "sqlite3.h": #...import stuff from this header file
	int sqlite3_open(const char *filename, sqlite3 **ppDb) 
	int sqlite3_close(sqlite3*)
	struct sqlite3: #Defines the type. We never touch it directly, so an empty struct is apparently enough
		pass     

cdef sqlite3 *db #Pointer to the open DB

cpdef open_db(unicode db_name):
	global db
	db_name_u8=db_name.encode("utf-8") #Need to make a variable for this one, because .encode() produces only a temporary object
	sqlite3_open(db_name_u8,&db)

cpdef close_db():
	global db
	sqlite3_close(db)


