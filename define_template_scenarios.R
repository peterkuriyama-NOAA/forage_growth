#-------------------------
#Define scenario templates
#----------------------------------------------------------------------
#Run ss3sim example

# load_all("../ss3sim")
# library(ss3sim)

# load_all("../r4ss")
# library(r4ss)


#Four OMs:
#1. Time-invariant growth; time-invariant selectivity
#2. Time-varying growth, no time-varying selectivity
#3. Time-invariant growth, time-varying selectivity
#4. Time-varying growth and time-varying selectivity

#Four EMs:
#1. Time-invariant growth and Time-invariant selectivity
#2. Time-varying growth, no time-varying selectivity
#3. Time-invariant growth, time-varying selectivity
#4. Time-varying growth; time-varying selectivity

#D5: Index every 3 years (sd = .3), 25 lengths, 5 ages
#D6: Index every 2 years (sd = .2), 100 lengths, 100 ages
#D7: Index every 3 year (sd = .2), 100 lengths, 100 ages
#D8: Index every year (sd = .4); 100 lengths and 100 ages

#----------------------------------------------------------------------
#Development examples
# Use the boiler-plate data frame available in {ss3sim} for 2 scenarios

df <- setup_scenarios_defaults(nscenarios = 1)

#Specify specifics for the short 60 year model
df$cf.years.1 <- "11:60"

#Add in F pattern 
df$cf.fvals.1 <- "c(seq(.02, .4, length = 25), rev(seq(.02, .4, length = 25)))"
df$cf.ses.1 <- "rep(.05, 50)"

# Turn off bias adjustment and use default settings in cod EM model
df[, "bias_adjust"] <- FALSE
# df[, grep("^cf//.", colnames(df))]
# df[, grep("^s[al]//.", colnames(df))]

# Survey sampling
df[, "si.years.2"] <- "seq(11, 60, by = 1)"

# Set sd of observation error for each scenario
#Observation error will be high when biomass is low and low when biomass is higher
df[, "si.sds_obs.2"] <- "rep(.1, 50)" 
# df[, "si.sds_obs.2"] <- "c(rep(0.05, 30), rep(0.05, 12), rep(0.05, 8))" 

#Estimate natural mortality
# df[, "ce.par_name"] <- "NatM_uniform_Fem_GP_1"
# df[, "ce.par_name"] <- "NatM_p_1_Fem_GP_1"
# df[, "ce.par_int"] <- .6

#Years for sampling of length comps for fleet (1) and survey (2)
yy <- "10:60"
df$sl.years.1 <- yy
df$sl.years.2 <- yy

df$sa.years.1 <- yy
df$sa.years.2 <- yy

df$sc.years.2 <- yy

df$sl.Nsamp.1 <- "100"
df$sl.Nsamp.2 <- "100"

df$sa.Nsamp.1 <- "100"
df$sa.Nsamp.2 <- "100"

df$sc.Nsamp_lengths.2 <- "100"
df$sc.Nsamp_ages.2 <- "75"



#------------------------------------------------------------------
#Define specific data scenarios
###Data scenario 0: Highest quality data
D0 <- df  
D0$dat <- "D0"

###Data scenario 1: Drop CAAL Data
D1 <- df #Drop CAAL data
D1[, grep("sc", names(D1))] <- "NA"
D1$dat <- "D1"

#Data scenario 2: Every other year index
D2 <- D0

D2[, grep("si", names(D2))]
D2$si.years.2 <- "seq(11, 60, by = 2)"
D2$si.sds_obs.2 <- "rep(.1, 25)"
D2$dat <- "D2"

#Data scenario 3: Fewer age samples
D3 <- D0
D3$sa.Nsamp.1 <- "50"
D3$sa.Nsamp.2 <- "50"
D3$sc.Nsamp_lengths.2 <- "75"
D3$dat <- "D3"

D4 <- D0
D4$sa.Nsamp.1 <- "25"
D4$sa.Nsamp.2 <- "25"
D4$sc.Nsamp_lengths.2 <- "25"
D4$sc.Nsamp_ages.2 <- "25"
D4$sc.Nsamp_lengths.2 <- "25"

D4$dat <- "D4"

#Survey every 3 years, 5 ages, 25 lengths

D6 <- D0

D6$si.years.2 <- "seq(11, 60, by = 2)"
D6$si.sds_obs.2 <- "rep(.2, 25)"
# D6$sl.Nsamp.1 <- "25"
# D6$sl.Nsamp.2 <- "25"
# D6$sa.Nsamp.1 <- "5"
# D6$sa.Nsamp.2 <- "5"
# D6$sc.Nsamp_ages.2 <- "5"
# D6$sc.Nsamp_lengths.2 <- "25"
D6$dat <- "D6"



#------------------------------------------------------------------
# Specify OM and EMs for models

# Look in v2_models folder; for the updated growth models
scens <- rbind(D0, D1, D2, D3, D4, D6)

#Only run D5
# scens <- D5

#Only look at high data scenario right now
# scens <- D0

scens$om_dir <- "models/OM14"

####
scens1 <- scens 
scens1$em_dir <- "models/EM1"
scens1$scenarios <- paste0("results/", scens1$dat, "_OM14", "_EM1")


scens2 <- scens
scens2$em_dir <- "models/EM2"
scens2$scenarios <- paste0("results/", scens2$dat, "_OM14", "_EM2")

scens3 <- scens
scens3$em_dir <- "models/EM3"
scens3$scenarios <- paste0("results/", scens1$dat, "_OM14", "_EM3")

scens4 <- scens
scens4$em_dir <- "models/EM4"
scens4$scenarios <- paste0("results/", scens1$dat, "_OM14", "_EM4")

scens <- rbind(scens1, scens2, scens3, scens4)

scens$bias_adjust <- NULL


df[, "scenarios"] <- c(
  c("results/D2_OM3_EM3_test")
)

# # 
# # #----Specify the OM runs
df$om_dir <- "models/OM3_both"
#
df$em_dir <- c("models/EM3_both")
# # 
#  # df$em_dir <- c("models/EM1_tvg", "models/EM2_tvs",
#  #                "models/EM3_both")
# 
# #Just running one at a time
# # iterations <- 1:4
# 
df[, "ce.par_phase"] <- rep(c(1), each = 1)

scens$bias_adjust <- FALSE
scens$ce.par_phase <- 1

scens <- scens %>% select(names(df), cf.ses.1)

# save(scens, file  = "scens.Rdata")





