#! /usr/bin/bash
set -e

mkdir -p build
cd build

# CMAKE_CXX_STANDARD is auto-set from Geant4Config.cmake's own
# Geant4_CXX_STANDARD (our geant package: C++20) -- no need to set it here.
cmake .. \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DG4HepEm_GEANT4_BUILD=ON \
  -DG4HepEm_CUDA_BUILD=OFF \
  -DBUILD_TESTING=OFF

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
