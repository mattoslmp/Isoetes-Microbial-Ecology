# Isoetes Microbial Ecology

Reproducible repository for scripts, figures and supplementary material associated with the microbial ecology and predicted functional profiling analyses of *Isoetes cangae* cultivated in pure and mixed ferruginous lake sediments from the Carajás canga ecosystem.

Repository link: https://github.com/mattoslmp/Isoetes-Microbial-Ecology

## Contents

This repository contains the documented code and supporting files needed to reproduce the microbial ecology analyses used in the manuscript:

- taxonomic differential abundance analysis with NOISeq;
- PICRUSt2 / MetaCyc predicted functional profiling;
- revised Figure 6 based on selected MetaCyc pathways from Table S4;
- supplementary tables S1-S4 and CSV exports for transparent inspection;
- figure-to-script mapping for the current manuscript version;
- preserved legacy scripts for traceability and reproducibility.

## Revised Figure 6

- Carbon / C1 / energy metabolism;
- Aromatic compound degradation;
- Cofactors / vitamins;
- Terpenoid / isoprenoid metabolism;
- Nitrogen / sulfur metabolism;
- Stress / iron / cell envelope.

Highlighted pathways include methanogenesis from H2 and CO2, mevalonate pathway I, geranylgeranyl diphosphate biosynthesis, aromatic compound degradation, NAD salvage pathway II, sulfolactate degradation and enterobactin biosynthesis.

Run the revised figure script with:

```bash
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s4 data/raw/picrust2/Table_S4_MetaCyc_enriched_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
```

## Command-line execution

The full execution guide is available in:

```text
docs/SCRIPTS_EXECUTION_GUIDE.md
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

## Notes on binary files

The complete organized package includes binary files such as `.xlsx`, `.png`, `.pdf`, `.docx` and `.qza`. Large binary assets should be pushed with standard Git or Git LFS when needed. Text-based documentation, command-line scripts and CSV exports are kept directly in GitHub for readability.
