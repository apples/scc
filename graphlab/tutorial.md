# Graphlab Custom App Tutorial

The Graphlab build directory is `/data/scc/graphlab`.

## Where to Put Your Project

In the graphlab build directory, there is a subdirectory called `apps/`.
In `apps/`, create a new subdirectory with the name of your project.
Place all source files in this new directory.

## How to Generate `CMakeLists.txt`

From within your project directory,
run `../../genapp.sh`.
This script will detect your project's name and source files,
and will generate the `CMakeLists.txt` file.

## How to Build Your Project

From the Graphlab build directory, run `./build.sh`.
This will make sure graphlab is built,
and will detect and build custom apps as well.
If graphlab is built, your app should start building immediately.

## Where to Find Binaries

If your app is named `YourApp`,
then its built files will be found in `graphlab/release/apps/YourApp/`.
Everything should be statically linked,
so feel free to move it out of that directory.
