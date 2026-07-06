#!/usr/bin/env bash
set -euo pipefail

# Reproduce all analyses/figures that can be regenerated from the files included in this repository.
# Run from the repository root after activating the conda environment:
#   conda activate isoetes-microbial-ecology
#   bash scripts/run_all_available_analyses.sh

mkdir -p figures/main results/taxonomic_differential_abundance results/picrust_metacyc

Rscript scripts/00_setup/check_r_packages.R

python scripts/03_figures/figure6_publication_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication_v2.csv \
  --outdir figures/main

if [ -f "data/raw/qiime2/frequency_table.qza" ] && \
   [ -f "data/raw/qiime2/taxonomy_table.qza" ] && \
   [ -f "data/raw/qiime2/phylo-tre-rooted.qza" ] && \
   [ -f "data/raw/qiime2/metadata.isoetes.tsv" ]; then
  Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R \
    --features data/raw/qiime2/frequency_table.qza \
    --taxonomy data/raw/qiime2/taxonomy_table.qza \
    --tree data/raw/qiime2/phylo-tre-rooted.qza \
    --metadata data/raw/qiime2/metadata.isoetes.tsv \
    --contrasts T2:T1,T3:T1,T1:T3,T1:T2,T2:T3,T3:T2,T4:T1,T7:T1,T9:T1 \
    --q 0.90 \
    --rank Genus \
    --outdir results/taxonomic_differential_abundance
else
  echo "Skipping taxonomic differential abundance workflow because one or more QIIME2 input files are missing."
fi

if [ -f "data/raw/picrust2/feature-table.biom.add-path-description.tsv" ]; then
  Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
    --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
    --outdir results/picrust_metacyc
else
  echo "Skipping PICRUSt2/MetaCyc workflow because feature-table.biom.add-path-description.tsv is missing."
fi

echo "Available reproducible analyses completed. Main generated figures are in figures/main/."
