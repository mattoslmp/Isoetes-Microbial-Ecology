# Final publication update

This update documents the final publication-ready package prepared for the *Isoetes cangae* microbial ecology manuscript.

## Main corrections

- Figure 6 was reformatted as a clean selected MetaCyc pathway heatmap.
- The in-figure title was removed.
- Labels were enlarged for readability at 100% zoom.
- The fold-change scale was made smaller and less visually dominant.
- The complete original all-pathway MetaCyc heatmap was moved to the supplementary material as Figure S3.
- The article text and Figure 6 caption cite Table S2 as the source of the fold-change values used to generate Figure 6.
- Supplementary table nomenclature was corrected to avoid duplicate labels for different datasets.

## Supplementary table mapping

- Table S1: sequencing quality summary.
- Table S2: differentially abundant MetaCyc pathways used for Figure 6.
- Table S3: taxonomic differential abundance summary.
- Table S4: taxonomic composition / abundance summary.
- Table S5: additional complete MetaCyc enriched-pathway workbook retained for completeness.

## Main Figure 6 command

```bash
python scripts/03_figures/figure6_publication_heatmap.py \
  --selected-csv data/processed/Table_S2_selected_MetaCyc_pathways_publication.csv \
  --outdir figures/main
```

Expected outputs:

```text
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.png
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.svg
figures/main/Figure_6_selected_MetaCyc_pathways_PUBLICATION.pdf
```

The full publication package is available as a ZIP file in the ChatGPT delivery and includes the final manuscript, final supplementary material, all scripts, processed data, and figure files.
