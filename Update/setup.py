from setuptools import setup, find_packages
from Cython.Build import cythonize

setup(
    name="MultiscalerPC",
    ext_modules=cythonize("apply_df_funcs.pyx")
)
