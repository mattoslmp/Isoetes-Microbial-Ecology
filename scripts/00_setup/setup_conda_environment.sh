#!/usr/bin/env bash
set -euo pipefail

# Create and validate the conda environment required for all repository scripts.
# Usage:
#   bash scripts/00_setup/setup_conda_environment.sh

ENV_NAME="isoetes-microbial-ecology"

if command -v mamba >/dev/null 2>&1; then
  SOLVER="mamba"
else
  SOLVER="conda"
fi

echo "Using solver: ${SOLVER}"
${SOLVER} env create -f environment.yml || ${SOLVER} env update -n "${ENV_NAME}" -f environment.yml

echo "Activate the environment with:"
echo "  conda activate ${ENV_NAME}"
echo "Then install/check R packages with:"
echo "  Rscript scripts/00_setup/install_r_packages.R"
echo "  Rscript scripts/00_setup/check_r_packages.R"
