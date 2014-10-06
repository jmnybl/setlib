from distutils.core import setup
from Cython.Build import cythonize

setup(ext_modules = cythonize(
           "pytset.pyx",                 # our Cython source
           sources=["tset.cpp"],  # additional source file(s)
           language="c++",             # generate C++ code
      ))

setup(ext_modules = cythonize(
           "test2.pyx",                 # our Cython source
           sources=["tset.cpp"],  # additional source file(s)
           language="c++",             # generate C++ code
      ))
