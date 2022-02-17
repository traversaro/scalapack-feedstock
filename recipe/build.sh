#!/bin/sh

if [[ "$target_platform" == "osx-64" ]]; then
  TOOLS_DIR=$(dirname $($FC --print-libgcc-file-name))
  if [[ ! -f "$TOOLS_DIR/ld" ]]; then
    ln -sf $LD $TOOLS_DIR/ld
    ln -sf $LD $BUILD_PREFIX/bin/ld
  fi
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  EXTRA_CMAKE="-DCDEFS=Add_ -DMPI_C_LIB_NAMES=$PREFIX/lib/libmpi$SHLIB_EXT -DMPI_C_WORKS=TRUE -DMPI_Fortran_LIB_NAMES=$PREFIX/lib/libmpifort$SHLIB_EXT -DMPI_Fortran_WORKS=TRUE -DMPI_DETERMINE_LIBRARY_VERSION=FALSE -DMPI_C_VERSION=3.1 -DMPI_Fortran_VERSION=3.1"
  # https://github.com/Reference-ScaLAPACK/scalapack/issues/21
  export FFLAGS="${FFLAGS} -fallow-argument-mismatch"
fi

mkdir build && cd build
cmake ${CMAKE_ARGS} \
    $EXTRA_CMAKE \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DMPI_BASE_DIR="$PREFIX" \
    -DCMAKE_BUILD_TYPE=Release \
    .. || (cat CMakeFiles/CMakeOutput.log && cat CMakeFiles/CMakeError.log && exit 1)

make install -j${CPU_COUNT}
