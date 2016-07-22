# a free C compiler for 8 and 16 bit microcontrollers.
# To use it either a toolchain file is required or cmake has to be run like this:
# cmake -DCMAKE_C_COMPILER=NMC -DCMAKE_SYSTEM_NAME=Generic <dir...>
# Since NMC doesn't support C++, C++ support should be disabled in the
# CMakeLists.txt using the project() command:
# project(my_project C)

#this one not so much

set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".lib")
set(CMAKE_SHARED_LIBRARY_PREFIX "")          # lib
set(CMAKE_SHARED_LIBRARY_SUFFIX ".lib")          # .so
set(CMAKE_IMPORT_LIBRARY_PREFIX )
set(CMAKE_IMPORT_LIBRARY_SUFFIX )
set(CMAKE_EXECUTABLE_SUFFIX ".abs")    # elf actually
set(CMAKE_LINK_LIBRARY_SUFFIX ".lib")
set(CMAKE_DL_LIBS "")

set(CMAKE_C_OUTPUT_EXTENSION ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

function(nmc_try_find_dir_by_tool THETOOL THEVAR)

  if (${THEVAR})
    return()
  endif()

  if (NOT ${THETOOL})
    return()
  endif()

  if (${THETOOL})
    find_program(EXECUTABLE ${${THETOOL}})
  else()
    return()
  endif()

  if (EXECUTABLE)
    get_filename_component(${THEVAR} "${EXECUTABLE}" DIRECTORY CACHE)
  endif()
endfunction()


if (NOT NMC_LOCATION)
  message(STATUS "Detecting NMC toolchain location")
  nmc_try_find_dir_by_tool(CMAKE_C_COMPILER NMC_LOCATION)
  nmc_try_find_dir_by_tool(CMAKE_ASM_COMPILER NMC_LOCATION)
  nmc_try_find_dir_by_tool(CMAKE_CXX_COMPILER NMC_LOCATION)
  if (NMC_LOCATION)
    message(STATUS "Found toolchain in: ${NMC_LOCATION}")
  endif()
endif()

if (NOT NMC_LOCATION)
  message(FATAL_ERROR "Failed locate NMC toolchain dir")
endif()

find_program(NMCLIBR_EXECUTABLE libr PATHS "${NMC_LOCATION}" NO_DEFAULT_PATH)
set(CMAKE_AR "${NMCLIBR_EXECUTABLE}")

find_program(NMCLINKER_EXECUTABLE linker PATHS "${NMC_LOCATION}" NO_DEFAULT_PATH)
set(CMAKE_LINKER "${NMCLINKER_EXECUTABLE}")

if (NOT NMC_LIBC)
  SET(NMC_LIBC "libc05.lib")
endif()

if(${CMAKE_HOST_SYSTEM} MATCHES "Windows")
  set(INCDIR_HELPER "<INCLUDES>")
else()
  set(INCDIR_HELPER "")
endif()

set(CMAKE_C_COMPILE_OBJECT  "<CMAKE_C_COMPILER> -Tc99 <DEFINES> <FLAGS> ${INCDIR_HELPER} -Sc <SOURCE> -o<OBJECT>")
set(CMAKE_CXX_COMPILE_OBJECT  "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> ${INCDIR_HELPER} -Sc <SOURCE> -o<OBJECT>")
set(CMAKE_ASM_COMPILE_OBJECT  "<CMAKE_ASM_COMPILER> <DEFINES> <FLAGS> ${INCDIR_HELPER} <SOURCE> -o<OBJECT>")

set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o<TARGET> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -l\"$ENV{NEURO}/lib\" <LINK_LIBRARIES> ${NMC_LIBC}")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o<TARGET> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -l\"$ENV{NEURO}/lib\" <LINK_LIBRARIES> ${NMC_LIBC} ${NMC_LIBCPP}")
set(CMAKE_ASM_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o<TARGET> <CMAKE_ASM_LINK_FLAGS> <LINK_FLAGS> -l\"$ENV{NEURO}/lib\" <LINK_LIBRARIES>")

#set(CMAKE_C_LINK_EXECUTABLE "cat")
set(CMAKE_C_CREATE_STATIC_LIBRARY
      "\"${CMAKE_COMMAND}\" -E remove <TARGET>"
      "<CMAKE_AR> -a <TARGET> <LINK_FLAGS> <OBJECTS> ")

# not supported by NMC
set(CMAKE_C_CREATE_SHARED_LIBRARY "")
set(CMAKE_C_CREATE_MODULE_LIBRARY "")
