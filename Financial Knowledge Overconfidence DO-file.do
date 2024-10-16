*Import Excel Dataset*
import excel "C:\Users\dheer\OneDrive\Desktop\Economics Senior Thesis\Data\NFWBS_PUF_2016_data_cleaned.xls", sheet("NFWBS_PUF_2016_data") firstrow
*Destring variables*
destring, replace
*Generate Vars* 
*KHScore*
gen KHScore= KH1correct+ KH2correct+ KH3correct+ KH4correct+ KH5correct+ KH6correct+ KH7correct+ KH8correct+ KH9correct
*Shock Scale* 
gen shock= SHOCKS_1+ SHOCKS_2+ SHOCKS_3+ SHOCKS_4+ SHOCKS_5+ SHOCKS_6+ SHOCKS_7+ SHOCKS_8+ SHOCKS_9+ SHOCKS_10+ SHOCKS_11
gen shock_scaled= shock*(100/11)
*Hardship*
gen hardship = (MATHARDSHIP_2 + MATHARDSHIP_3 + MATHARDSHIP_4 + MATHARDSHIP_5 + MATHARDSHIP_6)*(500/3)
*Scaling*
gen SATISFIED = SWB_1*100/7
gen OPTIMISTIC = SWB_2*100/7
gen SELFCONTROL = (SELFCONTROL_1 + SELFCONTROL_2 + SELFCONTROL_3) *(100/12) 
gen STRESS = DISTRESS*(20)
gen MATERIALISTIC = (MATERIALISM_1 + MATERIALISM_2 + MATERIALISM_3)*(100/12)
*Average and scaling Method*
*PFK*
 gen avg_pfk= (FS1_3 *420 + FS1_4 *420 + FS1_5*420 + FS1_6*420 + FS1_7*420 - FS2_3*420 + SUBKNOWL1*300 + SUBNUMERACY1*350)*(100/2100)/ 8
* AFK * 
gen avg_afk= ((LMscore*700 + KHScore*2100/9)*(100/2100))/2
*DFK*
gen DFK= avg_pfk- avg_afk
*Zscore PFK*
zscore avg_pfk
*Zscore AFK*
zscore avg_afk
*Zscore DFK* 
gen z_DFK = z_avg_pfk - z_avg_afk
*GEN INTERACTION*
gen FWB_Shock= FWBscore*shock_scaled
*Dummies for Controls* 
foreach x in PPGENDER EMPLOY HHEDUC PPEDUC PPETHM PPHHSIZE PPINCIMP PPMARIT PPREG9 agecat HEALTH { 
tab `x', gen(`x'_dummy)
}
foreach x in SATISFIED OPTIMISTIC SELFCONTROL STRESS MATERIALISTIC {
	 la var `x' "`x'"
	 }
*Control level 1 NONINTSRUMENT*
reg z_avg_pfk FWBscore z_avg_afk shock_scaled PPGENDER_dummy2 EMPLOY_dummy1 EMPLOY_dummy2 EMPLOY_dummy3  EMPLOY_dummy5 EMPLOY_dummy6 EMPLOY_dummy7 EMPLOY_dummy8 PPEDUC_dummy1 PPEDUC_dummy2  PPEDUC_dummy4 PPEDUC_dummy5 PPETHM_dummy2 PPETHM_dummy3 PPETHM_dummy4 PPMARIT_dummy2 PPMARIT_dummy3 PPMARIT_dummy4 PPMARIT_dummy5 HEALTH_dummy2 HEALTH_dummy3 HEALTH_dummy4 HEALTH_dummy5 agecat_dummy2 agecat_dummy3 agecat_dummy4 agecat_dummy5 agecat_dummy6 agecat_dummy7 agecat_dummy8, r
*Store*
estimates store OLS_C1
*Control level 2 NONINSTRUMENT*
reg z_avg_pfk FWBscore z_avg_afk shock_scaled hardship PPGENDER_dummy2 EMPLOY_dummy1 EMPLOY_dummy2 EMPLOY_dummy3  EMPLOY_dummy5 EMPLOY_dummy6 EMPLOY_dummy7 EMPLOY_dummy8 PPEDUC_dummy1 PPEDUC_dummy2  PPEDUC_dummy4 PPEDUC_dummy5 PPETHM_dummy2 PPETHM_dummy3 PPETHM_dummy4 PPMARIT_dummy2 PPMARIT_dummy3 PPMARIT_dummy4 PPMARIT_dummy5 HEALTH_dummy2 HEALTH_dummy3 HEALTH_dummy4 HEALTH_dummy5 agecat_dummy2 agecat_dummy3 agecat_dummy4 agecat_dummy5 agecat_dummy6 agecat_dummy7 agecat_dummy8 PPHHSIZE_dummy2 PPHHSIZE_dummy3 PPHHSIZE_dummy4 PPHHSIZE_dummy5 PPINCIMP_dummy2 PPINCIMP_dummy3 PPINCIMP_dummy4 PPINCIMP_dummy5 PPINCIMP_dummy6 PPINCIMP_dummy7 PPINCIMP_dummy8 PPINCIMP_dummy9 PPREG9_dummy2 PPREG9_dummy3 PPREG9_dummy4 PPREG9_dummy5 PPREG9_dummy6 PPREG9_dummy7 PPREG9_dummy8 PPREG9_dummy9, r
*Store*
estimates store OLS_C2
*Control level 3 NONINSTRUMENT**
reg z_avg_pfk FWBscore z_avg_afk shock_scaled hardship PPGENDER_dummy2 EMPLOY_dummy1 EMPLOY_dummy2 EMPLOY_dummy3  EMPLOY_dummy5 EMPLOY_dummy6 EMPLOY_dummy7 EMPLOY_dummy8 PPEDUC_dummy1 PPEDUC_dummy2  PPEDUC_dummy4 PPEDUC_dummy5 PPETHM_dummy2 PPETHM_dummy3 PPETHM_dummy4 PPMARIT_dummy2 PPMARIT_dummy3 PPMARIT_dummy4 PPMARIT_dummy5 HEALTH_dummy2 HEALTH_dummy3 HEALTH_dummy4 HEALTH_dummy5 agecat_dummy2 agecat_dummy3 agecat_dummy4 agecat_dummy5 agecat_dummy6 agecat_dummy7 agecat_dummy8 PPHHSIZE_dummy2 PPHHSIZE_dummy3 PPHHSIZE_dummy4 PPHHSIZE_dummy5 PPINCIMP_dummy2 PPINCIMP_dummy3 PPINCIMP_dummy4 PPINCIMP_dummy5 PPINCIMP_dummy6 PPINCIMP_dummy7 PPINCIMP_dummy8 PPINCIMP_dummy9 PPREG9_dummy2 PPREG9_dummy3 PPREG9_dummy4 PPREG9_dummy5 PPREG9_dummy6 PPREG9_dummy7 PPREG9_dummy8 PPREG9_dummy9 SATISFIED OPTIMISTIC SELFCONTROL STRESS MATERIALISTIC, r
*Store*
estimates store OLS_C3
*Control level 3 IV*
ivregress 2sls z_avg_pfk (FWBscore= shock_scaled hardship) z_avg_afk PPGENDER_dummy2 EMPLOY_dummy1 EMPLOY_dummy2 EMPLOY_dummy3  EMPLOY_dummy5 EMPLOY_dummy6 EMPLOY_dummy7 EMPLOY_dummy8 PPEDUC_dummy1 PPEDUC_dummy2  PPEDUC_dummy4 PPEDUC_dummy5 PPETHM_dummy2 PPETHM_dummy3 PPETHM_dummy4 PPMARIT_dummy2 PPMARIT_dummy3 PPMARIT_dummy4 PPMARIT_dummy5 HEALTH_dummy2 HEALTH_dummy3 HEALTH_dummy4 HEALTH_dummy5 agecat_dummy2 agecat_dummy3 agecat_dummy4 agecat_dummy5 agecat_dummy6 agecat_dummy7 agecat_dummy8 PPHHSIZE_dummy2 PPHHSIZE_dummy3 PPHHSIZE_dummy4 PPHHSIZE_dummy5 PPINCIMP_dummy2 PPINCIMP_dummy3 PPINCIMP_dummy4 PPINCIMP_dummy5 PPINCIMP_dummy6 PPINCIMP_dummy7 PPINCIMP_dummy8 PPINCIMP_dummy9 PPREG9_dummy2 PPREG9_dummy3 PPREG9_dummy4 PPREG9_dummy5 PPREG9_dummy6 PPREG9_dummy7 PPREG9_dummy8 PPREG9_dummy9 SATISFIED OPTIMISTIC SELFCONTROL STRESS MATERIALISTIC, r
*Store*
estimates store IVREG
*ENDOG*
estat endog