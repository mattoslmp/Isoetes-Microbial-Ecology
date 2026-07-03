# Conda environment installation and figure reproduction

This document explains how to install the computational environment needed to run the R and Python scripts in this repository and regenerate the available figures.

## 1. Create the conda environment

Recommended solver: mamba. Standard conda also works, but may be slower.

```bash
conda env create -f environment.yml
```

or:

```bash
bash scripts/00_setup/setup_conda_environment.sh
```

Activate the environment:

```bash
conda activate isoetes-microbial-ecology
```

## 2. Install/check R packages

Some R packages are installed through conda, while others may need to be installed from CRAN, Bioconductor, or GitHub.

```bash
Rscript scripts/00_setup/install_r_packages.R
Rscript scripts/00_setup/check_r_packages.R
```

The installer checks packages used by the current and legacy workflows, including phyloseq, biomformat, qiime2R, NOISeq, edgeR, DESeq2, ALDEx2, microbiome, MicrobiotaProcess, microbiomeMarker, pheatmap, ggplot2, ggpubr, dplyr, tidyr, readr, readxl, forcats, gtools, RColorBrewer, reshape2, compositions, zCompositions, ggsci, textshape, and metagMisc.

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

Preferred publication script:

```bash
python scripts/03_figures/figure6_publication_heatmap_v2.py \
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
