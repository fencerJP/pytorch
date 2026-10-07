#!/usr/bin/env bash
# Build PyTorch with ROCm 10.1 for gfx1150. Run from the pytorch source root.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/rocm-env.sh"

echo ">> Hipify (CUDA -> HIP)"
python tools/amd_build/build_amd.py

echo ">> Build + install (editable)"
python -m pip install --no-build-isolation -e .

echo ">> Done. Optional: build a wheel into dist/"
# python -m pip wheel . --no-build-isolation --no-deps -w dist/
