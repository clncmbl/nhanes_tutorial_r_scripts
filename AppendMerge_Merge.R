library(dplyr)

demo_bp <- readRDS("../data/demo_4yr.rds")
demo_bp <- left_join(demo_bp, readRDS("../data/bpx_4yr.rds")  , by="SEQN")
demo_bp <- left_join(demo_bp, readRDS("../data/bpq_4yr.rds")  , by="SEQN")
demo_bp <- left_join(demo_bp, readRDS("../data/mcq_4yr.rds")  , by="SEQN")
demo_bp <- left_join(demo_bp, readRDS("../data/lab13_4yr.rds"), by="SEQN")
saveRDS(demo_bp, "../data/demo_bp.rds")
