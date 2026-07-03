# Script documentation

This document summarizes each script stored in the repository, including purpose, execution example, expected inputs, and outputs.

## scripts/00_setup/check_r_packages.R

Purpose: check whether required R packages are installed.

Run:

```bash
Rscript scripts/00_setup/check_r_packages.R
```

Input: none.

Output: console report listing installed/missing packages.

## scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R

Purpose: run NOISeq-based differential taxonomic abundance analyses and generate MD plots.

Run:

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

Inputs: frequency table, taxonomy table, rooted tree, metadata.

Outputs: NOISeq result tables and MD plots in `results/taxonomic_differential_abundance/`.

## scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R

Purpose: process PICRUSt2 MetaCyc pathway abundance tables and generate pathway-level differential abundance outputs.

Run:

```bash
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
  --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
  --outdir results/picrust_metacyc
```

Input: `data/raw/picrust2/feature-table.biom.add-path-description.tsv`.

Outputs: processed pathway tables and NOISeq pathway results in `results/picrust_metacyc/`.

## scripts/03_figures/figure6_publication_heatmap.py

Purpose: generate the final clean, high-resolution Figure 6 from the publication selected pathway CSV.

Run:

```bash
python scripts/03_figures/figure6_publication_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication.csv \
  --outdir figures/main
```

Input: `data/processed/Table_S2_selected_MetaCyc_pathways_publication.csv`.

Outputs:

- `figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.png`
- `figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.svg`
- `figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.pdf`

## scripts/run_all_available_analyses.sh

Purpose: convenience shell script to execute the available reproducible analyses sequentially.

Run:

```bash
bash scripts/run_all_available_analyses.sh
```

Inputs: same inputs required by the R/Python scripts above.

Outputs: combined outputs in the `results/`, `data/processed/`, and `figures/` directories.

## scripts/legacy_original/

This directory preserves the original analytical scripts exactly as provided in the source material for traceability.

### Legacy taxonomic differential abundance scripts

Stored under `scripts/legacy_original/taxonomic_differential_abundance/`.

Run each one with:

```bash
Rscript scripts/legacy_original/taxonomic_differential_abundance/<script_name>.R
```

Expected inputs: the same QIIME2-derived taxonomic abundance, taxonomy, and metadata files used in the main workflow.

Expected outputs: contrast-specific NOISeq tables and plots as defined internally by each original script.

### Legacy PICRUSt2 / MetaCyc scripts

Stored under `scripts/legacy_original/picrust_metacyc_pathways/`.

Run each one with:

```bash
Rscript scripts/legacy_original/picrust_metacyc_pathways/<script_name>.R
```

Expected inputs: MetaCyc pathway abundance tables produced from PICRUSt2.

Expected outputs: heatmaps and barplots as defined internally by each original script.
