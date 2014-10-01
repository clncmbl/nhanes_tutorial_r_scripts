library(dplyr)

demo_bp <- readRDS("../data/demo_bp1.rds")


demo_bpA <- demo_bp
demo_bpA <- mutate(demo_bpA, BPQ030 = ifelse(BPQ020==2, 2, BPQ030))
saveRDS(demo_bpA, "../data/demo_bp2a.rds")

demo_bpB <- demo_bp
demo_bpB <- mutate(demo_bpB, diagHTN = ifelse(BPQ020==2, 2, BPQ030))
saveRDS(demo_bpB, "../data/demo_bp2b.rds")
