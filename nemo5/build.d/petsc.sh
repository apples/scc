#!/bin/bash
set -e
source "$(realpath $(dirname $0))/petsc-vars.sh"
cd "$PETSC_DIR"
./configure --with-mpi-dir="$CRAY_MPICH2_DIR" --download-f-blas-lapack=1 --known-mpi-shared-libraries=False
make

