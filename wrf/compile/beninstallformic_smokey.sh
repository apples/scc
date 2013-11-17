#!/bin/bash

#Define file paths here
IMPI_DIR="/opt/intel/impi"
ICS_DIR="/opt/intel/ics"
HDF5_DIR="/data/mic/wrf/lib/hdf5"
NETCDF_DIR="/data/mic/wrf/lib/netcdf"
MKL_DIR="/opt/intel/ics/composer_xe_2013.1.117/mkl"

#Add the Intel MPI compilers to the PATH
export CC="mpiicc"
export CXX="mpiicpc"
export FC="mpiifort"
export PATH="$PATH:$ICS_DIR/bin:$IMPI_DIR/4.1.0/bin64"
export MKL_MIC_ENABLE=1

#Use the Intel scripts to set environment variables.
source $IMPI_DIR/4.1.0/bin/mpivars.sh
source $ICS_DIR/bin/compilervars.sh intel64
source $ICS_DIR/bin/ifortvars.sh intel64
source $ICS_DIR/composer_xe_2013.1.117/mkl/bin/mklvars.sh mic

#Tell WRF where its libraries are
export PHDF5="$HDF5_DIR"
export NETCDF="$NETCDF_DIR"
export LD_LIBRARY_PATH="/opt/intel/ics/composer_xe_2013.1.117/mkl/lib/mic:/opt/intel/ics/composer_xe_2013.1.117/mkl/lib/intel64"

./clean -a
./configure
cp ./custom_configure/configure.wrf .
./compile em_real &> compile.log
