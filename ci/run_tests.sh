cd cython-cmake
python -m pip install '.[test]'
cd ..
python -m pytest tests
