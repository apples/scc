#!/bin/bash

MY_DIR="$(pwd)"

function say {
	echo "[GENAPP]" $@
}

case "${MY_DIR}" in
*apps*)
	CPPS="$(echo *.cpp)"
	APPNAME="${MY_DIR##*/}"
	say "Found app \"${APPNAME}\"."
	rm CMakeLists.txt
	echo "project(${APPNAME})" >> CMakeLists.txt
	echo "add_graphlab_executable(${APPNAME} ${CPPS})" >> CMakeLists.txt
	say "Done."
	;;
*)
	say "Must be in apps directory!"
	;;
esac

