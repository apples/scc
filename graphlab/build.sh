#!/bin/sh
set -e

HDF_VER="4.2.9"
HDF5_VER="1.8.11"
NETCDF_VER="4.3.0"

HDF_URL="http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-${HDF_VER}.tar.gz"
HDF5_URL="http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-${HDF5_VER}.tar.gz"
NETCDF_URL="http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-${NETCDF_VER}.tar.gz"

MY_DIR="$(pwd)"
INSTALL_DIR="${MY_DIR}/install"

# Build concurrency flag
POWER_LEVEL="-j12"

if [ ! -d "./graphlab" ]
then
	git clone https://github.com/graphlab-code/graphlab.git
fi
if [ ! -d "./netcdf-${NETCDF_VER}" ]
then
	wcat "${NETCDF_URL}" | tar zx
fi
if [ ! -d "./hdf5-${HDF5_VER}" ]
then
	wcat "${HDF5_URL}" | tar zx
fi
#if [ ! -d "./hdf-${HDF_VER}" ]
#then
#	wcat "${HDF_URL}" | tar zx
#fi

export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include"
export LDFLAGS="${LDFLAGS} -L${INSTALL_DIR}/lib -L${INSTALL_DIR}/lib64"

#cd "${MY_DIR}/hdf-${HDF_VER}/"
#./configure --prefix="${INSTALL_DIR}" --disable-netcdf
#make
#make install

cd "${MY_DIR}/hdf5-${HDF5_VER}/"
./configure --prefix="${INSTALL_DIR}" --disable-shared --enable-static --enable-static-exec # --enable-parallel
make clean ${POWER_LEVEL}
make ${POWER_LEVEL}
make install ${POWER_LEVEL}

cd "${MY_DIR}/netcdf-${NETCDF_VER}/"
./configure --prefix="$INSTALL_DIR" --enable-pnetcdf --disable-shared --enable-static # --enable-hdf4
make clean ${POWER_LEVEL}
make ${POWER_LEVEL}
make install ${POWER_LEVEL}

cd "${MY_DIR}/graphlab/"
./configure --prefix="$INSTALL_DIR"
make clean ${POWER_LEVEL}
cd "./release"
make ${POWER_LEVEL}
make install ${POWER_LEVEL}

