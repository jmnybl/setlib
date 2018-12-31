TARGETS=pytset.so

all: $(TARGETS)


pytset.so: tset.cpp tset.h pytset.pyx pytset.pxd setup.py
	python3 setup.py build_ext --inplace
	mv setlib/pytset*.so ./pytset.so

clean:
	rm -rf $(TARGETS) setlib build



