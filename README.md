# CMake helper modules

This is a set of simple cmake modules to help cross-compiling stuff Neuromatrix DSP and embedded linux from both linux and windows environment.

## Contents

* LinuxCrossCompile.cmake  - A helper module to cross-compile dynamically linked application for _linux userspace_

* NeuromatrixToolchain.cmake  - A helper module to compile Neuromatrix DSP apps with cmake

* PkgConfigSetup.cmake - A helper module to adjust pkg-config search paths. Used by both of the above

## Getting started (Needed for all of the steps below to work)

To get started, do the following:

* Add this repository as a submodule to your project or just copy
  all the files into a subdirectory of your project, e.g. cmake-nmc

* Add this subdirectory to CMAKE_MODULE_PATH

```cmake
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake-nmc)
```
* Use them!

## Compile Neuromatrix DSP Projects with cmake

To use cmake to compile DSP apps do the following:

* Make sure NMC Toolchain binary files (nmcc, nmcpp, asm, libr, linker and friends) are in your PATH


* Include the Neuromatrix package in your CMakeLists.txt and specify the desired DSP Core variant using NMC_TARGET() macro

```cmake
  include(NeuromatrixToolchain)
  NMC_TARGET(soc)
```

The NMC_TARGET macro will initialize the sane default C/CXX/ASM flags as well as select a suitable libc to link with by default.

* All of the above should go before your PROJECT() declaration. Ideally at the very top of your CMakeLists.txt

* If, apart from C/C++ you need assembler support

```cmake
PROJECT(proj-with-asm ASM C CXX);
```

or

```cmake
PROJECT(proj-with-asm);
enable_language(ASM)
```

* For a complete example see https://github.com/RC-MODULE/easynmc-cmake-example

## Cross-compile linux userspace apps

* Include the cmake module

```cmake
  include(LinuxCrossCompile)  
```
* That's it. You can now cross-compile by typing
```
mkdir build
cd build
cmake .. -DCROSS_COMPILE=arm-rcm-linux-gnueabihf -DCMAKE_LIBRARY_PATH=arm-linux-gnueabihf
make
```

and use all the fancy stuff like pkg-config

* For a complete example see https://github.com/RC-MODULE/easynmc-cmake-example

# TODO

* Proper libeasynmc Support
* Support cores other than soc
