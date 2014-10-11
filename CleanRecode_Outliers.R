# Steps 1 and 2 of task 3a

demo_bp <- readRDS("../data/demo_bp2b.rds")

demo_bp <- demo_bp[demo_bp$RIDSTATR==2 & demo_bp$RIDAGEYR>=20,]

hist(demo_bp$LBXTC)
boxplot(demo_bp$LBXTC)

qqnorm(demo_bp$LBXTC)
# Put a line through the first and third quantiles.
qqline(demo_bp$LBXTC)

sum(!is.na(demo_bp$LBXTC))  # N
summary(demo_bp$LBXTC, digits=6) # min, q1, median, mean, q3, max, NAs
var(demo_bp$LBXTC, na.rm=T)
sd(demo_bp$LBXTC, na.rm=T)

library(e1071)
skewness(demo_bp$LBXTC, na.rm=T, type=2)
kurtosis(demo_bp$LBXTC, na.rm=T, type=2)
sum(demo_bp$LBXTC^2, na.rm=T)  # Sum of squares
sd(demo_bp$LBXTC, na.rm=T) / mean(demo_bp$LBXTC, na.rm=T) # Coeff of variation

sum(demo_bp$LBXTC, na.rm=T)

sum((demo_bp$LBXTC - mean(demo_bp$LBXTC, na.rm=T))^2, na.rm=T) # Corrected sum of squares

sd(demo_bp$LBXTC, na.rm=T) / sqrt(sum(!is.na(demo_bp$LBXTC))) # Standard error of the mean

max(demo_bp$LBXTC, na.rm=T) - min(demo_bp$LBXTC, na.rm=T) # Range
IQR(demo_bp$LBXTC, na.rm=T) # Interquartile range

t.test(demo_bp$LBXTC, na.rm=T)
# Signed-rank test.  Reported statistic is twice a large as that reported
# for SAS.  Are they different statistics?
wilcox.test(demo_bp$LBXTC, na.rm=T, alternative="two.sided")

library(nortest)
lillie.test(demo_bp$LBXTC) # Kolmogorov-Smirnov 
cvm.test(demo_bp$LBXTC[!is.na(demo_bp$LBXTC)]) # Cramer-von Mises
ad.test(demo_bp$LBXTC) # Anderson-Darling

quantile(demo_bp$LBXTC, c(1.00,.99,.95,.90,.75,.50,.25,.10,.05,.01,0), na.rm=T)

library(extremevalues)
getOutliers(demo_bp$LBXTC[!is.na(demo_bp$LBXTC)])
# Can use outlierPlot to view.

# Scatter plot of survey weight against cholesterol.
plot(demo_bp$LBXTC, demo_bp$WTMEC4YR, pch='1')

