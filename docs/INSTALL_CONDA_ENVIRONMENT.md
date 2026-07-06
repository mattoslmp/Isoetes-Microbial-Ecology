# Conda environment installation and figure reproduction

This document explains how to install the computational environment needed to run the R and Python scripts in this repository and regenerate the available figures.

## 1. Create or activate the conda environment

If `conda` is not found, load it first:

```bash
source ~/anaconda3/etc/profile.d/conda.sh
```

or, for Miniconda:

```bash
source ~/miniconda3/etc/profile.d/conda.sh
```

Create the environment:

```bash
conda env create -f environment.yml
conda activate isoetes-microbial-ecology
```

If the environment already exists and your prompt already shows `(isoetes-microbial-ecology)`, do not recreate it. Continue with the R package check below.

## 2. Install/check R packages

```bash
Rscript scripts/00_setup/install_r_packages.R
Rscript scripts/00_setup/check_r_packages.R
```

Important: `microbiomeMarker` is an optional legacy package and is not required for the main workflows. It can fail in R 4.3 conda environments because dependencies such as CVXR may require Matrix >= 1.7. The installer and checker now skip `microbiomeMarker` by default.

Required packages include phyloseq, biomformat, qiime2R, NOISeq, edgeR, DESeq2, ALDEx2, microbiome, MicrobiotaProcess, pheatmap, ggplot2, ggpubr, dplyr, tidyr, readr, readxl, forcats, gtools, RColorBrewer, reshape2, compositions, zCompositions, and ggsci.

## 3. Required input data layout

Place files in the following structure:

```text
data/raw/qiime2/frequency_table.qza
data/raw/qiime2/taxonomy_table.qza
data/raw/qiime2/phylo-tre-rooted.qza
data/raw/qiime2/metadata.isoetes.tsv
data/raw/picrust2/feature-table.biom.add-path-description.tsv
data/raw/picrust2/Table_S2_MetaCyc_differential_pathways.xlsx
data/processed/Table_S2_selected_MetaCyc_pathways_publication_v2.csv
```

## 4. Generate Figure 6

Use the corrected v2 CSV:

```bash
python scripts/03_figures/figure6_publication_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication_v2.csv \
  --outdir figures/main
```

Expected outputs:

```text
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.png
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.svg
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.pdf
```

## 5. Run taxonomic differential abundance analyses / Figure 5 and Figure S1

```bash
Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R \
  --features data/raw/qiime2/frequency_table.qza \
  --taxonomy data/raw/qiime2/taxonomy_table.qza \
  --tree data/raw/qiime2/phylo-tre-rooted.qza \
  --metadata data/raw/qiime2/metadata.isoetes.tsv \
  --contrasts T2:T1,T3:T1,T1:T3,T1:T2,T2:T3,T3:T2,T4:T1,T7:T1,T9:T1 \
  --q 0.90 \
  --rank Genus \
  --outdir results/taxonomic_differential_abundance
```

Expected outputs:

```text
results/taxonomic_differential_abundance/NOISeq_<contrast>_Genus.tsv
results/taxonomic_differential_abundance/MD_plot_<contrast>_Genus.png
```

## 6. Run PICRUSt2 / MetaCyc differential pathway workflow / Figure S2 support

```bash
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
  --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
  --outdir results/picrust_metacyc
```

Expected outputs:

```text
results/picrust_metacyc/MetaCyc_log_x_plus_1_matrix.csv
results/picrust_metacyc/NOISeq_MetaCyc_<contrast>.tsv
```

## 7. Run all available workflows

```bash
bash scripts/run_all_available_analyses.sh
```

## Notes

Figures 1, 2, 3, 4 and 7 were supplied as final manuscript figures or final figure outputs. Their original raw plant-trait or plotting scripts were not provided in the uploaded script set, so the repository preserves the final outputs where available and documents this limitation in docs/COMMANDS_BY_FIGURE.md.
