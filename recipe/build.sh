#! /usr/bin/bash
set -e

mkdir -p build
cd build

# CMAKE_CXX_STANDARD is auto-set from Geant4Config.cmake's own
# Geant4_CXX_STANDARD (our geant package: C++20) -- no need to set it here.
# macOS: look in the conda prefix before the SDK, or Geant4Config's
# find_dependency(EXPAT) reads the SDK's expat.h (2.2.5 < 2.9.0).
EXTRA_ARGS=()
if [[ "$(uname)" == "Darwin" ]]; then
  EXTRA_ARGS+=(-DCMAKE_PREFIX_PATH="${PREFIX}" -DCMAKE_FIND_FRAMEWORK=LAST)
fi

cmake .. "${EXTRA_ARGS[@]}" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DG4HepEm_GEANT4_BUILD=ON \
  -DG4HepEm_CUDA_BUILD=OFF \
  -DBUILD_TESTING=OFF

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
