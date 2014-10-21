TARGETS=pytset.so test2.so db_index.so

all: $(TARGETS)

db_index.so: db_index.pyx
	python setup.py build_ext --inplace

pytset.so: tset.cpp tset.h pytset.pyx query_functions.cpp query_functions.h
	python setup.py build_ext --inplace

test2.so: test2.pyx
	python setup.py build_ext --inplace

clean:
	rm -f $(TARGETS)


