# Isoetes Microbial Ecology

Reproducible repository for scripts, figures, tables, raw inputs, supplementary material, and manuscript files associated with the microbial ecology and PICRUSt2/MetaCyc functional profiling analyses of *Isoetes cangae*.

## Manuscript and supplementary material

The publication package contains:

- `manuscript/Article_Isoetes_GPM_CFC_GN_AMSO_LMP.docx`
- `supplementary_material/Supplemental_Material_Isoetes_LMP.docx`
- `supplementary_material/Supplemental_Material_Isoetes_LMP.pdf`
- supplementary figures S1, S2 and S3
- supplementary tables S1, S2, S3 and S4

## Environment installation

If `conda` is not found, load Anaconda first:

```bash
source ~/anaconda3/etc/profile.d/conda.sh
```

Create or activate the environment:

```bash
conda env create -f environment.yml
conda activate isoetes-microbial-ecology
```

Install/check R packages:

```bash
Rscript scripts/00_setup/install_r_packages.R
Rscript scripts/00_setup/check_r_packages.R
```

`microbiomeMarker` is optional/legacy and is not required for the main workflows.

Full installation and figure reproduction instructions are in:

```text
docs/INSTALL_CONDA_ENVIRONMENT.md
```

## Generate Figure 6

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

## Run all available analyses

```bash
bash scripts/run_all_available_analyses.sh
```

This regenerates Figure 6 and runs the available taxonomic and PICRUSt2/MetaCyc workflows when the required input files are present.

## Supplementary table mapping

- Table S1 - PRINSEQ sequencing quality summary.
- Table S2 - MetaCyc differential pathways used for Figure 6.
- Table S3 - taxonomic differential abundance summary.
- Table S4 - taxonomic composition / abundance summary.

## Code organization

- `scripts/00_setup/` - conda/R environment setup and package checks.
- `scripts/01_taxonomic_differential_abundance/` - generalized taxonomic differential-abundance workflow.
- `scripts/02_picrust_metacyc_pathways/` - PICRUSt2/MetaCyc pathway-processing workflow.
- `scripts/03_figures/` - publication figure-generation scripts.
- `scripts/legacy_original/` - original uploaded R scripts retained for reproducibility when present in the complete package.

## Documentation

- `PUBLICATION_UPDATE.md`
- `docs/INSTALL_CONDA_ENVIRONMENT.md`
- `docs/ALL_SCRIPTS_DOCUMENTATION.md`
- `docs/SUPPLEMENTARY_MATERIAL_FINAL_MAP.md`
- `docs/COMMANDS_BY_FIGURE.md`
