#!/usr/bin/env bash
set -euo pipefail

# Create/update and validate the conda environment required for all repository scripts.
# This script also handles shells where `conda` is not initially in PATH.
# Usage:
#   bash scripts/00_setup/setup_conda_environment.sh

ENV_NAME="isoetes-microbial-ecology"

# Try to load conda shell integration when conda is not in PATH.
if ! command -v conda >/dev/null 2>&1; then
  for conda_sh in \
    "$HOME/anaconda3/etc/profile.d/conda.sh" \
    "$HOME/miniconda3/etc/profile.d/conda.sh" \
    "/opt/conda/etc/profile.d/conda.sh"; do
    if [ -f "$conda_sh" ]; then
      # shellcheck source=/dev/null
      source "$conda_sh"
      break
    fi
  done
fi

if command -v mamba >/dev/null 2>&1; then
  SOLVER="mamba"
elif command -v conda >/dev/null 2>&1; then
  SOLVER="conda"
else
  echo "ERROR: conda/mamba was not found in PATH."
  echo "Try one of these commands first:"
  echo "  source ~/anaconda3/etc/profile.d/conda.sh"
  echo "  source ~/miniconda3/etc/profile.d/conda.sh"
  echo "Then run this script again."
  echo "If the prompt already shows (${ENV_NAME}), the environment is active; run:"
  echo "  Rscript scripts/00_setup/install_r_packages.R"
  echo "  Rscript scripts/00_setup/check_r_packages.R"
  exit 0
fi

echo "Using solver: ${SOLVER}"
${SOLVER} env create -f environment.yml || ${SOLVER} env update -n "${ENV_NAME}" -f environment.yml

echo "Activate the environment with:"
echo "  conda activate ${ENV_NAME}"
echo "Then install/check R packages with:"
echo "  Rscript scripts/00_setup/install_r_packages.R"
echo "  Rscript scripts/00_setup/check_r_packages.R"
