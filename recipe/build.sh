#!/bin/sh

if [[ $(uname) == "Darwin" && $mpi == "mpich" ]]; then
  # workaround cmake bug https://gitlab.kitware.com/cmake/cmake/merge_requests/1952
  # remove when we require cmake >= 3.12
  EXTRA_CMAKE="-DMPI_C_LIB_NAMES=mpi;pmpi -DMPI_CXX_LIB_NAMES=mpi;pmpi;mpicxx"
fi

mkdir build && cd build
cmake \
    $EXTRA_CMAKE \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    ..

make install -j${CPU_COUNT}
