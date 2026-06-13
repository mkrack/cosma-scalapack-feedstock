#!/bin/bash
set -ex

declare -a EXTRA_CMAKE_ARGS

# Conditionally append try_run results if cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  EXTRA_CMAKE_ARGS+=(
    -DMPI_RUN_RESULT_C_libver_mpi_normal=0
    -DMPI_RUN_RESULT_C_libver_mpi_normal__TRYRUN_OUTPUT=""
    -DMPI_RUN_RESULT_CXX_libver_mpi_normal=0
    -DMPI_RUN_RESULT_CXX_libver_mpi_normal__TRYRUN_OUTPUT=""
    -DMPI_RUN_RESULT_Fortran_libver_mpi_F08_MODULE=0
    -DMPI_RUN_RESULT_Fortran_libver_mpi_F08_MODULE__TRYRUN_OUTPUT=""
  )
fi

# Build COSMA
cmake -B build -S . \
  ${CMAKE_ARGS} \
  -GNinja \
  -DBUILD_SHARED_LIBS="ON" \
  -DCOSMA_BLAS="OPENBLAS" \
  -DCOSMA_SCALAPACK="CUSTOM" \
  -DCOSMA_USE_UNIFIED_MEMORY="OFF" \
  -DCOSMA_WITH_APPS="OFF" \
  -DCOSMA_WITH_BENCHMARKS="OFF" \
  -DCOSMA_WITH_GPU_AWARE_MPI="OFF" \
  -DCOSMA_WITH_NCCL="OFF" \
  -DCOSMA_WITH_PROFILING="OFF" \
  -DCOSMA_WITH_RCCL="OFF" \
  -DCOSMA_WITH_TESTS="OFF" \
  "${EXTRA_CMAKE_ARGS[@]}"
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
