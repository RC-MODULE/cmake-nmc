SET(CMAKE_SYSTEM_NAME NMC)
SET(CMAKE_SYSTEM_VERSION 1)
SET(CMAKE_C_COMPILER nmcc)
SET(CMAKE_CXX_COMPILER nmcc)
SET(CMAKE_ASM_COMPILER asm)

include(PkgConfigSetup)

macro(nmc_adjust_root_path path)
    SET(NMC_SYSROOT ${path} CACHE PATH "nmc sysroot with libraries")
    SET(CMAKE_FIND_ROOT_PATH ${path} CACHE PATH "nmc sysroot with libraries")
    PkgConfigForceSysroot(${path} "${NMC_CURRENT_CORE}/pkg-config/")
endmacro()

macro(nmc_target CORE)
    SET(NMC_CURRENT_CORE ${CORE})

    if (NOT NMC_NO_INSTALL_PREFIX_OVERRIDE)
        SET(CMAKE_INSTALL_PREFIX "/${CORE}/" CACHE PATH "default install prefix")
    endif()

    if (${CORE} MATCHES "soc")
        if(NOT DEFINED CMAKE_C_FLAGS_INIT)
          set(CMAKE_C_FLAGS_INIT "-DNEURO -O2 -soc -Xq")
        endif()

        if(NOT DEFINED CMAKE_CXX_FLAGS_INIT)
          set(CMAKE_CXX_FLAGS_INIT "-DNEURO -O2 -soc")
        endif()

        if(NOT DEFINED CMAKE_ASM_FLAGS_INIT)
          set(CMAKE_ASM_FLAGS_INIT "-soc")
        endif()

        if(NOT DEFINED CMAKE_EXE_LINKER_FLAGS_INIT)
          set (CMAKE_EXE_LINKER_FLAGS_INIT "-q2")
        endif()
        SET(NMC_LIBC "libint_soc.lib libc05.lib")
        SET(NMC_LIBCPP "cppnew05.lib")

    elseif (${CORE} MATCHES "generic")
        message("Selecting generic target, specify flags manually!")
    else()
        message(FATAL_ERROR "Core ${CORE} is not supported!")
    endif()

    #Now, let's find our sysroot directory
    if (NMC_SYSROOT)
        nmc_adjust_root_path(${NMC_SYSROOT})
    elseif (NOT NMC_SYSROOT AND EXISTS $ENV{NEURO}/sysroot)
        nmc_adjust_root_path($ENV{NEURO}/sysroot/)
    else()
        message(WARNING "Failed to find directory with NMC libraries (NMC_SYSROOT)")
    endif()
    message(STATUS "NMC sysroot with libraries: ${NMC_SYSROOT}")
endmacro()
