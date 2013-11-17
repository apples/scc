#!/bin/bash

export CC="mpiicc"
export CXX="mpiicpc"
export FC="mpiifort"
export MKL_MIC_ENABLE=1

#Tell WRF where its libraries are
export PHDF5="/sw/beacon/hdf5-parallel/1.8.11/micos_intel14"
export NETCDF="/nics/c/home/macslayer/apps/wrf/libs/netcdf_links/"
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

./clean -a
./configure
cp custom_configure/configure_beacon.wrf configure.wrf
./compile -j 8 em_real &> compile.log
