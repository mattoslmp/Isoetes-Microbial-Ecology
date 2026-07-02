# Isoetes Microbial Ecology

Reproducible repository for scripts, figures and supplementary material associated with the microbial ecology and predicted functional profiling analyses of *Isoetes cangae* cultivated in pure and mixed ferruginous lake sediments from the Carajás canga ecosystem.

Repository link: https://github.com/mattoslmp/Isoetes-Microbial-Ecology

## Contents

This repository contains the documented code and supporting files needed to reproduce the microbial ecology analyses used in the manuscript:

- taxonomic differential abundance analysis with NOISeq;
- PICRUSt2 / MetaCyc predicted functional profiling;
- revised Figure 6 based on selected MetaCyc pathways from Table S2;
- supplementary tables S1-S4 and CSV exports for transparent inspection;
- figure-to-script mapping for the current manuscript version;
- preserved legacy scripts for traceability and reproducibility.

## Revised Figure 6

The original MetaCyc heatmap contained many pathways and was difficult to read at manuscript scale. The revised version summarizes selected biologically informative pathways from Table S2 and groups them by functional category:

- Carbon / C1 / energy metabolism;
- Aromatic compound degradation;
- Nitrogen / sulfur / phosphorus metabolism;
- Iron acquisition / cofactors / redox;
- Terpenoid / isoprenoid metabolism;
- Stress / cell envelope.

Highlighted pathways include methanogenesis from H2 and CO2, methanogenesis from acetate, reductive acetyl-CoA pathway, aromatic compound degradation, nitrate reduction, sulfur oxidation, sulfolactate degradation, methylphosphonate degradation, enterobactin biosynthesis, NAD salvage pathway II, mevalonate pathway I and geranylgeranyl diphosphate biosynthesis.

Run the revised figure script with:

```bash
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s2 data/raw/picrust2/Table_S2_MetaCyc_differential_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
```

## Command-line execution

The full execution guide is available in:

```text
docs/COMMANDS_BY_FIGURE.md
```

Main commands:

```bash
Rscript scripts/00_setup/check_r_packages.R
Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R
Rscript scripts/02_picrust_metacyc_pathways/run_picrust_metacyc_noiseq_workflow.R
python scripts/03_figures/figure6_metacyc_selected_pathways.py
```

## Repository structure

```text
Isoetes-Microbial-Ecology/
├── data/
│   ├── raw/
│   └── processed/
├── figures/
│   ├── main/
│   └── supplementary/
├── scripts/
│   ├── 00_setup/
│   ├── 01_taxonomic_differential_abundance/
│   ├── 02_picrust_metacyc_pathways/
│   ├── 03_figures/
│   └── legacy_original/
├── supplementary_material/
│   └── tables/
├── manuscript/
└── docs/
```

## Notes on unavailable source scripts

The uploaded `scripts*` folders did not contain the analytical source scripts or raw non-microbial trait data used to regenerate Figures 1, 2, 3, 4 and 7 from scratch. These final figure outputs are preserved where supplied, and this limitation is documented in `docs/COMMANDS_BY_FIGURE.md`.

## Notes on binary files

The complete organized package includes binary files such as `.xlsx`, `.png`, `.pdf`, `.docx` and `.qza`. Large binary assets should be pushed with standard Git or Git LFS when needed. Text-based documentation, command-line scripts and CSV exports are kept directly in GitHub for readability.
