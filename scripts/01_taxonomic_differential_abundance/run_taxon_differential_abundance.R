#!/usr/bin/env Rscript
# Generalized taxonomic differential abundance workflow for the Isoetes sediment microbiome.
#
# This script replaces the repeated contrast-specific legacy scripts with one documented
# parameterized workflow while preserving the original NOISeq/TMM no-replicate logic.
#
# Example:
# Rscript scripts/01_taxonomic_differential_abundance/run_taxon_differential_abundance.R \
#   --features data/raw/qiime2/frequency_table.qza \
#   --taxonomy data/raw/qiime2/taxonomy_table.qza \
#   --tree data/raw/qiime2/phylo-tre-rooted.qza \
#   --metadata data/raw/qiime2/metadata.isoetes.tsv \
#   --contrasts T2:T1,T3:T1,T1:T3,T1:T2,T2:T3,T3:T2,T4:T1,T7:T1,T9:T1 \
#   --q 0.90 \
#   --outdir results/taxonomic_differential_abundance

suppressPackageStartupMessages({
  library(optparse)
  library(qiime2R)
  library(phyloseq)
  library(microbiome)
  library(NOISeq)
})

option_list <- list(
  make_option("--features", type = "character", default = "data/raw/qiime2/frequency_table.qza"),
  make_option("--taxonomy", type = "character", default = "data/raw/qiime2/taxonomy_table.qza"),
  make_option("--tree", type = "character", default = "data/raw/qiime2/phylo-tre-rooted.qza"),
  make_option("--metadata", type = "character", default = "data/raw/qiime2/metadata.isoetes.tsv"),
  make_option("--contrasts", type = "character", default = "T2:T1,T3:T1,T1:T3,T1:T2,T2:T3,T3:T2,T4:T1,T7:T1,T9:T1"),
  make_option("--q", type = "double", default = 0.90),
  make_option("--rank", type = "character", default = "Genus"),
  make_option("--outdir", type = "character", default = "results/taxonomic_differential_abundance")
)
opt <- parse_args(OptionParser(option_list = option_list))

for (f in c(opt$features, opt$taxonomy, opt$tree, opt$metadata)) {
  if (!file.exists(f)) stop("Input file not found: ", f)
}
dir.create(opt$outdir, recursive = TRUE, showWarnings = FALSE)

message("Importing QIIME2 files...")
taxonomy <- read_qza(opt$taxonomy)
phylo <- qza_to_phyloseq(features = opt$features, tree = opt$tree, metadata = opt$metadata, taxonomy = opt$taxonomy)
phylo <- merge_phyloseq(phylo, taxonomy)
ps <- prune_taxa(taxa_sums(phylo) > 0, phylo)
ps_rank <- aggregate_taxa(ps, opt$rank)

data_table <- otu_table(ps_rank)
# Treatment coding preserved from the original scripts.
colnames(data_table) <- c("T1", "T8", "T9", "T4", "T2", "T5", "T6", "T7", "T3")
col_order <- c("T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9")
data_table <- data_table[, col_order]

factors <- data.frame(
  Treatment = col_order,
  TreatmentRun = col_order,
  Run = as.character(seq_along(col_order)),
  mybiotypes = rep("otu_tax", length(col_order))
)

mydata <- readData(data = round(data_table), biotype = "otu_tax", factors = factors)
filtered <- filtered.data(
  assayData(mydata)$exprs,
  factor = "Treatment",
  norm = FALSE,
  depth = NULL,
  method = 1,
  cv.cutoff = 100,
  cpm = 1,
  p.adj = "fdr"
)
filtered <- readData(data = round(filtered), biotype = "otu_tax", factors = factors)

run_contrast <- function(contrast_string) {
  parts <- strsplit(contrast_string, ":")[[1]]
  if (length(parts) != 2) stop("Invalid contrast: ", contrast_string)
  label <- paste0(parts[1], "vs", parts[2])
  message("Running contrast: ", label)

  res <- noiseq(filtered, factor = "Treatment", k = 0.5, norm = "tmm", pnr = 0.2,
                nss = 5, v = 0.02, lc = 1, replicates = "no", conditions = parts)
  res@results[[1]]$Biotype <- "OTU"

  write.table(res@results[[1]], file.path(opt$outdir, paste0("NOISeq_", label, "_", opt$rank, ".tsv")),
              sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)

  png(file.path(opt$outdir, paste0("MD_plot_", label, "_", opt$rank, ".png")),
      width = 20, height = 15, units = "cm", res = 600)
  DE.plot(res, q = opt$q, graphic = "MD", pch = 20, cex = 1, col = 1,
          pch.sel = 2, cex.sel = 1.5, col.sel = 8, log.scale = TRUE)
  dev.off()
}

contrast_list <- trimws(unlist(strsplit(opt$contrasts, ",")))
invisible(lapply(contrast_list, run_contrast))
message("Done: ", opt$outdir)
