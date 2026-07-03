#!/usr/bin/env python3
"""Generate the final publication Figure 6 heatmap.

The script reads a curated CSV derived from Table S2 and exports a clean,
publication-ready MetaCyc pathway heatmap in PNG, SVG and PDF formats.
The figure intentionally has no in-figure title.
"""
from __future__ import annotations

import argparse
import textwrap
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.patches import Rectangle

PALETTE = ["#149B9E", "#F26B0F", "#7A3EB1", "#3BAA27", "#2F64D6", "#E53935"]


def wrap(text: str, width: int) -> str:
  return textwrap.fill(text, width=width, break_long_words=False, break_on_hyphens=False)


def main() -> None:
  parser = argparse.ArgumentParser(description="Generate final Figure 6 heatmap.")
  parser.add_argument("--selected-csv", type=Path, default=Path("data/processed/Table_S2_selected_MetaCyc_pathways_publication.csv"))
  parser.add_argument("--outdir", type=Path, default=Path("figures/main"))
  args = parser.parse_args()

  df = pd.read_csv(args.selected_csv)
  contrast_cols = [c for c in df.columns if c not in {"functional_group", "pathway", "highlight"}]
  matrix = df[contrast_cols].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=float)
  pathways = df["pathway"].astype(str).tolist()
  groups = df["functional_group"].astype(str).tolist()
  highlights = df["highlight"].astype(str).str.lower().eq("yes").tolist()

  plt.rcParams.update({"font.family": "DejaVu Sans", "svg.fonttype": "none"})
  fig = plt.figure(figsize=(18.5, 13.5), facecolor="white")
  gs = fig.add_gridspec(1, 4, width_ratios=[0.95, 5.2, 8.6, 0.35], left=0.035, right=0.985, top=0.985, bottom=0.035, wspace=0.04)
  ax_group = fig.add_subplot(gs[0, 0])
  ax_labels = fig.add_subplot(gs[0, 1], sharey=ax_group)
  ax = fig.add_subplot(gs[0, 2], sharey=ax_group)
  cax = fig.add_subplot(gs[0, 3])

  cmap = plt.get_cmap("viridis").copy()
  cmap.set_bad("#f5f5f5")
  image = ax.imshow(np.ma.masked_invalid(matrix), aspect="auto", cmap=cmap, vmin=0.8, vmax=10.0, interpolation="nearest")

  ax.set_xticks(np.arange(len(contrast_cols)))
  ax.set_xticklabels(contrast_cols, fontsize=11.5, fontweight="bold")
  ax.tick_params(axis="x", top=True, bottom=False, labeltop=True, labelbottom=False, pad=10, length=0)
  ax.set_yticks([])
  ax.set_xticks(np.arange(-0.5, len(contrast_cols), 1), minor=True)
  ax.set_yticks(np.arange(-0.5, len(pathways), 1), minor=True)
  ax.grid(which="minor", color="white", linewidth=1.0)
  ax.tick_params(which="minor", bottom=False, left=False)
  for spine in ax.spines.values():
    spine.set_linewidth(0.7)
    spine.set_color("#c7c7c7")

  for side_ax in (ax_group, ax_labels):
    side_ax.set_xlim(0, 1)
    side_ax.set_ylim(len(pathways) - 0.5, -0.5)
    side_ax.axis("off")

  for i, pathway in enumerate(pathways):
    label = ("★ " if highlights[i] else "") + wrap(pathway, 34)
    ax_labels.text(0.99, i, label, ha="right", va="center", fontsize=12.2, fontweight="bold" if highlights[i] else "normal", color="black")

  starts = [i for i, group in enumerate(groups) if i == 0 or group != groups[i - 1]] + [len(groups)]
  group_color = {group: PALETTE[i % len(PALETTE)] for i, group in enumerate(dict.fromkeys(groups))}
  for start, end in zip(starts[:-1], starts[1:]):
    group = groups[start]
    color = group_color[group]
    if start > 0:
      for axis in (ax, ax_labels, ax_group):
        axis.axhline(start - 0.5, color="#bfbfbf", linewidth=1.25)
    ax_group.add_patch(Rectangle((0.82, start - 0.5), 0.12, end - start, color=color, lw=0))
    ax_group.text(0.78, (start + end - 1) / 2, wrap(group, 16), ha="right", va="center", fontsize=13.0, fontweight="bold", color=color)

  colorbar = fig.colorbar(image, cax=cax)
  colorbar.set_label("Fold\nchange", fontsize=10.5, labelpad=8)
  colorbar.ax.tick_params(labelsize=9.5, width=0.6, length=3)
  colorbar.outline.set_linewidth(0.6)
  colorbar.outline.set_edgecolor("#666666")

  args.outdir.mkdir(parents=True, exist_ok=True)
  fig.savefig(args.outdir / "Figure_6_selected_MetaCyc_pathways_PUBLICATION.png", dpi=600, bbox_inches="tight", facecolor="white")
  fig.savefig(args.outdir / "Figure_6_selected_MetaCyc_pathways_PUBLICATION.svg", bbox_inches="tight", facecolor="white")
  fig.savefig(args.outdir / "Figure_6_selected_MetaCyc_pathways_PUBLICATION.pdf", bbox_inches="tight", facecolor="white")


if __name__ == "__main__":
  main()
