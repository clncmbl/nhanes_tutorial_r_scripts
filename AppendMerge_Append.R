library(dplyr)
library(sas7bdat)

demo <- read.sas7bdat("../temp/demo.sas7bdat")
demo_b <- read.sas7bdat("../temp/demo_b.sas7bdat")
demo   <- select(tbl_df(demo)  , SEQN, RIDAGEYR, RIAGENDR, RIDPREG, RIDRETH1, RIDSTATR, SDDSRVYR)
demo_b <- select(tbl_df(demo_b), SEQN, RIDAGEYR, RIAGENDR, RIDPREG, RIDRETH1, RIDSTATR, SDDSRVYR)
demo_4yr <- rbind(demo, demo_b)
saveRDS(demo_4yr, "../data/demo_4yr.rds")

bpx   <- tbl_df(read.sas7bdat("../temp/bpx.sas7bdat"))
bpx_b <- tbl_df(read.sas7bdat("../temp/bpx_b.sas7bdat"))
bpx_4yr <- rbind(
  select(bpx  , SEQN, starts_with("BPXSY"), starts_with("BPXDI")),
  select(bpx_b, SEQN, starts_with("BPXSY"), starts_with("BPXDI")))
saveRDS(bpx_4yr, "../data/bpx_4yr.rds")
  
bpq   <- tbl_df(read.sas7bdat("../temp/bpq.sas7bdat"))
bpq_b <- tbl_df(read.sas7bdat("../temp/bpq_b.sas7bdat"))
bpq_4yr <- rbind(
  select(bpq  , SEQN, BPQ010,BPQ020,BPQ030,BPQ050A,BPQ070,BPQ080,BPQ100D),
  select(bpq_b, SEQN, BPQ010,BPQ020,BPQ030,BPQ050A,BPQ070,BPQ080,BPQ100D))
saveRDS(bpq_4yr, "../data/bpq_4yr.rds")

mcq   <- tbl_df(read.sas7bdat("../temp/mcq.sas7bdat"))
mcq_b <- tbl_df(read.sas7bdat("../temp/mcq_b.sas7bdat"))
mcq_4yr <- rbind(
  select(mcq  , SEQN, MCQ160B:MCQ160F),
  select(mcq_b, SEQN, MCQ160B:MCQ160F))
saveRDS(mcq_4yr, "../data/mcq_4yr.rds")

lab13   <- tbl_df(read.sas7bdat("../temp/lab13.sas7bdat"))
l13_b <- tbl_df(read.sas7bdat("../temp/l13_b.sas7bdat"))
lab13_4yr <- rbind(
  select(lab13, SEQN, LBXTC),
  select(l13_b, SEQN, LBXTC))
saveRDS(lab13_4yr, "../data/lab13_4yr.rds")
