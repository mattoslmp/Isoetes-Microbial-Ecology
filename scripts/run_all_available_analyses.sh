#!/usr/bin/env bash
set -euo pipefail

# Reproduce the analyses that are possible from the files included in this repository.
# The full R workflows require the R/Bioconductor packages listed by check_r_packages.R.

Rscript scripts/00_setup/check_r_packages.R || true
Rscript scripts/03_figures/figure6_metacyc_selected_pathways.R

printf '\nRevised Figure 6 regenerated in figures/main/.\n'
printf 'To run the full taxonomic workflow:\n'
printf 'Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R\n'
printf 'To run the full PICRUSt2/MetaCyc workflow:\n'
printf 'Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R\n'
