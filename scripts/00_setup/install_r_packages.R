#!/usr/bin/env Rscript
# Install/check R packages required by the Isoetes microbial ecology workflows.
#
# This installer intentionally does NOT install microbiomeMarker by default.
# microbiomeMarker pulls ANCOMBC/CVXR/mia/scater dependencies that may require
# Matrix >= 1.7 and frequently fail in R 4.3 conda environments. The current
# reproducible workflows in this repository do not require microbiomeMarker.
#
# Run after activating the conda environment:
#   conda activate isoetes-microbial-ecology
#   Rscript scripts/00_setup/install_r_packages.R

options(repos = c(CRAN = "https://cloud.r-project.org"))

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing CRAN package: ", pkg)
    tryCatch(
      install.packages(pkg, dependencies = TRUE),
      error = function(e) message("Could not install CRAN package ", pkg, ": ", conditionMessage(e))
    )
  } else {
    message("OK: ", pkg)
  }
}

cran_packages <- c(
  "optparse", "readr", "readxl", "dplyr", "tidyr", "ggplot2", "forcats",
  "ggpubr", "gridExtra", "gtools", "reshape2", "RColorBrewer", "pheatmap",
  "ggrepel", "tidyverse", "compositions", "zCompositions", "ggsci",
  "devtools", "remotes", "BiocManager"
)

invisible(lapply(cran_packages, install_if_missing))

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", dependencies = TRUE)
}

bioc_packages <- c(
  "phyloseq", "biomformat", "NOISeq", "edgeR", "DESeq2", "ALDEx2",
  "microbiome", "MicrobiotaProcess"
)

for (pkg in bioc_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing Bioconductor package: ", pkg)
    tryCatch(
      BiocManager::install(pkg, ask = FALSE, update = FALSE),
      error = function(e) message("Could not install Bioconductor package ", pkg, ": ", conditionMessage(e))
    )
  } else {
    message("OK: ", pkg)
  }
}

if (!requireNamespace("qiime2R", quietly = TRUE)) {
  message("Installing qiime2R from GitHub: jbisanz/qiime2R")
  tryCatch(
    remotes::install_github("jbisanz/qiime2R", upgrade = "never"),
    error = function(e) message("Could not install qiime2R from GitHub: ", conditionMessage(e))
  )
} else {
  message("OK: qiime2R")
}

message("Package installation/check completed.")
message("Note: microbiomeMarker is optional/legacy and is not required for the main workflows.")
