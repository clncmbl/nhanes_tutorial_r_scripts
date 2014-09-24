# Assumes that the downloaded XPT file is in ../temp and the
# destination directory is ../data and exists.

library(SASxport)

bpx_b <- read.xport("../temp/BPX_B.XPT")

# saveRDS is a core function for writing a single R object to
# a file and has a corresponding readRDS function.

saveRDS(bpx_b, "../data/bpx_b.rds")

# Can later restore to any variable name with
# my_bpx_b <- readRDS("../data/bpx_b.rds")
