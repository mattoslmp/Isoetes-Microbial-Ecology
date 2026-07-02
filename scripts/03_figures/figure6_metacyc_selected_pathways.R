#!/usr/bin/env Rscript
# Generate the revised Figure 6 from the curated Table S4 CSV.
#
# Input:
#   data/processed/Table_S4_selected_MetaCyc_pathways_for_Figure6.csv
#
# Outputs:
#   figures/main/Figure_6_selected_MetaCyc_pathways_from_R.png
#   figures/main/Figure_6_selected_MetaCyc_pathways_from_R.pdf
#
# The complete original Table S4 remains the source of the fold-change values. This
# CSV is a curated subset selected to improve readability in the main manuscript figure.

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

input_csv <- "data/processed/Table_S4_selected_MetaCyc_pathways_for_Figure6.csv"
outdir <- "figures/main"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(input_csv)) {
  stop("Input CSV not found: ", input_csv)
}

dat <- read.csv(input_csv, check.names = FALSE)
comparison_cols <- setdiff(colnames(dat), c("functional_group", "pathway", "highlight"))

plot_dat <- dat %>%
  mutate(
    pathway_label = ifelse(highlight == "yes", paste0("★ ", pathway), pathway),
    pathway_label = factor(pathway_label, levels = rev(unique(pathway_label))),
    functional_group = factor(functional_group, levels = unique(functional_group))
  ) %>%
  pivot_longer(
    cols = all_of(comparison_cols),
    names_to = "comparison",
    values_to = "fold_change"
  ) %>%
  mutate(
    fold_change = suppressWarnings(as.numeric(fold_change)),
    comparison = factor(comparison, levels = comparison_cols)
  )

p <- ggplot(plot_dat, aes(x = comparison, y = pathway_label, fill = fold_change)) +
  geom_tile(color = "white", linewidth = 0.35, na.rm = FALSE) +
  geom_text(aes(label = ifelse(is.na(fold_change), "", sprintf("%.1f", fold_change))),
            size = 2.6, fontface = "bold", color = "white") +
  facet_grid(functional_group ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_fill_viridis_c(option = "viridis", na.value = "grey94", limits = c(0.5, 10), name = "Fold change") +
  labs(
    title = "Selected MetaCyc pathways enriched across contrasts",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 9) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.x = element_text(face = "bold", angle = 45, hjust = 1, vjust = 1),
    axis.text.y = element_text(size = 8),
    panel.grid = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, face = "bold", size = 8),
    legend.position = "right"
  )

ggsave(file.path(outdir, "Figure_6_selected_MetaCyc_pathways_from_R.png"), p, width = 11, height = 12, dpi = 600, bg = "white")
ggsave(file.path(outdir, "Figure_6_selected_MetaCyc_pathways_from_R.pdf"), p, width = 11, height = 12, bg = "white")

message("Revised Figure 6 written to: ", outdir)
