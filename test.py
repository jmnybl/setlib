import pytset

from test2 import main 

s=pytset.PyTSet(100,range(50,70))
o=pytset.PyTSet(100,range(60,80))


print "s:",list(s)
for item in s:
    print item
##print "o:",list(o)

##s&=o
##print "intersection",list(s)

##s=pytset.PyTSet(100,range(50,70))
##s-=o
##print "s minus o:",list(s)

##s=pytset.PyTSet(100,range(50,70))
##s|=o
##print "union:",list(s)


##main() 

