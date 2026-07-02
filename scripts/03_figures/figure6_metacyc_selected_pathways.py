#!/usr/bin/env python3
"""Generate revised Figure 6 from supplementary Table S4.

This command-line script reads the MetaCyc fold-change workbook, selects a
biologically interpretable subset of enriched pathways, groups them by functional
category, and exports a publication-ready heatmap.

Example
-------
python scripts/03_figures/figure6_metacyc_selected_pathways.py \
  --table-s4 data/raw/picrust2/Table_S4_MetaCyc_enriched_pathways.xlsx \
  --outdir figures/main \
  --processed-dir data/processed
"""
from __future__ import annotations

import argparse
import textwrap
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.patches import Rectangle

COMPARISON_MAP = {
  "N6vsAM": "N6 vs AM",
  "TI3vsAm": "TI3 vs AM",
  "TI3vsN6": "TI3 vs N6",
  "N6vsTI3": "N6 vs TI3",
  "AmvsTI3": "AM vs TI3",
  "TI350N650vsAm": "TI3+N6 vs AM",
  "Am50_N650vsAm": "AM50+N650 vs AM",
  "Am10TI390vsAm": "AM10+TI390 vs AM",
}

GROUPS = {
  "Carbon / C1 / energy metabolism": [
    "methanogenesis from H2 and CO2",
    "superpathway of C1 compounds oxidation to CO2",
    "formaldehyde assimilation I (serine pathway)",
    "TCA cycle VII (acetate-producers)",
  ],
  "Aromatic compound degradation": [
    "meta cleavage pathway of aromatic compounds",
    "catechol degradation II (meta-cleavage pathway)",
    "catechol degradation to 2-oxopent-4-enoate II",
    "protocatechuate degradation I (meta-cleavage pathway)",
  ],
  "Cofactors / vitamins": [
    "NAD salvage pathway II",
    "pyridoxal 5'-phosphate biosynthesis I",
    "adenosylcobalamin biosynthesis II (late cobalt incorporation)",
    "factor 420 biosynthesis",
  ],
  "Terpenoid / isoprenoid metabolism": [
    "mevalonate pathway I",
    "superpathway of geranylgeranyldiphosphate biosynthesis I (via mevalonate)",
  ],
  "Nitrogen / sulfur metabolism": [
    "nitrate reduction I (denitrification)",
    "superpathway of sulfolactate degradation",
  ],
  "Stress / iron / cell envelope": [
    "enterobactin biosynthesis",
    "ergothioneine biosynthesis I (bacteria)",
    "superpathway of chorismate metabolism",
    "teichoic acid (poly-glycerol) biosynthesis",
  ],
}

HIGHLIGHTS = {
  "methanogenesis from H2 and CO2",
  "mevalonate pathway I",
  "superpathway of geranylgeranyldiphosphate biosynthesis I (via mevalonate)",
  "meta cleavage pathway of aromatic compounds",
  "catechol degradation to 2-oxopent-4-enoate II",
  "enterobactin biosynthesis",
  "NAD salvage pathway II",
  "superpathway of sulfolactate degradation",
}

GROUP_COLORS = {
  "Carbon / C1 / energy metabolism": "#159A9C",
  "Aromatic compound degradation": "#E66101",
  "Cofactors / vitamins": "#7B3294",
  "Terpenoid / isoprenoid metabolism": "#2CA02C",
  "Nitrogen / sulfur metabolism": "#3366CC",
  "Stress / iron / cell envelope": "#D62728",
}


def load_fold_changes(table_s4: Path) -> pd.DataFrame:
  records = []
  for sheet, comparison in COMPARISON_MAP.items():
    df = pd.read_excel(table_s4, sheet_name=sheet)
    pathway_col = df.columns[0]
    fc_col = next(col for col in df.columns if str(col).startswith("FoldChange"))
    tmp = df[[pathway_col, fc_col]].copy()
    tmp.columns = ["pathway", "fold_change"]
    tmp["comparison"] = comparison
    tmp["source_sheet"] = sheet
    records.append(tmp)
  return pd.concat(records, ignore_index=True).dropna(subset=["pathway", "fold_change"])


def build_selected_matrix(fc: pd.DataFrame) -> tuple[list[str], list[str], list[str], np.ndarray]:
  comparisons = list(COMPARISON_MAP.values())
  lookup = {(r.pathway, r.comparison): float(r.fold_change) for r in fc.itertuples()}
  groups, pathways, matrix = [], [], []
  for group, names in GROUPS.items():
    for name in names:
      groups.append(group)
      pathways.append(name)
      matrix.append([lookup.get((name, comparison), np.nan) for comparison in comparisons])
  return comparisons, groups, pathways, np.array(matrix, dtype=float)


def plot(comparisons: list[str], groups: list[str], pathways: list[str], matrix: np.ndarray, outdir: Path) -> None:
  n_rows, n_cols = matrix.shape
  fig = plt.figure(figsize=(16.5, max(10.5, 0.47 * n_rows + 2.6)))
  gs = fig.add_gridspec(1, 4, width_ratios=[2.35, 5.0, 8.0, 0.48], wspace=0.025,
                        left=0.035, right=0.965, top=0.89, bottom=0.045)
  ax_group = fig.add_subplot(gs[0, 0])
  ax_labels = fig.add_subplot(gs[0, 1], sharey=ax_group)
  ax = fig.add_subplot(gs[0, 2], sharey=ax_group)
  cax = fig.add_subplot(gs[0, 3])

  masked = np.ma.masked_invalid(matrix)
  cmap = plt.get_cmap("viridis").copy()
  cmap.set_bad("#F2F2F2")
  im = ax.imshow(masked, aspect="auto", cmap=cmap, vmin=0.5, vmax=max(10, np.nanmax(matrix)))

  ax.set_xticks(np.arange(n_cols))
  ax.set_xticklabels([c.replace(" vs ", "\nvs ") for c in comparisons], fontsize=9, fontweight="bold")
  ax.tick_params(top=True, bottom=False, labeltop=True, labelbottom=False, pad=6)
  ax.set_yticks([])
  ax.set_xticks(np.arange(-0.5, n_cols, 1), minor=True)
  ax.set_yticks(np.arange(-0.5, n_rows, 1), minor=True)
  ax.grid(which="minor", color="white", linewidth=1.2)
  ax.tick_params(which="minor", bottom=False, left=False)

  for i in range(n_rows):
    for j in range(n_cols):
      value = matrix[i, j]
      if not np.isnan(value):
        ax.text(j, i, f"{value:.1f}", ha="center", va="center", fontsize=8,
                fontweight="bold", color="black" if value >= 7 else "white")

  for side_ax in (ax_group, ax_labels):
    side_ax.set_ylim(n_rows - 0.5, -0.5)
    side_ax.set_xlim(0, 1)
    side_ax.axis("off")

  for i, pathway in enumerate(pathways):
    label = ("★ " if pathway in HIGHLIGHTS else "") + textwrap.fill(pathway, width=43)
    ax_labels.text(0.98, i, label, ha="right", va="center", fontsize=9,
                   fontweight="bold" if pathway in HIGHLIGHTS else "normal")

  starts = [i for i, g in enumerate(groups) if i == 0 or g != groups[i - 1]] + [n_rows]
  for start, end in zip(starts[:-1], starts[1:]):
    group = groups[start]
    color = GROUP_COLORS[group]
    if start > 0:
      for a in (ax, ax_labels, ax_group):
        a.axhline(start - 0.5, color="#BFBFBF", linewidth=1.4)
    ax_group.add_patch(Rectangle((0.92, start - 0.5), 0.06, end - start, color=color, linewidth=0))
    ax_group.text(0.88, (start + end - 1) / 2, textwrap.fill(group, width=24),
                  ha="right", va="center", fontsize=10, fontweight="bold", color=color)

  fig.suptitle("Selected MetaCyc pathways enriched across contrasts", fontsize=17, fontweight="bold", y=0.975)
  cbar = fig.colorbar(im, cax=cax)
  cbar.set_label("Fold change", fontsize=11)
  cax.add_patch(Rectangle((0.0, -0.10), 0.30, 0.04, transform=cax.transAxes,
                          facecolor="#F2F2F2", edgecolor="#CCCCCC", clip_on=False))
  cax.text(0.38, -0.08, "No data", transform=cax.transAxes, va="center", ha="left", fontsize=9, clip_on=False)

  outdir.mkdir(parents=True, exist_ok=True)
  for ext in ["png", "svg", "pdf"]:
    fig.savefig(outdir / f"Figure_6_selected_MetaCyc_pathways.{ext}", dpi=600 if ext == "png" else None, bbox_inches="tight")
  plt.close(fig)


def main() -> None:
  parser = argparse.ArgumentParser(description="Generate revised Figure 6 from Table S4.")
  parser.add_argument("--table-s4", type=Path, default=Path("data/raw/picrust2/Table_S4_MetaCyc_enriched_pathways.xlsx"))
  parser.add_argument("--outdir", type=Path, default=Path("figures/main"))
  parser.add_argument("--processed-dir", type=Path, default=Path("data/processed"))
  args = parser.parse_args()

  fc = load_fold_changes(args.table_s4)
  args.processed_dir.mkdir(parents=True, exist_ok=True)
  fc.to_csv(args.processed_dir / "Table_S4_MetaCyc_tidy_fold_changes.csv", index=False)

  comparisons, groups, pathways, matrix = build_selected_matrix(fc)
  selected = []
  for group, pathway, values in zip(groups, pathways, matrix):
    row = {"functional_group": group, "pathway": pathway, "highlight": "yes" if pathway in HIGHLIGHTS else "no"}
    row.update({comparison: ("" if np.isnan(value) else round(float(value), 4)) for comparison, value in zip(comparisons, values)})
    selected.append(row)
  pd.DataFrame(selected).to_csv(args.processed_dir / "Table_S4_selected_MetaCyc_pathways_for_Figure6.csv", index=False)
  plot(comparisons, groups, pathways, matrix, args.outdir)


if __name__ == "__main__":
  main()
