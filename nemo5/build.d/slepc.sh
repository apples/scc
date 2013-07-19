#!/bin/bash
set -e
source "$(realpath $(dirname $0))/petsc-vars.sh"
cd "$SLEPC_DIR"
./configure
make

