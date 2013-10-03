#!/bin/sh
set -e

function say {
	echo '[SCC]' $@
}

alias wcat='wget -q -O -'

HDF_VER="4.2.9"
HDF5_VER="1.8.11"
NETCDF_VER="4.3.0"

HDF_URL="http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-${HDF_VER}.tar.gz"
HDF5_URL="http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-${HDF5_VER}.tar.gz"
NETCDF_URL="http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-${NETCDF_VER}.tar.gz"

MY_DIR="$(pwd)"
INSTALL_DIR="${MY_DIR}/install"

# Build concurrency flag
POWER_LEVEL="-j4"

export CPPFLAGS="${CPPFLAGS} -I${INSTALL_DIR}/include"
export LDFLAGS="${LDFLAGS} -L${INSTALL_DIR}/lib -L${INSTALL_DIR}/lib64"

if [ ! -e "${MY_DIR}/BUILT_HDF5" ]
then
	cd "${MY_DIR}"
	if [ ! -d "./hdf5-${HDF5_VER}" ]
	then
		wcat "${HDF5_URL}" | tar zx
	fi
	say "Building HDF5..."
	cd "${MY_DIR}/hdf5-${HDF5_VER}/"
	./configure --prefix="${INSTALL_DIR}" --disable-shared --enable-static --enable-static-exec #--enable-parallel
	make ${POWER_LEVEL}
	make install ${POWER_LEVEL}
	touch "${MY_DIR}/BUILT_HDF5"
fi

if [ ! -e "${MY_DIR}/BUILT_NETCDF" ]
then
	cd "${MY_DIR}"
	if [ ! -d "./netcdf-${NETCDF_VER}" ]
	then
		wcat "${NETCDF_URL}" | tar zx
	fi
	say "Building NETCDF..."
	cd "${MY_DIR}/netcdf-${NETCDF_VER}/"
	./configure --prefix="$INSTALL_DIR" --disable-shared --enable-static # --enable-hdf4
	make ${POWER_LEVEL}
	make install ${POWER_LEVEL}
	touch "${MY_DIR}/BUILT_NETCDF"
fi

if [ ! -e "${MY_DIR}/BUILT_GRAPHLAB" ]
then
	cd "${MY_DIR}"
	if [ ! -d "./graphlab" ]
	then
		git clone https://github.com/graphlab-code/graphlab.git
	fi
	cp -a "${MY_DIR}/apps/" "${MY_DIR}/graphlab/"
	say "Building Graphlab..."
	cd "${MY_DIR}/graphlab/"
	./configure --prefix="$INSTALL_DIR"
	cd "./release"
	make ${POWER_LEVEL}
	#make install ${POWER_LEVEL}
	#touch "${MY_DIR}/BUILT_GRAPHLAB"
fi

