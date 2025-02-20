library(readxl)
library(dplyr)
library(gslnls)
library(mosaic)
library(ggplot2)
library(MASS)
library(xtable)
CFPBdata <- read_excel("C:/Users/dheer/OneDrive/Desktop/Research Work/Financial Overconfidence/Data/NFWBS_PUF_2016_data_cleaned.xls")
PFK_scale <-(CFPBdata$FS1_3 + CFPBdata$FS1_4 + CFPBdata$FS1_5 + CFPBdata$FS1_7)*7 + 5*(CFPBdata$SUBKNOWL1 + CFPBdata$SUBNUMERACY1)
scale <- data.frame(CFPBdata$FS1_3,CFPBdata$FS1_4,CFPBdata$FS1_5,CFPBdata$FS1_7,CFPBdata$SUBKNOWL1,CFPBdata$SUBNUMERACY1)
alpha <- cronbach.alpha(scale,na.rm = T)
CFPBdata$PFK <- ((PFK_scale - min(PFK_scale, na.rm = TRUE))/ ((max(PFK_scale, na.rm = TRUE)- min(PFK_scale, na.rm = TRUE)))*(9))+1
min(CFPBdata$PFK, na.rm = TRUE)
max(CFPBdata$PFK, na.rm = TRUE)
ggplot(CFPBdata, aes(x=PFK)) + geom_histogram(color="black", fill="indianred")+ggtitle( expression(bold(Distribution~of~phi[PFK]))) +
  xlab(expression(phi[PFK]))+ geom_vline(aes(xintercept=mean(PFK, na.rm = TRUE)),color="black", linetype="dashed", size=1)
AFK_scale <- CFPBdata$KHscore
 CFPBdata$AFK<- ((AFK_scale - min(AFK_scale, na.rm = TRUE))/ ((max(AFK_scale, na.rm = TRUE)- min(AFK_scale, na.rm = TRUE)))*(9))+1
 ggplot(CFPBdata, aes(x=AFK)) + geom_histogram(color="black", fill="lightblue")+ggtitle( expression(bold(Distribution~of~phi[AFK]))) +
   xlab(expression(phi[AFK]))+geom_vline(aes(xintercept=mean(AFK, na.rm = TRUE)),color="black", linetype="dashed", size=1)
CFPBdata$Overconfidence<- CFPBdata$PFK/CFPBdata$AFK
ggplot(CFPBdata, aes(x=Overconfidence)) + geom_histogram(color="black", fill="purple")+ggtitle( expression(bold(Distribution~of~Omega))) +
  xlab(expression(Omega))+geom_vline(aes(xintercept=mean(Overconfidence, na.rm = TRUE)),color="black", linetype="dashed", size=1)
mean(CFPBdata$Overconfidence, na.rm=TRUE)
CFPBdata$Shocks <- (CFPBdata$SHOCKS_1 + CFPBdata$SHOCKS_2 + CFPBdata$SHOCKS_3 + CFPBdata$SHOCKS_4 + CFPBdata$SHOCKS_5 + CFPBdata$SHOCKS_6 + CFPBdata$SHOCKS_8 + CFPBdata$SHOCKS_11)*(100/8)
CFPBdata$Hardship <- (CFPBdata$MATHARDSHIP_1 + CFPBdata$MATHARDSHIP_2 + CFPBdata$MATHARDSHIP_3 + CFPBdata$MATHARDSHIP_4 + CFPBdata$MATHARDSHIP_5 + CFPBdata$MATHARDSHIP_6)*((100/18))
Model1 <- lm(Overconfidence ~ Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
Model1_summary <- summary(Model1)
Model1_table <- xtable(Model1_summary)
print(Model1_table)
Model11 <- lm(Overconfidence ~ DISTRESS + SWB_1 + SWB_2 + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
Model11_summary<- summary(Model11)
Model11_table <- xtable(Model11_summary)
print(Model11_table)
Model12 <- lm(Overconfidence ~ AFK + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
summary(Model12)
Model13<- lm(Overconfidence ~ PFK + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
summary(Model13)
CFPBdata$lpmOC <- ifelse(CFPBdata$Overconfidence > 1, 1, 0) 
Model2 <- lm(lpmOC ~ Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
Model2_summary <- summary(Model2)
Model2_table <- xtable(Model2_summary) 
print(Model2_table)
Model21 <- lm(lpmOC ~ DISTRESS + SWB_1 + SWB_2 + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
Model21_summary<- summary(Model21)
Model21_table <- xtable(Model21_summary)
print(Model21_table)
Model22 <- lm(lpmOC ~ AFK + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
summary(Model22)
Model23 <- lm(lpmOC ~ PFK + Shocks + Hardship + FWBscore + factor(PPGENDER) + factor(EMPLOY) + factor(PPEDUC) + factor(PPETHM)+ factor(PPMARIT)+factor(HEALTH)+ factor(agecat) + factor(PPHHSIZE) + factor(PPINCIMP) + factor(PPREG9), data = CFPBdata)
summary(Model23)
CFPBdata$lpmUC <- ifelse(CFPBdata$Overconfidence < 1, 1, 0)
CFPBdata$lpmPC <- ifelse(CFPBdata$Overconfidence == 1, 1, 0)

