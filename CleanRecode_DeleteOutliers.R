# Step 3 of task 3a

library(dplyr)
library(Hmisc)

demo_bp <- readRDS("../data/demo_bp2b.rds")

demo_bp$race <- factor(demo_bp$RIDRETH1,
                      labels=c("Mexican American",
                               "Other Hispanic",
                               "Non-Hispanic White",
                               "Non-Hispanic Black",
                               "Other Race - Including Multi-Racial"))

demo_bp <- demo_bp[demo_bp$RIDSTATR==2 & demo_bp$RIDAGEYR>=20,]

summarise(group_by(demo_bp,race),
          n=length(race),
          wtd_mean=wtd.mean(LBXTC, weights=WTMEC4YR),
          wtd_se=sqrt(wtd.var(LBXTC, weights=WTMEC4YR)/sum(!is.na(LBXTC))))

exclu3 <- demo_bp[is.na(demo_bp$LBXTC) | demo_bp$LBXTC < 600,]

summarise(group_by(exclu3,race),
          n=length(race),
          wtd_mean=wtd.mean(LBXTC, weights=WTMEC4YR),
          wtd_se=sqrt(wtd.var(LBXTC, weights=WTMEC4YR)/sum(!is.na(LBXTC))))
          