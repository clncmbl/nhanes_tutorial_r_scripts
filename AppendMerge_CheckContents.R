library(sas7bdat)

alq <- read.sas7bdat("../temp/alq.sas7bdat")
alq_b <- read.sas7bdat("../temp/alq_b.sas7bdat")
demo <- read.sas7bdat("../temp/demo.sas7bdat")
demo_b <- read.sas7bdat("../temp/demo_b.sas7bdat")


ci_alq <- attributes(alq)$column.info

# Need to use do.call here so that each item in the lapply
# returned list is treated as a separate parameter to rbind.
# Using "rbind(lapply(...)) would result in only one list
# parameter to rbind.
ci_alq <- do.call(rbind, lapply(ci_alq, data.frame))

ci_alq_b <- attributes(alq_b)$column.info
ci_alq_b <- do.call(rbind, lapply(ci_alq_b, data.frame))

ci_demo <- attributes(demo)$column.info
ci_demo <- do.call(rbind, lapply(ci_demo, data.frame))

ci_demo_b <- attributes(demo_b)$column.info
ci_demo_b <- do.call(rbind, lapply(ci_demo_b, data.frame))
