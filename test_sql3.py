import pytset
import sqlite3
import db_index

def make_dummy_db(conn):
    conn.execute("DROP TABLE IF EXISTS sets;")
    conn.execute("CREATE TABLE sets (name STRING PRIMARY KEY, set_data BLOB);")

conn = sqlite3.connect('delme.db')
make_dummy_db(conn)
s=pytset.PyTSet(129,range(50,110))
s_ser=s.tobytes()
conn.execute(u"INSERT OR IGNORE INTO sets VALUES (?,?)",(u"s",buffer(s_ser)))
conn.commit()
conn.close()


#And now try to get it back
conn = sqlite3.connect('delme.db')
cur=conn.cursor()
cur.execute(u"SELECT set_data FROM sets WHERE name=?",(u"s",))
for row in cur.fetchall():
    print str(row[0])==s_ser, "<< should be True"
conn.close()

db_index.open_db(u"hi_hi")
db_index.close_db()




