# ROCm 10.1 environment for the PyTorch gfx1150 build.
# Usage: source rocm-10.1-gfx1150/rocm-env.sh
export ROCM_PATH=/opt/rocm/core-10.1
export HIP_PATH=$ROCM_PATH
export PYTORCH_ROCM_ARCH=gfx1150
export ROCM_TARGET_LIST="gfx1150"
export PATH=$ROCM_PATH/bin:$ROCM_PATH/llvm/bin:$PATH
export LD_LIBRARY_PATH=$ROCM_PATH/lib:$ROCM_PATH/lib/llvm/lib:${LD_LIBRARY_PATH:-}
export CMAKE_PREFIX_PATH=$ROCM_PATH:${CMAKE_PREFIX_PATH:-}
export HIP_CLANG_PATH=$ROCM_PATH/lib/llvm/bin

# Cap parallel jobs to avoid OOM-killing the compiler on many-core hosts.
export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-6}

# AOTriton needs liblzma-dev; unavailable here, so skip it.
export CMAKE_ARGS="-DUSE_FLASH_ATTENTION=OFF -DUSE_MEM_EFF_ATTENTION=OFF"

export USE_ROCM=1
export USE_CUDA=0
export USE_MKLDNN=1
export USE_QNNPACK=0
export USE_XNNPACK=1
export USE_DISTRIBUTED=1
export USE_RCCL=1
export USE_SYSTEM_EIGEN=0
export BUILD_TEST=0
