#!/bin/sh

if [[ "$target_platform" == "osx-64" ]]; then
  TOOLS_DIR=$(dirname $($FC --print-libgcc-file-name))
  if [[ ! -f "$TOOLS_DIR/ld" ]]; then
    ln -sf $LD $TOOLS_DIR/ld
    ln -sf $LD $BUILD_PREFIX/bin/ld
  fi
fi

# Workaround for https://github.com/conda-forge/scalapack-feedstock/pull/30#issuecomment-1061196317
export FFLAGS="${FFLAGS} -fallow-argument-mismatch"

# As mpi libraries are not correctly linked in CMake scripts, use mpi wrappers for the compilers
export CC=mpicc
export CXX=mpic++
export FC=mpifort

mkdir build && cd build
cmake ${CMAKE_ARGS} \
    $EXTRA_CMAKE \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_BUILD_TYPE=Release \
    .. || (cat CMakeFiles/CMakeOutput.log && cat CMakeFiles/CMakeError.log && exit 1)

make install -j${CPU_COUNT}
