#!/bin/bash

function say {
	echo "[CBM]" ${@}
}

###########
# PREPARE #
###########

# Check for proper modules

FAIL=0

if [[ -z "`which cmake`" ]]; then
    say "'cmake' module not loaded!"
    FAIL=1
fi;

if [[ -z "`which python`" ]]; then
    say "'python' module not loaded!"
    FAIL=1
fi;

if [[ ${FAIL} = 1 ]]; then
    say "Preparation failed!"
    say "Go back to bed."
    exit 1
fi

#Configuration variables

MY_DIR=`pwd`
NEMO5_DIR="${MY_DIR}/NEMO5"
LOG_DIR="${MY_DIR}/logs"
BUILD_DIR="${MY_DIR}/build.d"

POSTPONE_LIBS="slepc"
SKIP_LIBS="boost statgrab UFconfig wxWidgets"

CFLAGS_EXTRA=""

MAKEFLAGS=""

#Exported variables

source setbuildenv.sh

export VERBOSE=1

export NEMO5_LIB_DIR="${NEMO5_DIR}/libs"

#Internal

FAILED_BUILDS=()

######################
# DOWNLOAD & EXTRACT #
######################
#~ say "Downloading..."

#~ if [ -d "${WRF_DIR}" ]; then
    #~ say "Skipping WRF download (folder exists)."
#~ else
    #~ say "Downloading and extracting WRF..."
    #~ wget -q -O - ${WRF_ARW_DOWNLOAD_URL} | tar -zx
    #~ patch -p0 < grib2.patch
#~ fi

#########
# Patch #
#########

if [ ! -e "${NEMO5_DIR}/PATCHED" ]
then
	say "Patching..."
	patch -sp1 -d "${NEMO5_DIR}" < yggy.patch
fi

#############
# Configure #
#############

cd ${NEMO5_DIR}
say "Configuring..."
if [ -z "`./configure.sh yggy 2>&1 | grep 'NOT YET'`" ]
then
	say "Configuration complete."
else
	say "Configuration FAILED."
	exit 1
fi

##############
# Build libs #
##############

function build_lib() {
	cd "${NEMO5_LIB_DIR}/${CUR_DIR}"
	if [ -e "${BUILD_DIR}/${CUR_DIR}.sh" ]
	then
		"${BUILD_DIR}/${CUR_DIR}.sh"
	else
		MAKEFILE_NAME='Makefile.yggy'
		if [ -e "${MAKEFILE_NAME}" ]
		then
			say "Using special makefile \"${MAKEFILE_NAME}\"."
			make -f "${MAKEFILE_NAME}" 2>&1 >"${LOG_DIR}/${CUR_DIR}.build.log"
		else
			say "Trying default makefile."
			make
		fi
	fi
	if [ ${?} == 0 ]
	then
		return 0
	else
		FAILED_BUILDS+=("${1}")
		return 1
	fi
}

function build_lib_and_log() {
	say "Building ${1}..."
	build_lib ${@} >"${LOG_DIR}/${1}.build.log" 2>&1
	local BUILD_ERR=${?}
	if [ ${BUILD_ERR} == 0 ]
	then
		say "SUCCESS"
	else
		say "FAILED"
	fi
}

mkdir "${LOG_DIR}"

cd "${NEMO5_LIB_DIR}/"
for CUR_DIR in *
do
	if [ -d "${NEMO5_LIB_DIR}/${CUR_DIR}" ]
	then
		case "${SKIP_LIBS}" in
		*"${CUR_DIR}"*)
			say "Skipping ${CUR_DIR}..."
			;;
		*)
			POSTPONE_LIBS_STR="`echo ${POSTPONE_LIBS[@]}`"
			case "${POSTPONE_LIBS}" in
			*"${CUR_DIR}"*)
				say "Deferring ${CUR_DIR}..."
				;;
			*)
				build_lib_and_log "${CUR_DIR}"
				;;
			esac
			;;
		esac
	fi
done

for CUR_DIR in "${POSTPONE_LIBS[@]}"
do
	build_lib_and_log "${CUR_DIR}"
done

say "Build logs written to \"${LOG_DIR}\"."
say "Failed builds:" ${FAILED_BUILDS[@]}
say "DONE."
