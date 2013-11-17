#!/bin/bash

#Define directories here
IMPI_DIR=/opt/intel/impi
ICS_DIR=/opt/intel/ics
NETCDF_DIR=/data/scc/wrf/lib/netcdf
HDF5_DIR=/data/scc/wrf/lib/hdf5

export MIC_LD_LIBRARY_PATH=/opt/intel/ics/mkl/lib/mic

export CC="mpiicc"
export CXX="mpiicpc"
export FC="mpiifort"
export MKL_MIC_ENABLE=1
export OFFLOAD_REPORT=2
export OFFLOAD_DEVICES=0

export PATH="$PATH:$ICS_DIR/bin/:$IMPI_DIR/4.1.0/bin64/"

source $IMPI_DIR/4.1.0/bin/mpivars.sh
source $ICS_DIR/bin/compilervars.sh intel64
source $ICS_DIR/bin/ifortvars.sh intel64
source $ICS_DIR/composer_xe_2013.1.117/mkl/bin/mklvars.sh intel64

export NETCDF="$NETCDF_DIR"
export PHDF5="$HDF5_DIR"

./clean -a
./configure
cp ./custom_configure/configure.wrf .
./compile em_real &> compile.log
