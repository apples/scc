#1.0 Compiling WRF for the Host

##1.1 Quick Steps
1. Go into the `WRFV3` directory. 
2. Copy the file `beninstallforhost.sh` into that directory.
3. Next, make a new directory called `custom_configure` and put `configure_host.wrf` into it.
4. Rename `configure_host.wrf` as `configure.wrf`.
5. Check the library directories to make sure that they'll work.
6. Run that script.
7. It will configure. Choose the option for the Intel Xeon Processor (dm+sp)
8. All other options should be default.
9. You're finished!

##1.2 Explanation
The `beninstallforhost.sh` script compiles WRF for the host,
with offloading enabled for MKL functions.  Change the variable `OFFLOAD_DEVICES` to 
a comma-separated list of numbers (`0-3`) representing the MICs.

The script simply cleans the source code of all compiled code, then runs the configure script.
After running said script, my build script will copy the `configure.wrf` into the `WRFV3` directory,
as the `configure.wrf` file needed to have a lot of changes that were tedious to make otherwise.

Then, it will run WRF's compile script.  If you just want it to compile `wrf.exe`, you can specify
by changing `compile em_real` to `compile wrf`.  All output will go to the file `compile.log`.

If you look into the `main` directory, you should see `wrf.exe`.  If you do see it, then the build was
successful. Congratulations!

If it was not successful, then you won't see a `wrf.exe`.  Once you have it successfully compiled,
move on to `run.md` to learn how to run WRF across the host only or in symmetric mode across the 
host and the MICs.  Compiling WRF for the host is required to run in normal mode (host only) or 
symmetric mode (across the host and the MICs).

If you're on a NICS machine, load the HDF5-Parallel module and the NetCDF module.

#2.0 Compiling WRF for the MICs

##2.1 Quick Steps
1. Go to the `WRFV3` directory.
2. Copy the file `beninstallformic.sh` into that directory.
3. Next, make a new directory called `custom_configure` and put `configure_mic.wrf` into it.
4. Rename `configure_mic.wrf` as `configure.wrf`.
5. Check the library directories to make sure that they'll work.
6. If you're on Beacon, make sure to load the NetCDF and HDF5-Parallel modules.
6. Run that script.
7. It will configure. Choose the option for the Intel Xeon Phi.
8. All other options should be default.
9. You're finished!

##2.2 Explanation
The `beinstallformic.sh` script compiles WRF for the MICs, and should be used to run WRF across
one or all of the MICs symmetric.  It does the same things as the file `beninstallforhost.sh`,
except the configure.wrf is a little different and it uses different compiler flags (such as `-mmic`).

As in the above-described explanation, check the `main` directory to make sure that the `wrf.exe`
executable is there. If it is, then you have successfully compiled WRF for native mode.

Once you have it successfully compiled, move on to the `run.md` readme in order to learn how to run
WRF across either all or some of the MICs.  Compiling WRF for the MICs is needed if you want to run
WRF in symmetric mode (across the host and MICs) or native mode (across one or all MICs).

##2.3 Editing the Configure Script
**Note: This section is only needed if you need to build WRF on a system other than Beacon or Smokey.
Ignore if you are not on either of these systems.  It merely describes how I changed the configure.wrf
file that WRF gives you by default.**

The `configure.wrf` file needed quite a bit of tweaking in order to get it working for the MICs (despite
WRF having a build system made for the MICs), and needed some more changes to get MKL to work in WRF.

###Fixing the Bugs
First, make the changes as they are listed on the [Intel website](http://software.intel.com/en-us/articles/how-to-get-wrf-running-on-the-intelr-xeon-phitm-coprocessor).  Namely, refer to section III, steps 5 and 6.

###Enabling MKL
Next, you need to make the appropriate changes to enable the MKL.  Refer heavily to any of my provided
`configure.wrf` files, and copy/paste the following *exactly* onto the appropriate lines.

1. Copy/paste the following line onto the end of your `FC` and `CC` lines:

    ```
    -openmp -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include
    ```

2. Copy/paste the following line onto the end of your `ARCH_LOCAL` line:

    ```
    -DMKL_DFTI
    ```

3. Copy/paste the following flags into your `LDFLAGS_LOCAL` line:

    ```
    -L$MKLROOT/lib/mic/libmkl_lapack95_ilp64.a

    -Wl,--start-group

    -L$MKLROOT/lib/mic/libmkl_intel_ilp64.a

    -L$MKLROOT/lib/mic/libmkl_intel_thread.a

    -L$MKLROOT/lib/mic/libmkl_core.a

    -mkl

    -Wl,--end-group

    -lpthread

    -openmp

    -I$(MKLROOT)/include/intel64/lp64

    -I$(MKLROOT)/include
    ```

Making those changes will force WRF to use MKL as opposed to the standard Fortran LAPACK routines.
