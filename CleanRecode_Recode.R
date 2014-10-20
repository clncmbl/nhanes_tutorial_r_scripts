# Task 4

library(dplyr)

demo_bp <- readRDS("../data/demo_bp2b.rds")

# Setting categorical variables to factors rather than to integers
# as in the original tutorial.

demo_bp$raceth <-
  ifelse(demo_bp$RIDRETH1==3, "Non-Hispanic White",
  ifelse(demo_bp$RIDRETH1==4, "Non-Hispanic Black",
  ifelse(demo_bp$RIDRETH1==1, "Mexican American",
                              "Other")))

demo_bp$raceth <- factor(demo_bp$raceth,
                         c("Non-Hispanic White",
                           "Non-Hispanic Black",
                           "Mexican American",
                           "Other"))
  
demo_bp$age3cat <- cut(demo_bp$RIDAGEYR, c(19,39,59,150))

# Create two new blood pressure variables indicating numbers of non-null readings.
demo_bp <- mutate(demo_bp,
                  n_sbp = 4 - is.na(BPXSY1)-is.na(BPXSY2)-is.na(BPXSY3)-is.na(BPXSY4),
                  n_dbp = 4 - is.na(BPXDI1)-is.na(BPXDI2)-is.na(BPXDI3)-is.na(BPXDI4))

# Set zero diastolic bp readings to NA. (I am unclear as to why we would do that
# AFTER the preceding step and not before.)
demo_bp$BPXDI1[demo_bp$BPXDI1==0] <- NA
demo_bp$BPXDI2[demo_bp$BPXDI2==0] <- NA
demo_bp$BPXDI3[demo_bp$BPXDI3==0] <- NA
demo_bp$BPXDI4[demo_bp$BPXDI4==0] <- NA

demo_bp <- mutate(demo_bp,
                  mean_sbp = rowMeans(data.frame(BPXSY1,BPXSY2,BPXSY3,BPXSY4), na.rm=TRUE),
                  mean_dbp = rowMeans(data.frame(BPXDI1,BPXDI2,BPXDI3,BPXDI4), na.rm=TRUE))

# BPQ050A - Now taking prescribed medicine. 1-Y,2-N,7-Refused,9-Don't know,NA
# BPQ020 - Ever told you had high bp. 1-Y,2-N,7-Refused,9-Don't know,NA


