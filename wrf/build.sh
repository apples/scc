#!/bin/bash

function say {
	echo "[CBM]" $@
}

###########
# PREPARE #
###########

# Check for proper modules

FAIL=0
WRF_ENV=0
WPS_ENV=0

if [ "$PE_ENV" = "INTEL" ]; then
	say "INTEL programming environment detected."
	WRF_ENV=3
	WPS_ENV=3
fi

if [ "$PE_ENV" = "GNU" ]; then
	say "GNU programming environment detected."
	WRF_ENV=7
	WPS_ENV=7
fi

if [ "$WRF_ENV" = 0 ]; then
	say "No programming environment detected!"
	FAIL=1
fi

WRF_NESTING=1
WRF_APPLY_PATCHES=0

if [[ -z "$NETCDF_DIR" ]]; then
    say "'netcdf' module not loaded!"
    FAIL=1
fi;

if [[ -z "$MPICH_DIR" ]]; then
    say "'xt-mpich2' module not loaded!"
    FAIL=1
fi;

if [[ $FAIL = 1 ]]; then
    say "Preparation failed!"
    say "Go back to bed."
    exit 1
fi

MY_DIR=`pwd`
WRF_DIR=$MY_DIR/WRFV3
WPS_DIR=$MY_DIR/WPS

WRF_ARW_DOWNLOAD_URL=http://www.mmm.ucar.edu/wrf/src/WRFV3.5.TAR.gz
WRF_WPS_DOWNLOAD_URL=http://www.mmm.ucar.edu/wrf/src/WPSV3.5.TAR.gz

JASPER_DOWNLOAD_URL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
JASPER_ZIP=$MY_DIR/jasper.zip
JASPER_DIR=$MY_DIR/jasper-1.900.1

DEPS_DIR=$MY_DIR/deps

CFLAGS_EXTRA=""

MAKEFLAGS=""

export CC=cc
export CXX=CC
export FC=ftn

export LD_LIBRARY_PATH=$DEPS_DIR/lib

export CFLAGS="$CFLAGS $CFLAGS_EXTRA"
export CXXFLAGS="$CXXFLAGS $CFLAGS_EXTRA"

export NETCDF="$NETCDF_DIR"

export JASPERLIB="$DEPS_DIR/lib"
export JASPERINC="$DEPS_DIR/include"

export VERBOSE=1

######################
# DOWNLOAD & EXTRACT #
######################
say "Downloading..."

if [ -d "$WRF_DIR" ]; then
    say "Skipping WRF download (folder exists)."
else
    say "Downloading and extracting WRF..."
    wget -q -O - $WRF_ARW_DOWNLOAD_URL | tar -zx
    patch -p0 < grib2.patch
fi

if [ -d "$WPS_DIR" ]; then
    say "Skipping WPS download (folder exists)."
else
    say "Downloading and extracting WPS..."
    wget -q -O - $WRF_WPS_DOWNLOAD_URL | tar -zx
fi

################
# Dependencies #
################
say "Checking dependencies..."

if [ -e "$DEPS_DIR/lib/libjasper.a" ]; then
	say "Jasper already installed."
else
	if [ -d "$JASPER_DIR" ]; then
		say "Jasper sources found."
	else
		say "Downloading and extracting Jasper..."
		wget -q -O $JASPER_ZIP $JASPER_DOWNLOAD_URL
		unzip $JASPER_ZIP
	fi

	say "Building Jasper..."
	cd $JASPER_DIR
	./configure --prefix=$DEPS_DIR
	make
	make install
fi

############
# Defaults #
############
say "Copying defaults..."

cd $MY_DIR
cp ./WRF.configure $WRF_DIR/arch/configure_new.defaults
cp ./WPS.configure $WPS_DIR/arch/configure.defaults

#######
# WRF #
#######
cd $WRF_DIR

say "Configuring WRF..."
#./clean -a
#(echo $WRF_ENV && echo $WRF_NESTING) \
#    | ./configure

say "Building WRF..."
#./compile wrf
#./compile em_real

#######
# WPS #
#######
cd $WPS_DIR

say "Configuring WPS..."
./clean -a
(echo $WPS_ENV) \
    | ./configure

say "Building WPS..."
./compile

say "DONE."
