# Scripts execution guide

Repository: `Isoetes-Microbial-Ecology`

GitHub: https://github.com/mattoslmp/Isoetes-Microbial-Ecology

This guide documents the scripts used to reproduce each manuscript figure from the available data and supplementary tables.

## 1. Environment check

Run first:

```bash
Rscript scripts/00_setup/check_r_packages.R
```

## 2. Figure 5: taxonomic differential abundance

General command-line workflow:

```bash
Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R \
  --features data/raw/qiime2/frequency_table.qza \
  --taxonomy data/raw/qiime2/taxonomy_table.qza \
  --tree data/raw/qiime2/phylo-tre-rooted.qza \
  --metadata data/raw/qiime2/metadata.isoetes.tsv \
  --contrasts T2:T1,T3:T1,T1:T3,T1:T2,T2:T3,T3:T2,T4:T1,T7:T1,T9:T1 \
  --q 0.90 \
  --outdir results/taxonomic_differential_abundance
```

The original per-contrast NOISeq scripts are preserved in:

```text
scripts/legacy_original/taxonomic_differential_abundance/
```

## 3. Figure 6: selected MetaCyc pathway heatmap

Python version used for the revised figure:

```bash
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s4 data/raw/picrust2/Table_S4_MetaCyc_enriched_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
```

R version:

```bash
Rscript scripts/03_figures/figure6_metacyc_selected_pathways.R
```

Expected outputs:

```text
figures/main/Figure_6_selected_MetaCyc_pathways.png
figures/main/Figure_6_selected_MetaCyc_pathways.svg
figures/main/Figure_6_selected_MetaCyc_pathways.pdf
data/processed/Table_S4_MetaCyc_tidy_fold_changes.csv
data/processed/Table_S4_selected_MetaCyc_pathways_for_Figure6.csv
```

## 4. PICRUSt2 / MetaCyc differential pathway workflow

```bash
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
  --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
  --outdir results/picrust_metacyc
```

The original scripts are preserved in:

```text
scripts/legacy_original/picrust_metacyc_pathways/
```

## 5. Figure-to-script map

| Figure | Script/source |
|---|---|
| Figure 1 | Source script was not present in the uploaded script folders; manuscript output preserved. |
| Figure 2 | Source script was not present in the uploaded script folders; manuscript output preserved. |
| Figure 3 | Original diversity output files preserved; source script absent from uploaded scripts folders. |
| Figure 4 | Original taxonomic profile output preserved; source script absent from uploaded scripts folders. |
| Figure 5 | `scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R` plus legacy NOISeq scripts. |
| Figure 6 | `scripts/03_figures/figure6_metacyc_selected_pathways.py` and `scripts/03_figures/figure6_metacyc_selected_pathways.R`. |
| Figure 7 | PICRUSt2/MetaCyc workflow documented in `scripts/02_picrust_metacyc_pathways/`; original output preserved. |

## Notes

The revised Figure 6 is intentionally a curated figure: it shows selected biologically informative pathways grouped by functional category, while the complete pathway list remains in Table S4.
