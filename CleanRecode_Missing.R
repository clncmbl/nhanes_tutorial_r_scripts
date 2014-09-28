
demo_bp <- readRDS("../data/demo_bp.rds")

# Replace NaN values with NA.  NaN arise because of how missing values
# are coded in the original data.
# This is not obvious, but it does work to replace all in data frame.
is.na(demo_bp) <- is.na(demo_bp)

fixcols <- c("BPQ010","BPQ020","BPQ070","BPQ080",
             "MCQ160B","MCQ160C","MCQ160D","MCQ160E","MCQ160F")

# This finds all the 7s and 9s in the columns of interest and replaces
# them with NA.
demo_bp[,fixcols][demo_bp[,fixcols] == 7] <- NA
demo_bp[,fixcols][demo_bp[,fixcols] == 9] <- NA
saveRDS(demo_bp, "../data/demo_bp1.rds")
