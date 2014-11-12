TARGETS=pytset.so example_queries.so db_util.so

all: $(TARGETS)


db_util.so: db_util.pyx db_util.pxd
	python setup.py build_ext --inplace
	mv setlib/db_util.so .

pytset.so: tset.cpp tset.h pytset.pyx query_functions.cpp query_functions.h
	python setup.py build_ext --inplace
	mv setlib/pytset.so .

example_queries.so: example_queries.pyx
	python setup.py build_ext --inplace
	mv setlib/example_queries.so .
clean:
	rm -rf $(TARGETS)


