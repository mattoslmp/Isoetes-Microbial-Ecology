# Commands used to reproduce manuscript figures

Repository: https://github.com/mattoslmp/Isoetes-Microbial-Ecology

This document lists the command-line calls, inputs and expected outputs for each figure. When an analytical script was not present in the uploaded script folders, this is stated explicitly.

## Environment check

```bash
Rscript scripts/00_setup/check_r_packages.R
```

## Figures 1 and 2

Analytical scripts and raw plant-survival/plant-trait tables were not present in the uploaded script folders. These figures are preserved in the manuscript but cannot be regenerated from the supplied repository files alone.

## Figures 3 and 4

Final SVG/TIFF outputs were supplied in the latest manuscript package, but the analytical source scripts were not present in the uploaded script folders. The outputs are preserved in `figures/main/original_from_latest_paper/`.

## Figure 5 and Figure S1 - taxonomic differential abundance

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

Inputs: `frequency_table.qza`, `taxonomy_table.qza`, `phylo-tre-rooted.qza`, and `metadata.isoetes.tsv` in `data/raw/qiime2/`.

Outputs: NOISeq result tables and MD plots in `results/taxonomic_differential_abundance/`; supplementary barplots and MD plots are preserved in `figures/supplementary/differential_taxa/`.

## Figure 6 - selected MetaCyc pathway heatmap

The full package includes `scripts/03_figures/figure6_metacyc_selected_pathways.py`, which reads Table S2 and writes the selected CSV plus PNG/SVG/PDF figure. A generic plotting script is also available in GitHub.

Full Table S2 workflow:

```bash
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s2 data/raw/picrust2/Table_S2_MetaCyc_differential_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
```

Generic plot-only workflow:

```bash
python scripts/03_figures/plot_selected_metacyc_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_for_Figure6.csv \
  --outdir figures/main
```

Outputs:

```text
figures/main/Figure_6_selected_MetaCyc_pathways.png
figures/main/Figure_6_selected_MetaCyc_pathways.svg
figures/main/Figure_6_selected_MetaCyc_pathways.pdf
data/processed/Table_S2_MetaCyc_tidy_fold_changes.csv
data/processed/Table_S2_selected_MetaCyc_pathways_for_Figure6.csv
```

## Figure 7

A final SVG output was supplied, but a standalone analytical script was not present in the uploaded script folders. The supplied output is preserved as `figures/main/Figure_7_functional_beta_diversity_original.svg`.

## Figure S2 - PICRUSt2 pathway distribution boxplots

```bash
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
  --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
  --outdir results/picrust_metacyc
```

Input: `data/raw/picrust2/feature-table.biom.add-path-description.tsv`.

Outputs: MetaCyc log matrix and NOISeq results in `results/picrust_metacyc/`; pathway distribution outputs are preserved in `figures/supplementary/picrust_pathways/`.
