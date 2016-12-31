"""
To install phcpy correctly, the shared object file must be copied
to the same location where the modules of phcpy are installed.
This is accomplished via the data_files entry in the setup below.
For the installation of the GPU accelerated path trackers in double,
double double and quad double precision, instead of phcpy2c2.so,
the shared objects that are needed are phcpy2cpath_d.so (double),
phcpy2cpath_dd.so (double double), and phcpy2cpath_qd.so (quad double).
"""

from distutils.core import setup
from distutils.sysconfig import get_python_lib

setup(
    name = 'PHCpy' ,
    author = 'Jan Verschelde' ,
    author_email = 'janv@uic.edu' ,
    description = 'a package for Polynomial Homotopy Continuation' ,
    url = 'https://github.com/janverschelde/PHCpack' ,
    version = '0.6.1' ,
    packages = ['phcpy'] ,
    py_modules = ['phcpy/interface', 'phcpy/solver', 'phcpy/solutions', \
        'phcpy/trackers', 'phcpy/sweepers', 'phcpy/tuning', 'phcpy/tropisms', \
        'phcpy/sets', 'phcpy/maps', 'phcpy/schubert' , 'phcpy/polytopes', \
        'phcpy/server', 'phcpy/examples', 'phcpy/families', \
        'phcpy/dashboard', 'phcpy/series' ] ,
    license = 'GNU GENERAL PUBLIC LICENSE version 3' ,
    data_files = [(get_python_lib()+'/phcpy', ['phcpy/phcpy2c2.so'])] ,
    platforms = ['linux2'] ,
    long_description=open('README.txt').read()
)
