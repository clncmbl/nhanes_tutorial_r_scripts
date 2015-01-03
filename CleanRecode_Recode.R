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
  
demo_bp$age3cat <- cut(demo_bp$RIDAGEYR,
                       c(0,19,39,59,150),
                       include.lowest=T,
                       ordered_result=T)

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
# When translating code from SAS, remember that in SAS missing is negative infinity.

## SAS
## if BPQ050a= 1 then HBP_trt= 1 ;
## else if BPQ020 in ( 1 , 2 ) and BPQ050a < 7 then HBP_trt= 0 ;

demo_bp$HBP_trt[demo_bp$BPQ050A==1] <- 1
demo_bp$HBP_trt[(is.na(demo_bp$BPQ050A) | demo_bp$BPQ050A==2) & demo_bp$BPQ020 %in% c(1,2)] <- 0

## SAS
## if n_sbp> 0 and n_dbp> 0 then do ;
##    if mean_sbp>= 140 then SBP140= 1 ;
##    else SBP140= 0 ;
##    if mean_dbp>= 90 then DBP90= 1 ;
##    else DBP90= 0 ;
## end ;
demo_bp$SBP140[demo_bp$n_sbp > 0 & demo_bp$n_dbp > 0] <- 0
demo_bp$SBP140[demo_bp$n_sbp > 0 & demo_bp$n_dbp > 0 & demo_bp$mean_sbp >= 140] <- 1

demo_bp$DBP90[demo_bp$n_sbp > 0 & demo_bp$n_dbp > 0] <- 0
demo_bp$DBP90[demo_bp$n_sbp > 0 & demo_bp$n_dbp > 0 & demo_bp$mean_dbp >= 90] <- 1

## SAS
## if HBP_trt>= 0 and SBP140>= 0 and DBP90>= 0 then do ;
##    if HBP_trt= 1 or SBP140= 1 or DBP90= 1 then HBP= 1 ;
##    else HBP= 0 ;
## end;

demo_bp <- mutate(demo_bp, HBP = ifelse(HBP_trt >= 0 & SBP140 >= 0 & DBP90 >= 0, 0, NA) )
demo_bp <- mutate(demo_bp, HBP = ifelse(HBP == 0 & (HBP_trt == 1 | SBP140 == 1 | DBP90 == 1), 0, HBP) )

## SAS
## if BPQ100d= 1 then HLP_trt= 1 ;
## else if BPQ080 in ( 1 , 2 ) and BPQ100d< 7 then HLP_trt= 0 ;
demo_bp$HLP_trt[demo_bp$BPQ100D == 1] <- 1
demo_bp$HLP_trt[is.na(demo_bp$HLP_trt) & (is.na(demo_bp$BPQ100D) | demo_bp$BPQ100D < 7) & demo_bp$BPQ080 %in% c(1,2)] <- 0

## SAS
## if lbxtc>= 240 then HLP_lab= 1 ;
## else if lbxtc>= 0 then HLP_lab= 0 ;
demo_bp$HLP_lab[demo_bp$LBXTC >=   0] <- 0
demo_bp$HLP_lab[demo_bp$LBXTC >= 240] <- 1

## SAS
## if HLP_lab>= 0 and HLP_trt>= 0 then do ;
##    if HLP_lab= 1 or HLP_trt= 1 then HLP= 1 ;
##    else HLP= 0 ;
## end ;
demo_bp$HLP[demo_bp$HLP_lab >= 0 & demo_bp$HLP_trt >= 0] <- 0
demo_bp$HLP[demo_bp$HLP == 0 & (demo_bp$HLP_lab == 1 | demo_bp$HLP_trt == 1)] <- 1

# Some checks.
table(filter(demo_bp, HBP_trt==0, SBP140==0, DBP90==0, RIDAGEYR>=20)$HBP, useNA="always")
table(filter(demo_bp, is.na(HBP_trt) | is.na(SBP140) | is.na(DBP90), RIDAGEYR>=20)$HBP, useNA="always")
table(filter(demo_bp, RIDAGEYR>=20)$HBP, useNA="always")

table(filter(demo_bp, HLP_trt==0, HLP_lab==0, RIDAGEYR>=20)$HLP, useNA="always")
table(filter(demo_bp, is.na(HLP_trt) | is.na(HLP_lab), RIDAGEYR>=20)$HLP, useNA="always")
table(filter(demo_bp, RIDAGEYR>=20)$HLP, useNA="always")

# Checks that look more like the SAS printout from here:
# http://www.cdc.gov/nchs/tutorials/nhanes/downloads/Continuous/Clean&Recode_CheckRecodes.pdf
# From SAS code here:
# ftp://ftp.cdc.gov/pub/health_statistics/nchs/tutorial/nhanes/Continuous/CleanRecode_CheckRecodes.sas
d <- filter(demo_bp, RIDAGEYR>=20, RIDSTATR==2)
ungroup(summarize(group_by(d, raceth, RIDRETH1),
                  count=n())) %>%
#  arrange(desc(count)) %>%
  mutate(cumcount=cumsum(count),
         percent=100*count/sum(count),
         cumperc=cumsum(percent))

ungroup(summarize(group_by(d, HBP_trt, BPQ020, BPQ050A),
                  count=n())) %>%
#  arrange(desc(count)) %>%
  arrange(!is.na(HBP_trt), HBP_trt, BPQ020, !is.na(BPQ050A), BPQ050A) %>% # Sorted to match SAS
  mutate(cumcount=cumsum(count),
         percent=100*count/sum(count),
         cumperc=cumsum(percent))

summarize(group_by(d, HBP, HBP_trt, SBP140, DBP90),
                  count=n()) %>%
  ungroup() %>%
  #  arrange(desc(count)) %>%
  arrange(!is.na(HBP), HBP,
          !is.na(HBP_trt), HBP_trt,
          !is.na(SBP140), SBP140,
          !is.na(DBP90), DBP90) %>% # Sorted to match SAS
  mutate(cumcount=cumsum(count),
         percent=100*count/sum(count),
         cumperc=cumsum(percent))

ungroup(summarize(group_by(d, HLP_trt, BPQ080, BPQ100D),
                  count=n())) %>%
  #  arrange(desc(count)) %>%
  arrange(!is.na(HLP_trt), HLP_trt, BPQ080, !is.na(BPQ100D), BPQ100D) %>% # Sorted to match SAS
  mutate(cumcount=cumsum(count),
         percent=100*count/sum(count),
         cumperc=cumsum(percent))

summarize(group_by(d, HLP, HLP_trt, HLP_lab),
          count=n()) %>%
  ungroup() %>%
  #  arrange(desc(count)) %>%
  arrange(!is.na(HLP), HLP,
          !is.na(HLP_trt), HLP_trt,
          !is.na(HLP_lab), HLP_lab) %>% # Sorted to match SAS
  mutate(cumcount=cumsum(count),
         percent=100*count/sum(count),
         cumperc=cumsum(percent))

summarize(group_by(d, age3cat), N=n(), Minimum=min(RIDAGEYR), Maximum=max(RIDAGEYR))

summarize(group_by(d, SBP140), N=n(), Minimum=min(mean_sbp), Maximum=max(mean_sbp))

summarize(group_by(d, DBP90),
          NObs=n(),
          N=sum(!is.na(mean_dbp)),
          Minimum=min(mean_dbp, na.rm=T),
          Maximum=max(mean_dbp, na.rm=T))

summarize(group_by(d, HLP_lab),
          NObs=n(),
          N=sum(!is.na(LBXTC)),
          Minimum=min(LBXTC, na.rm=T),
          Maximum=max(LBXTC, na.rm=T))

# Save the recode dataset.
saveRDS(demo_bp, "../data/demo_bp3.rds")