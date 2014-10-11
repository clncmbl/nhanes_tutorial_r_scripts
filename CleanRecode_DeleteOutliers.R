# Step 3 of task 3a

wtdmean <- function (x) {
  wtd.mean(x$LBXTC, weights=x$WTMEC4YR, na.rm=T)
}

wtdstderr <- function (x) {
  n <- sum(!is.na(x$LBXTC))
  sqrt(wtd.var(x$LBXTC, weights=x$WTMEC4YR, na.rm=T)/n)
}

demo_bp <- readRDS("../data/demo_bp2b.rds")

###demo_bp[!is.na(demo_bp$LBXTC) & demo_bp$LBXTC > 600,]

demo_bp$race <- factor(demo_bp$RIDRETH1,
                      labels=c("Mexican American",
                               "Other Hispanic",
                               "Non-Hispanic White",
                               "Non-Hispanic Black",
                               "Other Race - Including Multi-Racial"))

demo_bp <- demo_bp[demo_bp$RIDSTATR==2 & demo_bp$RIDAGEYR>=20,]

table(demo_bp$race)

lapply(split(demo_bp, demo_bp$race), wtdmean)

lapply(split(demo_bp, demo_bp$race), wtdstderr)

exclu3 <- demo_bp[is.na(demo_bp$LBXTC) | demo_bp$LBXTC < 600,]

table(exclu3$race)
#exclu3 <- exclu3[exclu3$RIDSTATR==2 & exclu3$RIDAGEYR>=20 & !is.na(exclu3$LBXTC),]

#lapply(split(exclu3, exclu3$race), function(x) wtd.mean(x$LBXTC, weights=x$WTMEC4YR))
lapply(split(exclu3, exclu3$race), wtdmean)
lapply(split(exclu3, exclu3$race), wtdstderr)

#demo_bp <- demo_bp[demo_bp$RIDSTATR==2 & demo_bp$RIDAGEYR>=20,]

# TODO: See wtd.stats in Hmisc