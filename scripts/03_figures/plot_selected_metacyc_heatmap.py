#!/usr/bin/env python3
"""Plot revised Figure 6 from a curated CSV exported from Table S2.

Input CSV columns: functional_group, pathway, highlight, followed by contrast columns.
"""
from __future__ import annotations

import argparse
import textwrap
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.patches import Rectangle

PALETTE = ["#159A9C", "#E66101", "#3366CC", "#7B3294", "#2CA02C", "#D62728"]


def main() -> None:
  parser = argparse.ArgumentParser(description="Plot selected MetaCyc heatmap from curated Table S2 CSV.")
  parser.add_argument("--selected-csv", type=Path, default=Path("data/processed/Table_S2_selected_MetaCyc_pathways_for_Figure6.csv"))
  parser.add_argument("--outdir", type=Path, default=Path("figures/main"))
  args = parser.parse_args()

  df = pd.read_csv(args.selected_csv)
  contrast_cols = [c for c in df.columns if c not in {"functional_group", "pathway", "highlight"}]
  values = df[contrast_cols].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=float)
  labels = df["pathway"].astype(str).tolist()
  groups = df["functional_group"].astype(str).tolist()
  highlights = df["highlight"].astype(str).str.lower().eq("yes").tolist()

  fig = plt.figure(figsize=(17, max(12.5, 0.42 * len(labels) + 2.4)))
  gs = fig.add_gridspec(1, 4, width_ratios=[2.2, 5.2, 8.2, 0.45], wspace=0.02, left=0.035, right=0.965, top=0.90, bottom=0.045)
  axg = fig.add_subplot(gs[0, 0])
  axl = fig.add_subplot(gs[0, 1], sharey=axg)
  ax = fig.add_subplot(gs[0, 2], sharey=axg)
  cax = fig.add_subplot(gs[0, 3])

  cmap = plt.get_cmap("viridis").copy()
  cmap.set_bad("#F7F7F7")
  im = ax.imshow(np.ma.masked_invalid(values), aspect="auto", cmap=cmap, vmin=0.5, vmax=max(10, float(np.nanmax(values))))

  ax.set_xticks(np.arange(len(contrast_cols)))
  ax.set_xticklabels([c.replace(" vs ", "\nvs ") for c in contrast_cols], fontsize=8.5, fontweight="bold")
  ax.tick_params(top=True, bottom=False, labeltop=True, labelbottom=False, pad=6)
  ax.set_yticks([])
  ax.set_xticks(np.arange(-0.5, len(contrast_cols), 1), minor=True)
  ax.set_yticks(np.arange(-0.5, len(labels), 1), minor=True)
  ax.grid(which="minor", color="white", linewidth=1.0)
  ax.tick_params(which="minor", bottom=False, left=False)

  for i in range(values.shape[0]):
    for j in range(values.shape[1]):
      v = values[i, j]
      if not np.isnan(v):
        ax.text(j, i, f"{v:.1f}", ha="center", va="center", fontsize=7.2, fontweight="bold", color="black" if v >= 7 else "white")

  for axis in (axg, axl):
    axis.set_ylim(len(labels) - 0.5, -0.5)
    axis.set_xlim(0, 1)
    axis.axis("off")

  for i, label in enumerate(labels):
    text = ("★ " if highlights[i] else "") + textwrap.fill(label, width=42, break_long_words=False)
    axl.text(0.98, i, text, ha="right", va="center", fontsize=8.1, fontweight="bold" if highlights[i] else "normal")

  color_map = {g: PALETTE[i % len(PALETTE)] for i, g in enumerate(dict.fromkeys(groups))}
  starts = [i for i, g in enumerate(groups) if i == 0 or g != groups[i - 1]] + [len(groups)]
  for start, end in zip(starts[:-1], starts[1:]):
    group = groups[start]
    color = color_map[group]
    if start > 0:
      for axis in (ax, axl, axg):
        axis.axhline(start - 0.5, color="#BDBDBD", linewidth=1.3)
    axg.add_patch(Rectangle((0.91, start - 0.5), 0.055, end - start, color=color, linewidth=0))
    axg.text(0.86, (start + end - 1) / 2, textwrap.fill(group, 25), ha="right", va="center", fontsize=9.6, fontweight="bold", color=color)

  fig.suptitle("Selected MetaCyc pathways enriched across contrasts", fontsize=17, fontweight="bold", y=0.975)
  cbar = fig.colorbar(im, cax=cax)
  cbar.set_label("Fold change", fontsize=10.5)
  args.outdir.mkdir(parents=True, exist_ok=True)
  for ext in ("png", "svg", "pdf"):
    fig.savefig(args.outdir / f"Figure_6_selected_MetaCyc_pathways.{ext}", dpi=600 if ext == "png" else None, bbox_inches="tight", facecolor="white")


if __name__ == "__main__":
  main()
