# Scripts execution guide

Repository: `Isoetes-Microbial-Ecology`

GitHub: https://github.com/mattoslmp/Isoetes-Microbial-Ecology

The complete command list for each figure is available in:

```text
docs/COMMANDS_BY_FIGURE.md
```

## Environment check

```bash
Rscript scripts/00_setup/check_r_packages.R
```

## Taxonomic differential abundance / Figure 5 and Figure S1

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

## PICRUSt2 / MetaCyc pathway workflow / Figure S2

```bash
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R \
  --feature-table data/raw/picrust2/feature-table.biom.add-path-description.tsv \
  --outdir results/picrust_metacyc
```

## Revised Figure 6 from Table S2

```bash
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s2 data/raw/picrust2/Table_S2_MetaCyc_differential_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
```

Expected Figure 6 outputs:

```text
figures/main/Figure_6_selected_MetaCyc_pathways.png
figures/main/Figure_6_selected_MetaCyc_pathways.svg
figures/main/Figure_6_selected_MetaCyc_pathways.pdf
data/processed/Table_S2_MetaCyc_tidy_fold_changes.csv
data/processed/Table_S2_selected_MetaCyc_pathways_for_Figure6.csv
```

## Note

Some figures were supplied as final images only because their original analysis scripts were not present in the uploaded script folders. These cases are listed clearly in `docs/COMMANDS_BY_FIGURE.md`.
