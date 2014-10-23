TARGETS=pytset.so test2.so db_util.so

all: $(TARGETS)

db_util.so: db_util.pyx db_util.pxd
	python setup.py build_ext --inplace

pytset.so: tset.cpp tset.h pytset.pyx query_functions.cpp query_functions.h
	python setup.py build_ext --inplace

test2.so: test2.pyx
	python setup.py build_ext --inplace

clean:
	rm -f $(TARGETS)


