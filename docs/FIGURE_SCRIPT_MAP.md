# Figure-to-script map

This file maps the current manuscript figures to the scripts and outputs found in the uploaded `scripts*` directories.

| Figure | Manuscript content | Available script/output | Status |
|---|---|---|---|
| Figure 1 | Survival rate of *I. cangae* after 240 days | No matching script found in the uploaded `scripts*` folders | Script absent from supplied bundle |
| Figure 2 | Leaf number, leaf area, root area, sporangia and root:shoot ratio | No matching script found in the uploaded `scripts*` folders | Script absent from supplied bundle |
| Figure 3 | NMDS and alpha diversity metrics | Original SVG outputs were present in the uploaded material | Outputs preserved in organized package; source script absent |
| Figure 4 | Taxonomic profile at phylum, family and genus levels | No matching script/image found in the uploaded `scripts*` folders | Script absent from supplied bundle |
| Figure 5 | Significantly enriched genera across comparisons | Original taxonomic differential abundance R scripts; MD plots and barplots | Legacy scripts preserved; generalized script added in package |
| Figure 6 | Significantly enriched MetaCyc pathways from PICRUSt2 | Original `Picrust_heatmap*.R`; revised Figure 6 generated from Table S4 | Regenerated and improved in package |
| Figure 7 | Functional beta-diversity / PCoA | Original SVG output was present | Output preserved in organized package; source script absent |

## Revised Figure 6 strategy

The original full heatmap was preserved, but the revised main figure uses a curated subset of pathways from Table S4. Pathways were grouped into functional categories:

- Carbon / C1 / energy metabolism;
- Aromatic compound degradation;
- Cofactors / vitamins;
- Terpenoid / isoprenoid metabolism;
- Nitrogen / sulfur metabolism;
- Stress / iron / cell envelope.

This avoids overcrowding while keeping the complete pathway set available in Table S4.
