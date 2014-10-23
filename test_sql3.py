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
    conn.execute("DROP TABLE IF EXISTS tagsets;")
    conn.execute("CREATE TABLE tagsets (sent_id integer, tag_name STRING, set_data BLOB);")
    conn.execute("DROP TABLE IF EXISTS setarrays;")
    conn.execute("CREATE TABLE setarrays (sent_id integer, dep_name STRING, setarray_data BLOB);")
    
    s_n=pytset.PyTSet(3,[0])
    s_v=pytset.PyTSet(3,[1,2])
    sa_nsubj_dependents=[set(),set(),set((0,))]
    sa_nsubj_governors=[set((2,)),set(),set()]
    sa_aux_dependents=[set(),set(),set((1,))]
    sa_aux_governors=[set(),set((2,)),set()]
    
    conn.execute(u"INSERT INTO tagsets VALUES (?,?,?)",(0,u"N",buffer(s_n.tobytes())))
    conn.execute(u"INSERT INTO tagsets VALUES (?,?,?)",(0,u"V",buffer(s_v.tobytes())))
    conn.execute(u"INSERT INTO setarrays VALUES (?,?,?)",(0,u"nsubj_dependents",buffer(serialize_as_tset_array(3,sa_nsubj_dependents))))
    conn.execute(u"INSERT INTO setarrays VALUES (?,?,?)",(0,u"aux_dependents",buffer(serialize_as_tset_array(3,sa_aux_dependents))))
    conn.execute(u"INSERT INTO setarrays VALUES (?,?,?)",(0,u"nsubj_governors",buffer(serialize_as_tset_array(3,sa_nsubj_governors))))
    conn.execute(u"INSERT INTO setarrays VALUES (?,?,?)",(0,u"aux_governors",buffer(serialize_as_tset_array(3,sa_aux_governors))))
    conn.commit()
    conn.close()
conn = sqlite3.connect('delme.db')
make_dummy_db(conn)



# s=pytset.PyTSet(129,range(50,110))
# s_ser=s.tobytes()
# conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s1",buffer(s_ser)))
# s=pytset.PyTSet(129,range(51,110))
# s_ser=s.tobytes()
# conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s2",buffer(s_ser)))
# s=pytset.PyTSet(129,range(52,110))
# s_ser=s.tobytes()
# conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s3",buffer(s_ser)))
# conn.commit()

# sets=[set() for _ in range(20)]
# sets[0].add(5)
# sets[0].add(15)
# sets[1].add(17)
# serialized_str=serialize_as_tset_array(20,sets)
# tsetarray=pytset.PyTSetArray(20)
# tsetarray.deserialize(serialized_str)
# print tsetarray.to_string()
# conn.execute(u"INSERT OR IGNORE INTO setarrays VALUES (?,?)",(u"sa1",buffer(serialized_str)))
# conn.commit()
# conn.close()

# DB=db_util.DB()
# DB.open_db(u"delme.db")
# q=u"select set_data from sets"
# DB.exec_query(q)
# s=pytset.PyTSet(129,range(50,110))
# while DB.next()==0:
#     DB.fill_pytset(s,0)
#     for item in s:
#         print item,
#     print
# DB.close_db()

# DB.open_db(u"delme.db")
# q=u"select setarray_data from setarrays"
# DB.exec_query(q)
# sa=pytset.PyTSetArray(100)
# print "Empty set array:", sa.to_string()
# while DB.next()==0:
#     DB.fill_pytsetarray(sa,0)
#     print "Set array from DB:", sa.to_string()
# DB.close_db()

