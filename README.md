# CMAKE Support for Neuromatrix DSP

To use cmake to compile DSP apps do the following:

* Make sure NMC Toolchain binary files (nmcc, nmcpp, asm, libr, linker and friends) are in your PATH

* Add this repository as a submodule to your project or just copy
  all the files into a subdirectory of your project

* Add this subdirectory to CMAKE_MODULE_PATH

```cmake
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}/cmake-nmc)
```

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

# TODO

* Proper libeasynmc Support

* PkgConfig Support

* Support cores other than soc
