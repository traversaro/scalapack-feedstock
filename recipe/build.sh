#!/bin/sh

export CC=mpicc
export CXX=mpicxx
export FC=mpifort

mkdir build && cd build
cmake \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    ..

make install -j${CPU_COUNT}
