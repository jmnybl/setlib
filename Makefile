all: pytset.so test2.so

pytset.so: tset.cpp tset.h pytset.pyx
	python setup.py build_ext --inplace

test2.so: test2.pyx
	python setup.py build_ext --inplace

clean:
	rm -f pytset.so test2.so

