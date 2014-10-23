import pytset
import sqlite3
import db_util
import struct

def serialize_as_tset_array(tree_len,sets):
    """
    tree_len -> length of the tree to be serialized
    sets: array of tree_len sets, each set holding the indices of the elements
    """
    indices=[]
    for set_idx,s in enumerate(sets):
        for item in s:
            indices.append(struct.pack("@HH",set_idx,item))
    res=struct.pack("@H",tree_len)+("".join(indices))
    return res

def make_dummy_db(conn):
    conn.execute("DROP TABLE IF EXISTS sets;")
    conn.execute("CREATE TABLE sets (name STRING PRIMARY KEY, set_data BLOB);")
    conn.execute("DROP TABLE IF EXISTS setarrays;")
    conn.execute("CREATE TABLE setarrays (name STRING PRIMARY KEY, setarray_data BLOB);")


conn = sqlite3.connect('delme.db')
make_dummy_db(conn)
s=pytset.PyTSet(129,range(50,110))
s_ser=s.tobytes()
conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s1",buffer(s_ser)))
s=pytset.PyTSet(129,range(51,110))
s_ser=s.tobytes()
conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s2",buffer(s_ser)))
s=pytset.PyTSet(129,range(52,110))
s_ser=s.tobytes()
conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s3",buffer(s_ser)))
conn.commit()

sets=[set() for _ in range(20)]
sets[0].add(5)
sets[0].add(15)
sets[1].add(17)
serialized_str=serialize_as_tset_array(20,sets)
tsetarray=pytset.PyTSetArray(20)
tsetarray.deserialize(serialized_str)
print tsetarray.to_string()
conn.execute(u"INSERT OR IGNORE INTO setarrays VALUES (?,?)",(u"sa1",buffer(serialized_str)))
conn.commit()
conn.close()

DB=db_util.DB()
DB.open_db(u"delme.db")
q=u"select set_data from sets"
DB.exec_query(q)
s=pytset.PyTSet(129,range(50,110))
while DB.fill_next_pytset(s)!=1:
    for item in s:
        print item,
    print
DB.close_db()


DB.open_db(u"delme.db")
q=u"select setarray_data from setarrays"
DB.exec_query(q)
sa=pytset.PyTSetArray(100)
print "Empty set array:", sa.to_string()
while DB.fill_next_pytsetarray(sa)!=1:
    print "Set array from DB:", sa.to_string()
DB.close_db()


