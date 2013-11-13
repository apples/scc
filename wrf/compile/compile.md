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
move on to `run.md` to learn how to run WRF across the host only or in simultaneous mode across the 
host and the MICs.  Compiling WRF for the host is required to run in normal mode (host only) or 
simultaneous mode (across the host and the MICs).

#2.0 Compiling WRF for the MICs

##2.1 Quick Steps
1. Go to the `WRFV3` directory.
2. Copy the file `beninstallformic.sh` into that directory.
3. Next, make a new directory called `custom_configure` and put `configure_mic.wrf` into it.
4. Rename `configure_mic.wrf` as `configure.wrf`.
5. Check the library directories to make sure that they'll work.
6. Run that script.
7. It will configure. Choose the option for the Intel Xeon Phi.
8. All other options should be default.
9. You're finished!

##2.2 Explanation
The `beinstallformic.sh` script compiles WRF for the MICs, and should be used to run WRF across
one or all of the MICs simultaneously.  It does the same things as the file `beninstallforhost.sh`,
except the configure.wrf is a little different and it uses different compiler flags (such as `-mmic`).

As in the above-described explanation, check the `main` directory to make sure that the `wrf.exe`
executable is there. If it is, then you have successfully compiled WRF for native mode.

Once you have it successfully compiled, move on to the `run.md` readme in order to learn how to run
WRF across either all or some of the MICs.  Compiling WRF for the MICs is needed if you want to run
WRF in simultaneous mode (across the host and MICs) or native mode (across one or all MICs).
