import pytset

s=pytset.PyTSet(50)
o=pytset.PyTSet(50,range(10))

print 1 in o
for i in o:
    print i
s.intersection_update(o)
