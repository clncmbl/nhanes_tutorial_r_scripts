library(dplyr)
library(sas7bdat)

alq   <- tbl_df(read.sas7bdat("../temp/alq.sas7bdat"))
alq_b <- tbl_df(read.sas7bdat("../temp/alq_b.sas7bdat"))
names(alq_b)[names(alq_b) == "ALD100"] <- "ALQ100"
alq_4yr <- rbind(alq, alq_b)
saveRDS(alq_4yr, "../data/alq_4yr.rds")

