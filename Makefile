all: pytset.so

pytset.so: tset.cpp tset.h pytset.pyx
	python setup.py build_ext --inplace

clean:
	rm -f pytset.so

