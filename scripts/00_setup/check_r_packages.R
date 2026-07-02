#!/usr/bin/env Rscript
# Check whether the R packages needed by the legacy and improved Isoetes workflows are installed.

required_cran <- c(
  "readr", "readxl", "dplyr", "tidyr", "ggplot2", "forcats", "pheatmap",
  "RColorBrewer", "reshape2", "ggpubr", "gtools", "optparse"
)
required_bioc <- c(
  "phyloseq", "biomformat", "qiime2R", "microbiome", "NOISeq", "edgeR",
  "DESeq2", "ALDEx2", "microbiomeMarker", "MicrobiotaProcess"
)
all_packages <- unique(c(required_cran, required_bioc))
installed <- rownames(installed.packages())
missing <- setdiff(all_packages, installed)

cat("Isoetes Microbial Ecology - R package check\n")
cat("Installed packages:", length(intersect(all_packages, installed)), "of", length(all_packages), "\n")
if (length(missing) == 0) {
  cat("All required packages are installed.\n")
} else {
  cat("Missing packages:\n")
  cat(paste0("  - ", missing, collapse = "\n"), "\n")
  cat("\nInstall CRAN packages with install.packages(...), and Bioconductor packages with BiocManager::install(...).\n")
}
