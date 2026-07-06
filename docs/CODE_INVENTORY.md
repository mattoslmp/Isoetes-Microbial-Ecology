# Code inventory

This repository contains the reproducible code used to regenerate the available analyses and figures from the publication package.

## Setup scripts

- scripts/00_setup/setup_conda_environment.sh
- scripts/00_setup/install_r_packages.R
- scripts/00_setup/check_r_packages.R

## Main workflows

- scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R
- scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R
- scripts/run_all_available_analyses.sh

## Figure scripts

- scripts/03_figures/figure6_publication_heatmap.py
- scripts/03_figures/figure6_publication_heatmap_v2.py
- scripts/03_figures/figure6_metacyc_selected_pathways.py

## Legacy/original scripts

The ZIP package preserves the original uploaded R scripts in scripts/legacy_original/, including the contrast-specific taxonomic differential-abundance scripts and the original PICRUSt2/MetaCyc plotting scripts. These scripts are kept for auditability and historical reproducibility. The cleaned and parameterized scripts listed above are recommended for rerunning the analyses.

## Correct Figure 6 command

python scripts/03_figures/figure6_publication_heatmap.py --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication_v2.csv --outdir figures/main
