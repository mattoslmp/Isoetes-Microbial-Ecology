# Isoetes Microbial Ecology

Reproducible repository for scripts, figures and supplementary material associated with the microbial ecology and predicted functional profiling analyses of *Isoetes cangae* cultivated in pure and mixed ferruginous lake sediments from the Carajás canga ecosystem.

## What was organized

This repository is intended to contain:

- documented scripts for taxonomic differential abundance analysis;
- documented scripts for PICRUSt2 / MetaCyc predicted functional profiling;
- the revised Figure 6 based on selected MetaCyc pathways from Table S4;
- supplementary tables S1-S4;
- figure/script mapping for the current manuscript version;
- preserved legacy scripts for reproducibility.

## Revised Figure 6

The original MetaCyc heatmap contained many pathways and was difficult to read at manuscript scale. The revised version summarizes selected biologically informative pathways and groups them by functional category:

- Carbon / C1 / energy metabolism;
- Aromatic compound degradation;
- Cofactors / vitamins;
- Terpenoid / isoprenoid metabolism;
- Nitrogen / sulfur metabolism;
- Stress / iron / cell envelope.

Highlighted pathways include methanogenesis from H2 and CO2, mevalonate pathway I, geranylgeranyl diphosphate biosynthesis, aromatic compound degradation, NAD salvage pathway II, sulfolactate degradation and enterobactin biosynthesis.

## Repository structure planned

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

## Notes

The full organized repository package includes binary files such as `.xlsx`, `.png`, `.pdf`, `.docx` and `.qza`. These files are preserved in the packaged version prepared from the uploaded material. The text-based documentation and script structure should be kept in GitHub for readability, while large binary assets may be added through normal `git add` / `git push` or Git LFS if desired.
