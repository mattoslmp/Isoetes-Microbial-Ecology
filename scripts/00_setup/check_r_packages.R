#!/usr/bin/env Rscript
# Check whether the R packages needed by the current reproducible Isoetes workflows are installed.
# Optional legacy packages are reported separately and do not block execution.

required_cran <- c(
  "readr", "readxl", "dplyr", "tidyr", "ggplot2", "forcats", "pheatmap",
  "RColorBrewer", "reshape2", "ggpubr", "gtools", "optparse"
)

required_bioc <- c(
  "phyloseq", "biomformat", "qiime2R", "microbiome", "NOISeq", "edgeR",
  "DESeq2", "ALDEx2", "MicrobiotaProcess"
)

optional_legacy <- c("microbiomeMarker")

installed <- rownames(installed.packages())
required <- unique(c(required_cran, required_bioc))
missing_required <- setdiff(required, installed)
missing_optional <- setdiff(optional_legacy, installed)

cat("Isoetes Microbial Ecology - R package check\n")
cat("Required packages installed:", length(intersect(required, installed)), "of", length(required), "\n")

if (length(missing_required) == 0) {
  cat("All required packages for the main workflows are installed.\n")
} else {
  cat("Missing REQUIRED packages:\n")
  cat(paste0("  - ", missing_required, collapse = "\n"), "\n")
  cat("\nInstall missing required packages with scripts/00_setup/install_r_packages.R.\n")
  quit(status = 1)
}

if (length(missing_optional) > 0) {
  cat("\nOptional legacy packages not installed:\n")
  cat(paste0("  - ", missing_optional, collapse = "\n"), "\n")
  cat("These are not required for the main reproducible workflows.\n")
}
