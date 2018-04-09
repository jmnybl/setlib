from distutils.core import setup
from Cython.Build import cythonize

setup(
    setup_requires=[
        'cython>=0.x',
    ],
    ext_modules=cythonize(
        ["pytset.pyx", "tset.cpp"],
        language="c++",
    ),
)
