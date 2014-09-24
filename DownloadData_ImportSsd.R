# sas7bdat is a SAS proprietary database format.  Many of the
# data files specific to the NHANES (CDC) tutorial are in this
# format.

# This script assumes that the downloaded sas7bdat file is in
# ../temp and the destination directory is ../data and exists.

library(sas7bdat)

tut_bpx_b <- read.sas7bdat("../temp/bpx_b.sas7bdat")

# saveRDS is a core function for writing a single R object to
# a file and has a corresponding readRDS function.

saveRDS(tut_bpx_b, "../data/tut_bpx_b.rds")

# Can later restore to any variable name with
# my_bpx_b <- readRDS("../data/tut_bpx_b.rds")
