#!/bin/bash

###############################################################################
#
#  This script restarts and reconfigures each MIC specified as an argument
#  ***MUST BE RUN AS ROOT***
#
###############################################################################


###############################################################################
#
#  Binaries and Libraries to be sent to the MICs at startup
#
###############################################################################

# Binary Directory and binaries to be copied to the MICs at startup
BINDIR="/opt/intel/impi/4.1.0.024/mic/bin"
BINS="mpiexec mpiexec.hydra pmi_proxy mpirun"

# Library Directory and libraries to be copied to the MICs at startup
LIBDIR="/opt/intel/impi/4.1.0.024/mic/lib"
LIB="libmpi.so.4.1 libmpigf.so.4.1 libmpigc4.so.4.1"

# Compiler Library Directory and compiler libraries to be copied
COMPILERLIBDIR="/opt/intel/ics/lib/mic"
COMPILERLIBS="libimf.so libsvml.so libintlc.so.5"


###############################################################################
#
#  Argument parsing and sanity checking 
#
###############################################################################

# List of all available co-processors
COPROCESSORLIST="mic0 mic1 mic2 mic3"

if [ $# = 0 ];
then
  echo 'Usage: ./mic-reboot mic(0-3) [mic list] OR ./mic-reboot all'
  exit -1
fi

if [ $1 = "all" ];
then
  MICLIST=$COPROCESSORLIST
else
  for ARG in $*
  do
    MATCH=`expr match $ARG "mic[0-3]"`  
    if [ $MATCH = 0 ];
    then
      echo 'Invalid argument'
      exit -1
    fi
  done
  MICLIST=$*
fi

################################################################################
#
#  Restart the MICS and OFED-MIC, then copy files and remount the nfsshare
#
################################################################################

micctrl -Rw $MICLIST
service ofed-mic restart

#--------------Replace with pdsh and pdcp later for optimization---------------#
for MIC in $MICLIST
do
  
  # Copy hosts file and mount the nfsshare
  /data/mic/bin/scp /etc/hosts $MIC:/etc 
  /data/mic/bin/ssh $MIC 'mount -a'

  # Copy the binaries and directories listed at the top of this script
  for BIN in $BINS
  do
    /data/mic/bin/scp $BINDIR/$BIN $MIC:/bin/$BIN
  done

  for LIB in $LIBS
  do  
    /data/mic/bin/scp $LIBDIR/$LIB $MIC:/lib64/$LIB
  done

  for LIB in $COMPILERLIBS
  do
    /data/mic/bin/scp $COMPILERLIBDIR/$LIB $MIC:/lib64/$LIB
  done

  echo "Completed $MIC restart"
done

# Show mic status
micctrl -s

exit 0
