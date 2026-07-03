# Isoetes Microbial Ecology

Reproducible repository for scripts, figures, and supplementary material associated with the microbial ecology and PICRUSt2/MetaCyc functional profiling analyses of *Isoetes cangae*.

## Manuscript and supplementary material

The publication package contains:

- `manuscript/Article_Isoetes_GPM_CFC_GN_AMSO_LMP.docx`
- `supplementary_material/Supplemental_Material_Isoetes_LMP.docx`

## Environment installation

Create the conda environment and install/check R packages:

```bash
conda env create -f environment.yml
conda activate isoetes-microbial-ecology
Rscript scripts/00_setup/install_r_packages.R
Rscript scripts/00_setup/check_r_packages.R
```

Alternative one-step helper:

```bash
bash scripts/00_setup/setup_conda_environment.sh
```

Full installation and figure reproduction instructions are in:

```text
docs/INSTALL_CONDA_ENVIRONMENT.md
```

## Figure 6 workflow

```bash
python scripts/03_figures/figure6_publication_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication.csv \
  --outdir figures/main
```

or the corrected v2 script:

```bash
python scripts/03_figures/figure6_publication_heatmap_v2.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication_v2.csv \
  --outdir figures/main
```

## Supplementary table mapping

- Table S1 - sequencing quality summary.
- Table S2 - MetaCyc differential pathways used for Figure 6.
- Table S3 - taxonomic differential abundance summary.
- Table S4 - taxonomic composition / abundance summary.
- Table S5 - additional complete MetaCyc enriched-pathway workbook retained for completeness.

## Documentation

- `PUBLICATION_UPDATE.md`
- `docs/INSTALL_CONDA_ENVIRONMENT.md`
- `docs/ALL_SCRIPTS_DOCUMENTATION.md`
- `docs/SUPPLEMENTARY_MATERIAL_FINAL_MAP.md`
- `docs/COMMANDS_BY_FIGURE.md`
