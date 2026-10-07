# PyTorch for ROCm 10.1 — gfx1150 (Strix / Radeon 880M / 890M)

A source build of **PyTorch 2.14.1** with **ROCm 10.1** support, targeting the AMD
**gfx1150** iGPU (Ryzen AI "Strix" — Radeon 880M / 890M).

## Result

| | |
|---|---|
| PyTorch | `2.14.1a0+git5c48869` |
| Base commit | `5c488690858` |
| ROCm platform | `10.1.0` (`/opt/rocm/core-10.1`) |
| HIP runtime | `7.16.26385` |
| Target arch | `gfx1150` |
| Dist Python | CPython 3.14 (`cp314`) |
| Verified | `torch.cuda.is_available() == True` on *AMD Radeon 890M Graphics* |

> **Note on version numbers:** `torch.version.hip` reports `7.16.x` — that is the **HIP
> runtime** version bundled inside the ROCm **10.1** platform. They are two different
> numbering schemes for the same install. ROCm platform version is in
> `/opt/rocm/core-10.1/.info/version` (`10.1.0`).

## Build environment

- Ubuntu 26.04, AMD Strix APU (`gfx1150`)
- ROCm 10.1 at `/opt/rocm/core-10.1`
- Build venv with `cmake`, `ninja`, `scikit-build-core`
- PyTorch source: this branch (hipified from the upstream commit above)

## Build steps

```bash
# 1. Environment
source rocm-10.1-gfx1150/rocm-env.sh

# 2. Hipify (CUDA -> HIP), from the pytorch source root
python tools/amd_build/build_amd.py

# 3. Build + install (editable, into the active venv)
python -m pip install --no-build-isolation -e .

# 4. Or build a distributable wheel
python -m pip wheel . --no-build-isolation --no-deps -w dist/
```

Key settings:

```
ROCM_PATH=/opt/rocm/core-10.1
PYTORCH_ROCM_ARCH=gfx1150
CMAKE_BUILD_PARALLEL_LEVEL=6          # cap jobs to avoid OOM
CMAKE_ARGS="-DUSE_FLASH_ATTENTION=OFF -DUSE_MEM_EFF_ATTENTION=OFF"
```

## Build notes / limitations

- **AOTriton is disabled.** Enabling it requires `liblzma-dev` + `pkg-config`; the build
  host had no root/apt access to install them, so flash-attention and memory-efficient
  attention were turned off to skip the AOTriton external project.
- **BLAS/LAPACK:** falls back to bundled Eigen (no MKL).
- **Jobs:** ninja defaults to one job per core; on high-core hosts this OOM-kills the
  compiler. Cap with `CMAKE_BUILD_PARALLEL_LEVEL`.
- **Do not run two builds in the same tree** — concurrent builds race on `.o.d`
  dependency files.

## Install

The prebuilt wheel is published as a **Release asset** (it is ~240 MB, above GitHub's
100 MB in-repo file limit — hence a release, not a commit).

```bash
pip install torch-2.14.1a0+git5c48869-cp314-cp314-linux_x86_64.whl
```

Quick check:

```python
import torch
print(torch.__version__, torch.version.hip, torch.cuda.is_available())
x = torch.randn(1024, 1024, device="cuda")
print((x @ x).sum().item())
```
