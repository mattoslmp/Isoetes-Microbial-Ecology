#!/usr/bin/env Rscript
# PICRUSt2 MetaCyc differential pathway workflow for the Isoetes manuscript.
#
# This script documents and parameterizes the core steps present in the legacy
# Picrust_heatmap*.R scripts: import pathway abundance table, rename treatment columns,
# log-transform pathway counts, run NOISeq/TMM pairwise comparisons, and export
# results suitable for downstream heatmaps and barplots.

suppressPackageStartupMessages({
  library(optparse)
  library(readr)
  library(dplyr)
  library(NOISeq)
})

option_list <- list(
  make_option("--feature-table", type = "character", default = "data/raw/picrust2/feature-table.biom.add-path-description.tsv"),
  make_option("--outdir", type = "character", default = "results/picrust_metacyc"),
  make_option("--contrasts", type = "character", default = "N6:Am,TI3:Am,TI350_N650:Am,Am50_N650:Am,Am10_TI390:Am,N6:TI3,TI3:N6,Am:TI3")
)
opt <- parse_args(OptionParser(option_list = option_list))
if (!file.exists(opt$feature_table)) stop("Input table not found: ", opt$feature_table)
dir.create(opt$outdir, recursive = TRUE, showWarnings = FALSE)

data <- read.delim(opt$feature_table, sep = "\t", check.names = FALSE)
pathway_table <- data[1:min(366, nrow(data)), 1:min(11, ncol(data))]
pathway_descriptions <- pathway_table$description
abundance <- pathway_table[, 3:11]
abundance <- as.data.frame(lapply(abundance, as.numeric))
colnames(abundance) <- c("Am", "Am90_N610", "Am50_N650", "Am10_TI390", "TI3", "TI390_N610", "Am50_TI350", "TI350_N650", "N6")
rownames(abundance) <- pathway_descriptions

write.csv(log(round(abundance) + 1), file.path(opt$outdir, "MetaCyc_log_x_plus_1_matrix.csv"))

factors <- data.frame(
  Treatment = colnames(abundance),
  TreatmentRun = colnames(abundance),
  Run = as.character(seq_along(colnames(abundance))),
  biotype = rep("pathway", ncol(abundance))
)

mydata <- readData(data = round(abundance), biotype = "pathway", factors = factors)
filtered <- filtered.data(assayData(mydata)$exprs, factor = "Treatment", norm = FALSE,
                          depth = NULL, method = 1, cv.cutoff = 100, cpm = 1, p.adj = "fdr")
filtered <- readData(data = round(filtered), biotype = "pathway", factors = factors)

run_contrast <- function(contrast_string) {
  parts <- strsplit(contrast_string, ":")[[1]]
  if (length(parts) != 2) stop("Invalid contrast: ", contrast_string)
  label <- paste0(parts[1], "vs", parts[2])
  message("Running pathway contrast: ", label)
  result <- noiseq(filtered, factor = "Treatment", k = 0.5, norm = "tmm",
                   pnr = 0.2, nss = 5, v = 0.02, lc = 1,
                   replicates = "no", conditions = parts)
  result@results[[1]]$Biotype <- "MetaCyc_pathway"
  write.table(result@results[[1]], file.path(opt$outdir, paste0("NOISeq_MetaCyc_", label, ".tsv")),
              sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)
}

contrast_list <- trimws(unlist(strsplit(opt$contrasts, ",")))
invisible(lapply(contrast_list, run_contrast))
message("Done: ", opt$outdir)
