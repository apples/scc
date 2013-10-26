#!/bin/bash
COPROCESSORS="10.0.0.2 10.0.0.3 10.0.0.4 10.0.0.5 10.0.0.7 10.0.0.8 10.0.0.9 10.0.0.10"
MPIBINDIR="/opt/intel/impi/4.1.0.024/mic/bin"
MPILIBDIR="/opt/intel/impi/4.1.0.024/mic/lib"
MPICOMPILERLIB="/opt/intel/ics/composer_xe_2013.1.117/compiler/lib/mic"
MKLLIBDIR="/opt/intel/ics/composer_xe_2013.1.117/mkl/lib/mic"

for coprocessor in `echo $COPROCESSORS`
do
    #Copy the MPI bin directory
    for prog in mpiexec mpiexec.hydra pmi_proxy mpirun
    do
        /data/mic/bin/scp $MPIBINDIR/$prog $coprocessor:/bin/$prog
    done
    
    #Copy the MPI libraries
    for lib in libmpi.so.4 libmpigf.so.4 libmpigc4.so.4 libmpi_mt.so.4
    do
        /data/mic/bin/scp $MPILIBDIR/$lib $coprocessor:/lib64/$lib
    done

    #Copy the MPI compiler libraries
    for lib in libimf.so libsvml.so libintlc.so.5 libiomp5.so
    do
        /data/mic/bin/scp $MPICOMPILERLIB/$lib $coprocessor:/lib64/$lib
    done

    #Copy the MKL libraries (specifically for WRF)
    for lib in $MKLLIBDIR/*.so
    do
        /data/mic/bin/scp $lib $coprocessor:/lib64/
    done
done
