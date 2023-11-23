cd cython-cmake
python -m pip install '.[docs]'
cd ../doc
# Assumes make is available. Currently true in GHA, may need to update for RTD.
make html
