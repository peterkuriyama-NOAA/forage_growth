#----------------------------------------------------------------------------
#Develop forage fish OM for NSAW project

#----------------------------------------------------------------------------
#Startup
# devtools::install_github("ss3sim/ss3models")
# library("ss3models")

options(max.print = 1000, device = 'windows')
library(plyr)
library(reshape2)
library(tidyverse)
library(r4ss)
# library(ggsidekick)
library(devtools)
library(doParallel)

# library(ggridges)
# library(scales)
options(dplyr.summarise.inform = FALSE)
# library(patchwork)
library(cpsassessment)


# pak::pkg_install("seananderson/ggsidekick")
# pak::pkg_install("peterkuriyama/cpsassessment")
# pak::pkg_install("r4ss/r4ss")
# # devtools::install_github("https://github.com/r4ss/r4ss") 
# pak::pkg_install("ss3sim/ss3sim")
# pak::pkg_install("thomasp85/patchwork")

library(ss3sim)

#Local computer
# setwd("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/")


ncores <- detectCores()
#FRD Scientist server 2
if(ncores > 50) {
  setwd("C:/Users/FRDScientist/Peter/forage_growth/")
  source("forage_growth_functions.R")
}

#My laptop
if(ncores < 50) {
  setwd("Y:/My Drive/forage_growth/")
  source("github/forage_growth/forage_growth_functions.R")
}




#----------------------------------------------------------------------
#Can Skip this part, Plot uncorrected Menhaden age-length data
#----------------------------------------------------------------------

men <- read.csv("data/menhaden_uncorrected_middle_length.csv")
men <- men %>% melt(id.var = "Year")
men$age <- as.numeric(gsub("X", "", men$variable))

mins <- men %>% group_by(age) %>% mutate(minval = min(value), maxval = max(value), 
                                    delta = maxval-minval) 


ggplot(men, aes(x = age, y = value / 10)) + geom_point() + ylab("FL (cm)") +
  ylim(c(0, 50)) + 
  theme_sleek()

#Corrected data
biascorr <- read.csv("data/menhaden_biascorrected_oct15_length.csv")
biascorr <- biascorr %>% melt(id.var = "Year") %>% 
  mutate(age = as.numeric(gsub("X", "", variable)))
biascorr %>% group_by(age) %>% mutate(minval = min(value), maxval = max(value), 
                                      delta = maxval-minval) 

biascorr %>% ggplot(aes(x = age, y = value / 10)) + 
  geom_point() + ylab("FL (cm)") +
  ylim(c(0, 50)) + 
  theme_sleek()
ggsave("figs/menhaden_biascorrected_oct15_length.jpg")

#Can have variability of up to 10cm 
#----------------------------------------------------------------------

#Functions to pull selectivity parameters and growth estimates
# pull_ageselex <- function(input_list, ages = 0:10){
#   temp <- lapply(input_list, FUN = function(xx){
#     tt <- xx$ageselex %>% filter(Factor == "Asel") %>% 
#       select(Fleet, Yr, Seas, as.character(ages) )
#     tt <- tt %>% melt(id.var = c("Fleet", "Yr", "Seas"))
#     tt$age <- as.numeric(as.character(tt$variable))
#     tt <- tt %>% select(Fleet, Yr, Seas, age, value)
#     return(tt)
#   })
#   temp <- ldply(temp)
#   temp$model <- temp[, 1]
#   temp <- temp %>% select(Yr, Fleet, Seas, age, value, model)
#   return(temp)
# }
# 
# pull_lenselex <- function(input_list){
#   temp <- lapply(input_list, FUN = function(xx){
#     tt <- xx$sizeselex %>% filter(Factor == "Lsel") %>% 
#       select(-Factor, -Sex, -Label)
#     tt <- tt %>% melt(id.var = c("Fleet", "Yr"))
#     tt$len <- as.numeric(as.character(tt$variable))
#     tt <- tt %>% select(Fleet, Yr, len, value)
#     return(tt)
#   })
#   temp <- ldply(temp)
#   temp$model <- temp[, 1]
#   temp <- temp %>% select(Yr, Fleet, len, value, model)
#   return(temp)
# }
# 
# pull_growthseries <- function(input_list, ages = 0:10){
#   temp <- lapply(input_list, FUN = function(xx){
#     tt <- xx$growthseries %>%
#       select(Yr, Seas, as.character(ages) )
#     tt <- tt %>% melt(id.var = c("Yr", "Seas"))
#     tt$age <- as.numeric(as.character(tt$variable))
#     tt <- tt %>% select(Yr, Seas, age, value)
#     return(tt)
#   })
#   temp <- ldply(temp)
#   temp$model <- temp[, 1]
#   temp <- temp %>% select(Yr, Seas, age, value, model)
#   return(temp)
# }
# 
# 
# calc_re <- function(res, colname){ #Must have model column with file path
#   # temp <- ldply(strsplit(res$model, split = "/"))
#   # res$folder <- paste(temp$V1, temp$V2, sep = "/")
#   # res$iter <- temp$V3
#   # res$mod <- temp$V4
#   
#   res <- res[, c("Yr", colname, "model", "scenario", "iter", "mod")]
#   
#   omres <- res %>% filter(mod == "om") 
#   emres <- res %>% filter(mod == "em")
#   
#   if(length(colname) > 1) colname <- colname[which(colname != 'age')]
#   # colname <- 
#   # colname <- colname %>% fi
#   omres$om <- omres[, colname]
#   emres$em <- emres[, colname]
#   
#   omres <- omres[, -c(which(names(omres) %in% c(colname, 'mod')) )]
#   emres <- emres[, -c(which(names(emres) %in% c(colname, 'mod')) )]
#   
#   calc_res <- omres %>% left_join(emres)
#   calc_res <- calc_res %>% mutate(re = round(100 * (em - om) / om, digits = 3))
#   calc_res$value <- colname
#   return(calc_res)  
# }

#----------------------------------------------------------------------
#Specify results directory

#----------------------------------------------------------------------
#Run ss3sim example

 # load_all("../ss3sim")
# library(ss3sim)

# load_all("../r4ss")
# library(r4ss)


#Three OMs:
#1. Time-varying growth, no time-varying selectivity
#2. Time-invariatn growth, time-varying selectivity
#3. Time-varying growth and selectivity

#Four EMs:
#1. Time-invariant growth and Time-invariant selectivity
#2. TV growth, invariant selectivity
#3. Invariant growth; time-varying selectivity
#4. Time-varying growth; time-varying selectivity

#999
#----------------------------------------------------------------------
# ss3sim_base()
# system.file("extdata/models", package = "ss3sim")

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

#------------------------------------------------------------------
# Specify OM and EMs for models

scens <- rbind(D0, D1, D2, D3)
scens$om_dir <- "models/OM3_both"

####
scens1 <- scens 
scens1$em_dir <- "models/EM1_tvg"
scens1$scenarios <- paste0("results/", scens1$dat, "_OM3", "_EM1")


scens2 <- scens
scens2$em_dir <- "models/EM2_tvs"
scens2$scenarios <- paste0("results/", scens2$dat, "_OM3", "_EM2")

scens3 <- scens
scens3$em_dir <- "models/EM3_both"
scens3$scenarios <- paste0("results/", scens1$dat, "_OM3", "_EM3")

scens <- rbind(scens1, scens2, scens3)

scens$bias_adjust <- NULL

iterations <- 5:12


# 
# # 
# # #
# # df <- D2
# # 
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
#  
# df <- df[rep(1, 3), ]


#------------------------------------------------------------------
#Add in recdev pattern

# Set the phase for estimating natural mortality and Q
# df[, "ce.par_phase"] <- rep(c(1), each = 1)

# df <- df[rep(1, 3), ]
# 
# # Name the scenarios
# df[, "scenarios"] <- c(
#   c("results/D1_OM3_EM1", "results/D1_OM3_EM2",
#     "results/D1_OM3_EM3")
# )

# scens


scens$bias_adjust <- FALSE
scens$ce.par_phase <- 1
scens <- scens %>% select(names(df), cf.ses.1)

#----------------Run the models

scens <- scens[1,]

#For debugging
# load_all("ss3sim")
# load_all("r4ss")
start_time <- Sys.time()
iterations <- 1:48

ncores <- 48
cl <- makeCluster(ncores)
registerDoParallel(cl)

scname <- run_ss3sim(iterations = iterations, simdf = scens, parallel = T,
                     parallel_iterations = TRUE)

# scname <- run_ss3sim(iterations = iterations, simdf = scens, parallel = F,
#                      parallel_iterations = F)

# scname <- run_ss3sim(iterations = iterations, simdf = scens[-2, ], parallel = T,
#                       parallel_iterations = TRUE)
stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time)
# scname <- run_ss3sim(iterations = 1, simdf = df[1, ])

#1.6 hours

 # unlink(scname[1], recursive = T)
#


#------------------------------------------------------
#Read in all results in parallel
# folds <- c("results/OM1_EM1")
folds <- scens$scenarios
# folds <- c("results/OM2_EM2")
iters <- 1:12 #iterations
mods <- c("om", "em")

flz <- expand_grid(folds, iters, mods) %>% mutate(unq = paste(folds,
                                                              iters, mods, sep = '/')) %>%
  pull(unq)

#------------------------------------------------------
###Read in results in parallel
start_time <- Sys.time()

ncores <- 4
cl <- makeCluster(ncores)
registerDoParallel(cl)

reslist <- foreach::foreach(ii = flz, .packages = 'r4ss') %dopar%
  SS_output(ii, printstats = F, covar = F)
stopCluster(cl)

end_time <- Sys.time() - start_time
names(reslist) <- flz



modnames <- data.frame(model = flz)
mm <- strsplit(modnames$model, split = "/") %>% ldply
modnames$scenario <- mm$V2
modnames$iter <- mm$V3
modnames$mod <- mm$V4


#------------------------------------------------------
calc_re <- function(res, colname){ #Must have model column with file path
  
  # browser()
  
  
  mm <- strsplit(res$model, split = "/") %>% ldply
  res$scen <- mm$V2
  res$iter <- mm$V3
  res$mod <- mm$V4
  
  # temp <- ldply(strsplit(res$model, split = "/"))
  # res$folder <- paste(temp$V1, temp$V2, sep = "/")
  # res$iter <- temp$V3
  # res$mod <- temp$V4
  
  res <- res[, c("Yr", colname, "model", "scen", "iter", "mod")]
  
  # res %>% dcast(Yr + model + scen + iter ~ mod, value.var  = colname) %>% filter(Yr == 12)
  
  
  omres <- res %>% filter(mod == "om")
  emres <- res %>% filter(mod == "em")
  # 
  if(length(colname) > 1) colname <- colname[which(colname != 'age')]
  # 
  # # colname <- 
  # # colname <- colname %>% fi
  omres$om <- omres[, colname]
  emres$em <- emres[, colname]
  
  omres <- omres %>% select(Yr, scen, iter, om)
  emres <- emres %>% select(Yr, scen, iter, em)
  
  # emres %>% select(-model, -mod) %>% left_join(omres, by = c("Yr", "scen", "iter"))
  
  calc_res <- emres %>% left_join(omres)
  
  # 
  # omres <- omres[, -c(which(names(omres) %in% c(colname, 'mod')) )]
  # emres <- emres[, -c(which(names(emres) %in% c(colname, 'mod')) )]
  # 
  # calc_res <- omres %>% left_join(emres)
  # 
  # calc_res <- res %>% dcast(Yr + model + scen + iter ~ mod, value.var = colname)
  
  
  calc_res <- calc_res %>% mutate(re = round(100 * (em - om) / om, digits = 3))
  calc_res$value <- colname
# browser()
  
  ss <- strsplit(calc_res$scen, split = "_") %>% ldply
  calc_res$datscen <- ss$V1
  calc_res$opmod <- ss$V2
  calc_res$estmod <- ss$V3
  
  return(calc_res)  
}


###Pull relevant things
tsres <- pull_timeseries(reslist)
tsgrowth <- pull_growthseries(reslist)


####Summary biomass
tsRE <- calc_re(tsres, colname = "Bio_smry")

###Add in descriptions for the facets
d1 <- tsRE %>% distinct(datscen) %>% mutate(dd = c("D0_high", "D1_noCAAL", "D2_Index_every_other",
                                             "D3_fewer_ages"))
tsRE <- tsRE %>% left_join(d1)

e1 <- tsRE %>% distinct(estmod) %>% mutate(ee = c("EM1_tvSel", "EM2_tvGrowth", "EM3_tvSel_tvGrowth"))
tsRE <- tsRE %>% left_join(e1)

# tsRE %>% ggplot(aes(x = re)) + geom_histogram() + facet_grid(dd ~ ee)


tsRE %>% group_by(scen, datscen, opmod, estmod, dd, ee)


sumRE <- tsRE %>% group_by(scen, datscen, opmod, estmod, dd, ee) %>%
  mutate(mare = abs(median(re))) %>% ungroup %>% group_by(scen, Yr, datscen, opmod, estmod, dd, ee) %>% 
  summarize(lo = quantile(re, .05), med = median(re), hi = quantile(re, .95), mare = mare)


sumRE <- sumRE %>% group_by(scen, datscen, opmod, estmod, dd, ee) %>%
  mutate(mare = abs(median(re)))



tsRE %>% filter(Yr <= 59) %>% ggplot(aes(x = Yr, y = re )) + 
  geom_line(alpha = .5, aes(group =  iter)) + facet_grid(dd ~ ee, scales = "free_y") + 
  xlab("Year") + geom_hline(aes(yintercept = 0)) +
  # ylim(c(-50, 50)) +
  ylab("Relative Error Stock Biomass (age-1+)") +
  geom_line(data = sumRE %>% filter(Yr <= 59), 
  aes(x = Yr, y = med), col = 'red', size = 1) + theme_sleek()

ggsave(width = 7, height = 7, file = "figs/prelim_re_12iters.png")



sumRE %>% ggplot(aes(x = Yr)) + geom_line(aes(y = med), col = 'red') +
  geom_line(aes(y = lo), col = 'black', lty = 2) + 
  geom_line(aes(y = hi), col = 'black', lty = 2) + 
  facet_grid(datscen ~ estmod, scales = 'free_y') + theme_sleek()

tsRE %>% 

#------------------------------------------------------
#Example selectivity plots





#------------------------------------------------------
#Selectivities
tsselex <-  pull_ageselex(reslist)
tt <- ldply(strsplit(tsselex$model, split = '/') ) 
tsselex$scenario <- tt$V2
tsselex$iter <- tt$V3
tsselex$model <- tt$V4

tsselex %>% filter(Fleet == 1, Seas == 1, Yr == 10)

tsselex <- tsselex %>% select(-Seas) %>%  
  dcast(Yr + Fleet + age + scenario + iter ~ model, value.var = 'value')

ts1 <- tsselex %>% filter(is.na(em) == FALSE, is.na(om) == FALSE)
ts1$re <- (ts1$em - ts1$om) / ts1$om

ts1 %>% filter(Yr == 11) %>% arrange(desc(re))

ts1 %>% filter(Yr == 11) %>%
  ggplot(aes(x = age, y = re, group = iter)) + geom_point() + geom_line()



ts1 %>% filter(Yr == 11) %>% ggplot(aes(x = age)) + geom_line(aes(y = em)) + 
  geom_line(aes(y = om), col = 'red')



tsselex %>% filter(Yr == 3)


#------------------------------------------------------
tsRE <- calc_re(tsres, colname = "Bio_smry")


# tsRE %>% filter(Yr >= 11) %>% group_by(Yr) %>% mutate(mean_re = mean(re)) %>% ggplot(aes(x = Yr)) + 
#   geom_line(aes(y = re, group = iter)) + geom_line(aes(y = (mean_re)), lty = 2)






tsRE %>% filter(Yr <= 60) %>% group_by(folder, Yr, value) %>% summarize(p5 = quantile(re, .05),
                                                                        p95 = quantile(re, .95)) %>%
  ggplot(aes(x = Yr, y = p5, group = folder, color = folder)) + geom_line()

# ggplot(tsres, aes(x = Yr, y = Bio_smry, group = model, color = model)) + geom_point() + 
  # geom_line()


# tsgrowth %>% slice(grep("D0-E0-F0-forage22_tvG_narrowS/2", model)) %>% 
#   filter(Yr < 10) %>%
#   ggplot(aes(x = age, y = value, color = model)) + geom_line(aes(group = Yr)) +
#     facet_wrap(~ Yr)
# 
# tsgrowth %>% filter(
#                    model == "D0-E0-F0-forage22_tvG_narrowS/2") %>% 
#   ggplot(aes(x = age, y = value, color = model)) + geom_line(aes(group = Yr))
# 



###Calculate relative error of each metric; need to match OM and EM results
# res <- tsres
# colname <- "Bio_smry"

# res <- tsgrowth
# colname <- c('age',"value")


####Compare recruitment deviations
recdevs <- SSsummarize(reslist)

recdevs$pars

recdevs <- recdevs$recdevs %>% melt(id.var = c("Yr", "Label"))
recdevs$variable <- as.character(recdevs$variable)

rr <- ldply(strsplit(recdevs$variable, split = "/"))
recdevs$modrun <- rr$V1
recdevs$iter <- rr$V2
recdevs$mod <- rr$V3

recdevs %>% filter(iter == 1) %>% dcast(Label + iter ~ mod, value.var = 'value') %>%
  ggplot(aes(x = om, y = em)) + geom_point()


recdevs %>% ggplot(aes(x = Yr, y = value, group = mod, color = mod)) + geom_point() +
  geom_line() + facet_wrap(~ iter)







####Summary biomass
growthRE <- calc_re(tsgrowth, colname = c('age', 'value'))

#Average growth RE
growthRE %>% group_by(Yr, age, folder) %>% summarize(p5 = quantile(re, p = .05),
                                                     med = median(re), p95 = quantile(re, .95)) %>%
  ggplot(aes(x = age, y = med)) + geom_point() + geom_line()




#######Identify source of bias

#Compare growth estimates
growths <- pull_growthseries(reslist)

growths %>% filter(Yr %in% c(25:30)) %>% ggplot(aes(x = age, y = value, group = model,
                                                    color = model)) + geom_point() +
  geom_line() + facet_wrap(~ Yr)

#Compare selectivity
aselex <- pull_ageselex(reslist)

ss <- ldply(strsplit(aselex$model, split = "/"))
aselex$modrun <- ss$V1
aselex$iter <- ss$V2
aselex$mod <- ss$V3

aselex1 <- aselex %>% dcast( Yr + Fleet + Seas + age + iter ~ mod, value.var = "value")


aselex %>% filter(Yr %in% c(25:30), Fleet == 1) %>%
  ggplot(aes(x = age, y = value, group = mod, color = mod)) + 
  geom_point() + geom_line() + facet_wrap(~Yr)

#compare selectivity parameters
reslist[[1]] %>% head

em1 <- reslist[[2]]
em2 <- reslist[[4]]

comp <- SSsummarize(reslist[1:2])

comp$pars %>% write.csv("model22_pars.csv")



# foreach::foreach(
#   it_ = iterations, .packages = "ss3sim",
#   .verbose = TRUE
# ) %dopar%
#   # do.call("ss3sim_base", c(x, list(iterations = it_), ...))
#   do.call("ss3sim_base", c(x, list(iterations = it_), dots))
# })

# scname <- run_ss3sim(iterations = iterations, simdf = df, parallel = T,
#                      parallel_iterations = TRUE)




















#------------------------------------------------------
#Check sampled data in run 7
# omres <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/om", covar = FALSE)
# emres <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/em", covar = FALSE)
# emres1 <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/em_fixlselex", covar = FALSE)

omres <- SS_output("D0-E0-F0-forage19/1/om", covar = FALSE)
emres <- SS_output("D0-E0-F0-forage19/1/em", covar = FALSE)

# omres <- SS_output("D0-E0-F0-forage20/2/om", covar = FALSE)
# emres <- SS_output("D0-E0-F0-forage20/2/em", covar = FALSE)
# SS_plots(emres)
# emres <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/em", covar = FALSE)
# emres1 <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/em_fixlselex", covar = FALSE)

reslist <- list(omres = omres, emres = emres)

tts <- pull_timeseries(reslist)

#Add in index observations
tts %>% ggplot(aes(x = Yr, y = Bio_smry)) + geom_point(aes(group = model, color = model))+ 
  geom_line(aes(group = model, color = model)) + geom_line(data = emres$cpue, aes(x = Yr, y = Obs))

#Look at the timeseries of biomass observations
#50-53 years something going on
omvals <- tts %>% filter(model == 'omres') %>% select(Yr, Bio_smry) %>%
  mutate(omval = Bio_smry) %>% select(-Bio_smry)


tts <- tts %>% left_join(omvals, by = "Yr")
tts$re <- 100 *((tts$Bio_smry - tts$omval) / tts$omval)
tts$state <- "high"
tts[which(tts$Bio_smry <= 150000), 'state'] <- "low"


tts %>% filter(model != "omres") %>% ggplot(aes(x = Yr, y = re, group = model, color = model)) +
  geom_point(aes(shape = state, size = state)) + geom_line() + geom_hline(yintercept = 0, lty = 2)


#######Identify source of bias

#Compare growth estimates
growths <- pull_growthseries(reslist)

growths %>% filter(Yr %in% c(25:30)) %>% ggplot(aes(x = age, y = value, group = model,
                                            color = model)) + geom_point() +
  geom_line() + facet_wrap(~ Yr)

#Compare selectivity
aselex <- pull_ageselex(reslist)

ss <- ldply(strsplit(aselex$model, split = "/"))
aselex$modrun <- ss$V1
aselex$iter <- ss$V2
aselex$mod <- ss$V3

aselex1 <- aselex %>% dcast( Yr + Fleet + Seas + age + iter ~ mod, value.var = "value")


aselex %>% filter(Yr %in% c(25:30), Fleet == 1) %>%
  ggplot(aes(x = age, y = value, group = mod, color = mod)) + 
  geom_point() + geom_line() + facet_wrap(~Yr)


#Compare the OM and EM selectivities
aselex %>% filter(Yr %in% c(25:30), Fleet == )

#compare selectivity parameters
reslist[[1]] %>% head

em1 <- reslist[[2]]
em2 <- reslist[[4]]

comp <- SSsummarize(reslist[1:2])

comp$pars %>% write.csv("model22_pars.csv")

#--------------------------------------------------------------------------
#2. Evaluate estimability with only TV selectivity
#--------------------------------------------------------------------------

#Develop alternative OM and EM models (#14)

#Define the ss3sim settings
df <- setup_scenarios_defaults(nscenarios = 1)

#Specify specifics for the short 60 year model
df$cf.years.1 <- "11:60"
#Add in hat F pattern 
df$cf.fvals.1 <- "c(seq(.02, 1, length = 25), rev(seq(.02, .6, length = 25)))"

#Add in hat F pattern 
# length(11:60) 


# Turn off bias adjustment and use default settings in cod EM model
df[, "bias_adjust"] <- FALSE
df[, grep("^cf//.", colnames(df))]
df[, grep("^s[al]//.", colnames(df))]

# Survey sampling
df[, "si.years.2"] <- "seq(1, 60, by = 1)"

# Set sd of observation error for each scenario
#Observation error will be high when biomass is low and low when biomass is higher
df[, "si.sds_obs.2"] <- "rep(.05, 60)" 
# df[, "si.sds_obs.2"] <- "c(rep(0.05, 30), rep(0.05, 12), rep(0.05, 8))" 

#Estimate natural mortality
df[, "ce.par_name"] <- "NatM_uniform_Fem_GP_1"
df[, "ce.par_int"] <- NA

#Modify land agecomp years

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

# Set the phase for estimating natural mortality and Q
df[, "ce.par_phase"] <- rep(c(1), each = 1)
df <- df[rep(1, 4), ]

# Name the scenarios
df[, "scenarios"] <- c(
  "D0-E0-F0-forage14"
)

#----Specify the OM runs
fil  <- "14_consgrowth_tvselex/"
df$om_dir <- paste0(fil, "om")
df$em_dir <- paste0(fil, c("em_tvselex_consgrowth"))

iterations <- 1
df <- df[1, ]

##Run the models

# scname <- run_ss3sim(iterations = iterations, simdf = df)

# load_all("../ss3sim")

scname <- run_ss3sim(iterations = iterations, simdf = df)

# unlink(scname[1], recursive = T)

omres <- SS_output("D0-E0-F0-forage14/1/om", covar = FALSE)
emres <- SS_output("D0-E0-F0-forage14/1/em", covar = FALSE)

reslist <- list(omres = omres, emres = emres)

tts <- pull_timeseries(reslist)

#Add in index observations
tts %>% ggplot(aes(x = Yr, y = Bio_smry)) + geom_point(aes(group = model, color = model))+ 
  geom_line(aes(group = model, color = model)) + geom_line(data = emres$cpue, aes(x = Yr, y = Obs))

#Look at the timeseries of biomass observations
#50-53 years something going on
omvals <- tts %>% filter(model == 'omres') %>% select(Yr, Bio_smry) %>%
  mutate(omval = Bio_smry) %>% select(-Bio_smry)


tts <- tts %>% left_join(omvals, by = "Yr")
tts$re <- 100 *((tts$Bio_smry - tts$omval) / tts$omval)
tts$state <- "high"
tts[which(tts$Bio_smry <= 150000), 'state'] <- "low"


tts %>% filter(model != "omres") %>% ggplot(aes(x = Yr, y = re, group = model, color = model)) +
  geom_point(aes(shape = state, size = state)) + geom_line() + geom_hline(yintercept = 0, lty = 2)


growths <- pull_growthseries(reslist)

growths %>% filter(Yr == 42) %>% ggplot(aes(x = age, y = value, group = model,
                                            color = model)) + geom_point() +
  geom_line()

#Compare selectivity
aselex <- pull_ageselex(reslist)
aselex %>% filter(Yr == 49, Fleet == 1) %>%
  ggplot(aes(x = age, y = value, group = model, color = model )) + 
  geom_point() + geom_line()


#--------------------------------------------------------------------------
#3. Evaluate estimability time-invariant everything
#--------------------------------------------------------------------------

#Develop alternative OM and EM models (#14)

#Define the ss3sim settings
df <- setup_scenarios_defaults(nscenarios = 1)

#Specify specifics for the short 60 year model
df$cf.years.1 <- "11:60"
#Add in hat F pattern 
df$cf.fvals.1 <- "c(seq(.02, 1, length = 25), rev(seq(.02, .6, length = 25)))"

#Add in hat F pattern 
# length(11:60) 


# Turn off bias adjustment and use default settings in cod EM model
df[, "bias_adjust"] <- FALSE
df[, grep("^cf//.", colnames(df))]
df[, grep("^s[al]//.", colnames(df))]

# Survey sampling
df[, "si.years.2"] <- "seq(1, 60, by = 1)"

# Set sd of observation error for each scenario
#Observation error will be high when biomass is low and low when biomass is higher
df[, "si.sds_obs.2"] <- "rep(.05, 60)" 
# df[, "si.sds_obs.2"] <- "c(rep(0.05, 30), rep(0.05, 12), rep(0.05, 8))" 

#Estimate natural mortality
df[, "ce.par_name"] <- "NatM_uniform_Fem_GP_1"
df[, "ce.par_int"] <- NA

#Modify land agecomp years

#Years for sampling of length comps for fleet (1) and survey (2)
yy <- "10:60"
df$sl.years.1 <- yy
df$sl.years.2 <- yy

df$sa.years.1 <- yy
df$sa.years.2 <- yy

# df$sc.years.2 <- yy

df$sl.Nsamp.1 <- "100"
df$sl.Nsamp.2 <- "100"

df$sa.Nsamp.1 <- "100"
df$sa.Nsamp.2 <- "100"
# df$sc.Nsamp_lengths.2 <- "100"
# df$sc.Nsamp_ages.2 <- "75"

# Set the phase for estimating natural mortality and Q
df[, "ce.par_phase"] <- rep(c(1), each = 1)
df <- df[rep(1, 4), ]

# Name the scenarios
df[, "scenarios"] <- c(
  "D0-E0-F0-forage17"
)

#----Specify the OM runs
fil  <- "17_remove_lselex/"
df$om_dir <- paste0(fil, "om")
df$em_dir <- paste0(fil, c("em"))

iterations <- 1
df <- df[1, ]

##Run the models

# scname <- run_ss3sim(iterations = iterations, simdf = df)

load_all("../ss3sim")

scname <- run_ss3sim(iterations = iterations, simdf = df)
# stopCluster(cl)
# unlink(scname[1], recursive = T)

#-----------------------------
omres <- SS_output("D0-E0-F0-forage16/1/om", covar = FALSE)
emres <- SS_output("D0-E0-F0-forage16/1/em", covar = FALSE)
emres1 <- SS_output("D0-E0-F0-forage16/1/em1", covar = FALSE)
emres2 <- SS_output("D0-E0-F0-forage16/1/em2_fixselex", covar = FALSE)
# SS_plots(emres2)

omres <- SS_output("D0-E0-F0-forage17/1/om", covar = FALSE)
emres <- SS_output("D0-E0-F0-forage17/1/em", covar = FALSE)
emres1 <- SS_output("D0-E0-F0-forage17/1/em_fromEVs", covar = FALSE)
emres2 <- SS_output("D0-E0-F0-forage17/1/em_fixselex", covar = FALSE)
emres3 <- SS_output("D0-E0-F0-forage17/1/em_fromEVs", covar = FALSE)
# emres2 <- SS_output("D0-E0-F0-forage16/1/em2_fixselex", covar = FALSE)
SS_plots(emres2)


emres3$likelihoods_used

emres3$cpue


emres3$agedbase%>% select(Like) %>% range
emres3$lendbase %>% select(Like) %>% range

#-----------------------------
reslist <- list(omres = omres, emres = emres, emres1 = emres1, emres2 = emres2)

#Look at gradients associated with emres2

summs <- SSsummarize(reslist)

summs$pars %>% slice(grep("RecrDev", Label)) %>% select(-Label, -recdev) %>% 
  melt(id.var = ("Yr")) %>% 
  ggplot(aes(x = Yr, y = value, group = variable, color = variable)) + 
    geom_point() + geom_line()


tts <- pull_timeseries(reslist)



#Add in index observations
tts %>% ggplot(aes(x = Yr, y = Bio_smry)) + geom_point(aes(group = model, color = model))+ 
  geom_line(aes(group = model, color = model)) + geom_line(data = emres$cpue, aes(x = Yr, y = Obs))

#Look at the timeseries of biomass observations
#50-53 years something going on
omvals <- tts %>% filter(model == 'omres') %>% select(Yr, Bio_smry) %>%
  mutate(omval = Bio_smry) %>% select(-Bio_smry)

tts <- tts %>% left_join(omvals, by = "Yr")
tts$re <- 100 *((tts$Bio_smry - tts$omval) / tts$omval)
tts$state <- "high"
tts[which(tts$Bio_smry <= 150000), 'state'] <- "low"


tts %>% filter(model != "omres") %>% ggplot(aes(x = Yr, y = re, group = model, color = model)) +
  geom_point(aes(shape = state, size = state)) + geom_line() + geom_hline(yintercept = 0, lty = 2)


growths <- pull_growthseries(reslist)

growths %>% filter(Yr == 5) %>% ggplot(aes(x = age, y = value, group = model,
                                            color = model)) + geom_point() +
  geom_line()

#Compare selectivity
aselex <- pull_ageselex(reslist)


aselex %>% filter(Yr == 1, Fleet == 1) %>%
  ggplot(aes(x = age, y = value, group = model, color = model )) + 
  geom_point() + geom_line()


#Maybe need to back out even more


#--Compare OM expected values to sampled data
omdat <- SS_readdat("D0-E0-F0-forage16/1/om/data_expval.ss")
emdat <- SS_readdat("D0-E0-F0-forage16/1/em/ss3.dat")

#---CPUE
cpue1 <- omdat$CPUE %>% mutate(model = 'om')
cpue2 <- emdat$CPUE %>% mutate(model = 'em')
  
cpue <- rbind(cpue1, cpue2)

ggplot(cpue, aes(x = year, y = obs, group = model, color = model)) + geom_point() + 
  geom_line()

#---catch
catch1 <- omdat$catch %>% mutate(model = 'om')
catch2 <- emdat$catch %>% mutate(model = 'em')

catch <- rbind(catch1, catch2)

ggplot(catch %>% filter(year != -999), aes(x = year, y = catch, group = model, color = model)) + geom_point() + 
  geom_line()


#---Length compositions
lcomp1 <- omdat$lencomp %>% select(Yr, Seas, FltSvy, Nsamp, paste0("l", 9:28)) %>%
  melt(id.var = c("Yr", "Seas", "FltSvy", "Nsamp")) %>% 
  mutate(lval = as.numeric(gsub("l", "", variable))) %>%
  select(Yr, Seas, FltSvy, Nsamp, lval, value) %>% mutate(model = 'om')

lcomp2 <- omdat$lencomp %>% select(Yr, Seas, FltSvy, Nsamp, paste0("l", 9:28)) %>%
  melt(id.var = c("Yr", "Seas", "FltSvy", "Nsamp")) %>% 
  mutate(lval = as.numeric(gsub("l", "", variable))) %>%
  select(Yr, Seas, FltSvy, Nsamp, lval, value) %>% mutate(model = 'em')

lcomp <- rbind(lcomp1, lcomp2)

lcomp %>% filter(Yr == 50, FltSvy == 1) %>% ggplot(aes(x = lval, y = value, group = model, 
                                          color = model)) + geom_point() + 
  geom_line() + facet_wrap(~ model)


#---Age compositions
acomp1 <- omdat$agecomp %>% select(Yr, Seas, FltSvy, Nsamp, paste0("a", 0:8)) %>%
  melt(id.var = c("Yr", "Seas", "FltSvy", "Nsamp")) %>% 
  mutate(aval = as.numeric(gsub("a", "", variable))) %>%
  select(Yr, Seas, FltSvy, Nsamp, aval, value) %>% mutate(model = 'om')

acomp2 <- emdat$agecomp %>% select(Yr, Seas, FltSvy, Nsamp, paste0("a", 0:8)) %>%
  melt(id.var = c("Yr", "Seas", "FltSvy", "Nsamp")) %>% 
  mutate(aval = as.numeric(gsub("a", "", variable))) %>%
  select(Yr, Seas, FltSvy, Nsamp, aval, value) %>% mutate(model = 'em')

acomp <- rbind(acomp1, acomp2)

acomp %>% filter(Yr == 20, FltSvy == 1) %>% ggplot(aes(x = aval, y = value, group = model, 
                                                       color = model)) + geom_point() + 
  geom_line() + facet_wrap(~ model, scales = 'free_y')






omdat <- SS_readdat("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/om/data_expval.ss")
emdat <- SS_readdat("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/7/em/ss3.dat")

comps <- lapply(list(omdat = omdat, emdat = emdat), FUN = function(xx){
  ll <- xx$lencomp %>% select(Yr, FltSvy, paste0("l", 9:28)) %>% 
    melt(id.var = c("Yr", "FltSvy"))
  aa <- xx$agecomp %>% select(Yr, FltSvy, paste0("a", 0:8)) %>%
    melt(id.var = c("Yr", "FltSvy"))
  out <- rbind(ll, aa)
  return(out)
})

comps <- ldply(comps)
comps$model <- comps[, 1]
lcomps <- comps[grep("l", comps$variable), ]
lcomps$lbin <- as.numeric(gsub("l", "", lcomps$variable))





caal <- dat5$agecomp %>% filter(Lbin_lo != -1) %>% select(Yr, FltSvy, Lbin_lo,
                                                  Nsamp, paste0("a", 0:8)) %>%
  melt(id.vars = c("Yr", "FltSvy", "Lbin_lo", "Nsamp")) %>%
  mutate(age = as.integer(gsub("a", "", variable)))

temp <- caal %>% filter( FltSvy == 2, value != 0)


ggplot(temp, aes(x = age, y = Lbin_lo, size = value)) + geom_point() + 
  facet_wrap(~ Yr)

omres <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/5/om", covar = F)
SS_plots(omres)


res <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal/5/em", covar = F)
SS_plots(res)
  

#------------------------------------------------------
#Self check with iteration 7
#
em <- 

selfcheck <- SS_output("D0-E0-F0-forage12_tvselex_tvgrowth_locv_caal//2//om//selfcheck")

round(selfcheck$likelihoods_used$values, digits = 3)

#--------------------------------------------------------------------
#Read in model results to compare selectivity estimations
flz <- c(paste0(df$scenarios, "/", iterations, "/", "om"),
         paste0(df$scenarios, "/", iterations, "/", "em"))



res <- lapply(flz, FUN = function(xx) SS_output(xx, printstats = FALSE, covar = FALSE))
names(res) <- flz
SS_plots(res[[2]])


#Compare selectivities
aselex <- lapply(res, FUN = function(xx){
  temp <- xx$ageselex
  temp <- temp %>% filter(Yr >= 11, Yr < 61,
                          Factor == "Asel", Fleet == 1) %>% select(Yr, as.character(0:10)) %>%
    melt(id.var = "Yr")
  temp$age <- as.numeric(as.character(temp$variable))
  temp <- temp %>% select(Yr, age, value)
  return(temp)
  } 
)


aselex <- ldply(aselex)
scenvals <- ldply(strsplit(aselex[, 1], split = "/"))
aselex$scen <- scenvals$V1
aselex$iter <- scenvals$V2
aselex$mod <- scenvals$V3

aselex %>% filter(Yr %in% c(15:20), iter == 7) %>% 
  ggplot(aes(x = age, y = value, group = mod, color = mod)) + geom_point() + 
  geom_line() + facet_wrap(~ Yr)



cbind(aselex, ldply(strsplit(aselex[, 1], split = "/")) %>% head


get_results_all(
  overwrite_files = TRUE,
  user_scenarios = c(scname)
)

tsvals <- read.csv("ss3sim_ts.csv")

#Read just one scenario results

#Modify the time series values to see relative error in biomass time series
biores <- tsvals %>% select(Bio_smry, year, model_run, iteration) %>%
  dcast(year + iteration  ~ model_run, value.var = "Bio_smry") %>% 
  filter(is.na(em) == FALSE) %>% mutate(re = round((em - om) / om, digits = 3))

p1 <- biores %>% 
  ggplot(aes(x = year, y = re, group = iteration)) +  geom_line() +
  theme_sleek() + geom_hline(yintercept = 0, linetype = 2) + xlab("Year") + ylab("Relative error")
p1


#####

tt <- tibble(scenario = unique(tsvals$scenario), emtype = c("TV selex; TV growth", "Const selex; TV growth", 
                                                      "TV selex; Const growth","Const selex; const growth"))
tsvals <- tsvals %>% left_join(tt)

#Modify the time series values to see relative error in biomass time series
biores <- tsvals %>% select(Bio_smry, year, model_run, iteration, emtype) %>%
  dcast(year + iteration + emtype ~ model_run, value.var = "Bio_smry") %>% 
  filter(is.na(em) == FALSE) %>% mutate(re = round((em - om) / om, digits = 3))



p1 <- biores %>% 
  ggplot(aes(x = year, y = re, group = iteration)) + facet_wrap(~ emtype) + geom_line() +
  theme_sleek() + geom_hline(yintercept = 0, linetype = 2) + xlab("Year") + ylab("Relative error")
p1

ggsave("../figs/5run_RE.png", width = 6, height = 3.5)

 
ombio <- tsvals %>% filter(model_run == "om")
p2 <- ombio %>% filter(scenario == "D0-E0-F0-forage11_tvselex_tvgrowth") %>% ggplot(aes(x = year, y = Bio_smry, group = iteration)) + geom_line() +
  xlab("Year") + ylab("OM summary biomass") + theme_sleek()
p2
ggsave("../figs/5run_OMbio.png", width = 6, height = 3.5)

tvals %>% filter(model_run == 'om', scenario == "D0-E0-F0-forage11_tvselex_tvgrowth") %>% 
  
  distinct(iteration)


tsvals %>% group_by()


#-------------------------
#Plot some selectivities
exampleom <- SS_output('D0-E0-F0-forage11_cselex_cgrowth/1/om')


SS_output()
flz <- paste0(scname, "/", 1:5, "/")


lapply(scname)












#-------------------------
#Compare ss3sim runs
# SS_output("D0-E0-F0-forage/1/om")

# scname <- "D0-E0-F0-forage7"

# r_om <- r4ss::SS_output(file.path(scname[1], "1", "om"),
#                         verbose = FALSE, printstats = FALSE, covar = FALSE
# )
# 
# 
# r_em <- r4ss::SS_output(file.path(scname[1], "1", "em"),
#                         verbose = FALSE, printstats = FALSE, covar = FALSE
# )
# em1 <- SS_output("../tester_em")
# SS_plots(r_em)
# res <- list(om = r_om, em = r_em)



#-------------------------
#Compare growths
pull_growths <- lapply(res, FUN = function(xx) {
  temp <- xx$growthseries %>% select(Yr, as.character(0:10)) %>% melt(id.var = "Yr") %>%
    mutate(age = as.numeric(as.character(variable))) %>% select(-variable)
  return(temp)
})
names(pull_growths) <- names(res)
pull_growths <- ldply(pull_growths)
pull_growths$model <- pull_growths[, 1]

pull_growths %>% filter(Yr %in% c(20:30), model == 'om') %>% 
  ggplot( aes(x = age, y = value, group= model, color = model)) + geom_point() + 
  geom_line() + facet_wrap(~ Yr)

pull_growths %>% filter(model == "om")



#-------------------------
#Look at time series of summary biomass
tsb <- pull_timeseries(res)
tsb$model <- tsb[, 1]
tsb %>% ggplot(aes(x = Yr, y = Bio_smry, color = model, group = model)) + geom_point() + geom_line()

#-------------------------
res <- list(om = exampleom)
#Age selectivities
aselex <- lapply(res, FUN = function(xx){
  temp <- xx$ageselex
  temp <- temp %>% filter(Factor == "Asel") %>% select(Fleet, Yr, as.character(0:10)) %>%
    melt(id.var = c("Yr", "Fleet"))
  temp$age <- as.numeric(as.character(temp$variable))  
  temp <- temp %>% filter(Yr >= 25)
  return(temp)
})
names(aselex) <- names(res)
aselex <- ldply(aselex)
aselex$model <- aselex[, 1]

aselex %>% filter(model == "om", Yr %in% c(40:45))  %>%
  ggplot(aes(x = age, y = value, group = Yr)) + geom_line() + geom_point() + 
  facet_wrap(~ Yr) + theme_sleek() + xlab("Age") + ylab("Selectivity") 
ggsave("../figs/omselex.png", width = 5.5, height = 5)



aselex %>% filter(Fleet == 1, model == "om") %>% ggplot(aes(x = age, y = value, group = Yr)) + 
  geom_point() +
  geom_line()

aselex %>% filter(age == 1) %>% 
  ggplot(aes(x = Yr, y = value, group = model, color = model)) + geom_point() +
  geom_line()

aselex %>% filter(Yr %in% c(40:50), Fleet == 1) %>% ggplot(aes(x = age, y = value, group = model, color = 
                                                     model)) +
  geom_point() + geom_line() + facet_wrap(~Yr)

#Need to add in more variability in selex



# (r_em)


  
  
  
  
  
  
  
#------------------------------------------------------------------------------------
#Add in tv parameters manually to 4_fisheryselex runs

fisheryages <- eval(parse(text =df$sa.years.1))
# fisheryages <- 11:60

#age0, sd = 1

devs <- lapply(0:5, FUN = function(xx){
  temp <- data.frame(year = fisheryages, variable = 1,
                     age = xx )
})

devs <- ldply(devs)
devs$value <- 999
set.seed(123)
devs[which(devs$age == 0), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = 1) 
devs[which(devs$age == 1), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = .5) 
devs[which(devs$age == 2), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = .5) 
devs[which(devs$age == 3), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = .3) 
devs[which(devs$age == 4), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = .1) 
devs[which(devs$age == 5), 'value'] <- rnorm(length(fisheryages), mean = 0, sd = .03) 

devs %>% arrange(year, age) %>% select(year, variable, value) %>%
  write.csv(file = "7_devs.csv", row.names = FALSE)

#Manually copy over for tryfisheryselexdevs
expdat <- SS_readdat("5a_tryfisheryselexdevs/data_expval.ss")

expages <- expdat$agecomp %>% select(Yr, FltSvy, paste0("a", 0:8)) %>%
  melt(id.var = c("Yr", "FltSvy"))

expages %>% filter(Yr %in% c(26:30)) %>% ggplot(aes(x = variable, y = value,
                                                    group = Yr)) + 
  geom_point() + geom_line() + facet_wrap(~ Yr)

#
#------------------------------------------------------------------------------------
#Example cohort growth deviations
cohorts <- SS_output("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/sardine_space/2020update/00_caal/meps_reruns/tvselex_cohort")
cpars <- cohorts$parameters %>% slice(grep("CohortGrowDev_DEV", Label)) %>% select(Label, Value) 


bios <- cohorts$timeseries %>% filter(Seas == 1, Era %in% c("TIME", "FORE"))

bios %>% ggplot(aes(x = Yr, y = Bio_smry)) + geom_point() + geom_line()

yy <- cpars$Value
xx <- bios %>% filter(Yr %in% c(1982:2019)) %>% pull(Bio_smry)
plot(xx, yy)

modres <-  lm(yy ~ xx)

ombio <- r_om$timeseries %>% filter(Era == "TIME") %>% select(Bio_smry) %>% pull



pred_coef <- coef(modres)[1] + coef(modres)[2] * ombio

cohortgrow9 <- data.frame(year = 1:60, summbio = ombio, cohortpar = pred_coef)

#Add in small changes in k values
normvals <- (cohortgrow9$cohortpar - min(cohortgrow9$cohortpar)) / (max(cohortgrow9$cohortpar) - min(cohortgrow9$cohortpar))
stdvals <- -(cohortgrow9$cohortpar - mean(cohortgrow9$cohortpar)) / sd(cohortgrow9$cohortpar)

write.csv(stdvals, file = "9_selexpars.csv", row.names = FALSE)

plot(normvals * .3) #Rescale values 
plot(normvals)
hist(normvals)

cohortgrow9$normvals <- normvals * .4



1 - (normvals * .4)

write.csv(cohortgrow9, file = "9_cohortgrowpars.csv", row.names = FALSE)


#------------------------------------------------------------------------------------
#Modify selectivity pars to be blocks, see sardine curves
sardine <- SS_output("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/Sardine2020/starpanel2020/day3_base/NEWBASE")

sardine$parameters %>% slice(grep("BLK3", Label)) %>%
  slice(grep("MexCal_S1", Label)) %>% select(Label, Value) %>% pull(Value) %>% mean

#Mean 0, sd=4

#Years are 11:60
11:60

set.seed(1234)
p1s <- rnorm(n=length(11:60), mean = 0, sd = 2)
p2s <- rnorm(n=length(11:60), mean = 0, sd = 1)
p3s <- rnorm(n=length(11:60), mean = 0, sd = .3)
p4s <- rnorm(n=length(11:60), mean = 0, sd = .1)
sel8 <- data.frame(year = 11:60, p1 = p1s, p2 = p2s, p3 = p3s, p4 = p4s)

write.csv(sel8, file = "8_blockselpars.csv", row.names = FALSE)

SS_read


#----------------------------------------------------------------------
#Check in tester folder
load_all("../r4ss")
datfile <- SS_readdat("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/tester/data_echo.ss_new")

datfile$envdat %>% ggplot(aes(x = Yr, y = Value)) + geom_point() + geom_line()



#Tester with annually varying density-dependent growth
tester <- SS_output("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/tester")

#Add in density-dependent selectivity, low biomass see less older fish
# tester <- SS_output("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/tester_devselex")


omgrowths <- tester$growthseries %>% select(Yr, as.character(0:10)) %>% melt(id.var = "Yr") %>% 
  mutate(age = as.numeric(as.character(variable))) 

omgrowths %>% 
  ggplot(aes(x = age, y = value, group = Yr))  + geom_line(alpha = .5) + 
  theme_sleek() + xlab("Age") + ylab("Length (cm)") 
ggsave("../figs/annual_growth.png", width = 4.5, height = 4.5)


omgrowths %>% filter(age > 0) %>% ggplot(aes(x = Yr, y = value)) + geom_line() +
  facet_wrap(~ age, scales = "free_y") + theme_sleek() + xlab("Year") + ylab("Length (cm)")
ggsave('../figs/growth_variation_byage.png', width = 5, height = 3)




temp <- tester$ageselex
temp <- temp %>% filter(Factor == "Asel") %>% select(Fleet, Yr, as.character(0:10)) %>%
  melt(id.var = c("Yr", "Fleet"))
temp$age <- as.numeric(as.character(temp$variable))  
temp <- temp %>% filter(Yr >= 25)

temp %>% filter(Fleet == 1, Yr %in% c(30:50)) %>% 
  ggplot(aes(x = age, y = value, group = Yr, color = Yr)) + geom_point() + geom_line() + 
  facet_wrap(~ Yr)



#----------------------------------------------------------------------
#Plots of sardine weight-at-age

wtatage <- SS_readwtatage("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/Sardine2020/starpanel2020/day3_base/NEWBASE/wtatage.ss_new")
wtatage <- wtatage %>% select(Yr, Seas, Fleet, as.character(0:10)) %>% filter(Fleet %in% c(1:4)) %>%
  melt(id.var = c("Yr", "Seas", "Fleet"))
wtatage$age <- as.numeric(as.character(wtatage$variable))

wtatage$season <- "spring"
wtatage[which(wtatage$Seas == "1"), 'season'] <- 'summer'


wtatage %>% filter(Fleet == 4, age %in% c(0:4)) %>% ggplot(aes(x = Yr, y = value, color = season, group = season)) +
  geom_point() + geom_line() + facet_wrap(~ age, scales= "free_y") + theme_sleek() +
  theme(legend.position = c(.8, .2)) + xlab("Year") + ylab("Weight-at-age (kg)")
ggsave("nsaw_wtatage.png", width = 5, height = 4)




















#-------------------------
#Try with mack example

r_om <- SS_output("D0-E0-F0-forage/1/om")
r_em <- SS_output("D0-E0-F0-forage/1/em")


read.ta


simres <- SSsummarize(list(r_om = r_om, r_em = r_em))
simres$pars %>% slice(grep("LnQ|R0", Label))

###Sample dev parameters for ages ages for fishery

set.seed(123)
fisheryages <- eval(parse(text =df$sa.years.1))


#age0, sd = 1
age0devs <- rnorm(length(fisheryages), mean = 0, sd = 1)

age1devs <- rnorm(length(fisheryages), mean = 0, sd = .5)
age2devs <- rnorm(length(fisheryages), mean = 0, sd = .5)
age3devs <- rnorm(length(fisheryages), mean = 0, sd = .3)
age4devs <- rnorm(length(fisheryages), mean = 0, sd = .1)
age5devs <- rnorm(length(fisheryages), mean = 0, sd = .03)



#----------------------------------------------
#Sim model diagnostics
#-----------------------
#Visualize selectivities



r_om$sizeselex %>% filter(Fleet %in% c(1, 2), Factor == "Lsel", Yr == 1)
r_em$sizeselex %>% filter(Fleet %in% c(1, 2), Factor == "Lsel")

r_om$ageselex %>% filter(Fleet %in% c(1, 2), Factor == "Asel", Yr == 1)
r_em$ageselex %>% filter(Fleet %in% c(1, 2), Factor == "Asel")

#----------------Look at time series values

#How to add in selectivity devs
mack <- SS_output("C:/Users/peter.kuriyama/SynologyDrive/Assessments/2023_mackerel/model/day2.14c_BASE")
macksel <- mack$parameters %>% select(1:7) %>% slice(grep("ARDEV", Label))

macksel$agepar <- strsplit(split="_", macksel$Label) %>% ldply %>% pull(V4)

macksel %>% group_by(agepar) %>% summarize(sdpars = sd(Value))
#SD of 1 for age 0 selex


tsb <- pull_timeseries(list(r_om = r_om, r_em = r_em))
tsb$model <- tsb[, 1]

ggplot(tsb, aes(x = Yr, y = Bio_smry, group = model, color = model)) + geom_point() +
  geom_line() + facet_wrap(~ model)



tsb %>% filter(model == "r_em")


d1 <- SS_readdat("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/model_dev/D0-E0-F0-codage1/1/om/ss3.dat")
d2 <- SS_readdat("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/forage_growth/model_dev/D0-E0-F0-codage/1/om/ss3.dat")









zz <- SS_readdat_3.30(paste0("1_modbiopars", "/om/forageOM.dat"))

zz$lencomp




yy <- SS_readdat_3.24("C:/Users/peter.kuriyama/SynologyDrive/Research/noaa/sardine_space/from_kevin/T_2016_AT15_len_gone//data.ss_new")


#Look at runs
omres <- SS_output(paste0(df$scenarios, "/1/om"), covar = FALSE, printstats = FALSE)
emres <- SS_output(paste0(df$scenarios, "/1/em"), covar = FALSE, printstats = FALSE)

biores <- pull_timeseries(list(omres = omres, emres = emres))
biores$model <- biores[, 1]



summs <- SSsummarize(list(omres = omres, emres = emres))
summs$pars %>% slice(grep("NatM|Amin|Amax|CV_|R0|steep|LnQ", Label))

ggplot(biores, aes(x = Yr, y = Bio_all, group = model, color = model)) + geom_point() + geom_line()

emres$timeseries




#----------------------------------------------------------------------
#----------------------------------------------------------------------
#999. Look at tester selex

#high biomass selectivity values
#0.75, 0.2, 0, 0, -.1

#low biomass selectivity values
#0.3, 0.05, -0.2, -0.5, -0.5

#Values for p2
bios <- tester$timeseries %>% select(Yr, Era, Bio_smry) %>%
  mutate(maxval = max(Bio_smry), prop = round(Bio_smry / maxval,
                                              digits = 3))

#P2 values
p2vals <- bios$prop * (0.72 - .3) + .3
p3vals <- bios$prop * (0.2 - 0.05) + 0.05
p4vals <- bios$prop * (.2) -.2
p5vals <- bios$prop * (.5) - .5
p6vals <- bios$prop *(.4) - .5

vals <- data.frame(year = bios$Yr, p2 = p2vals, p3 = p3vals,
                   p4 = p4vals, p5 = p5vals, p6 = p6vals)
vals <- vals %>% filter(year >= 11 & year < 61)
write.csv(vals, file = "tvselex_parvals_randwalk.csv")

#first year  1
#min year = 41
bios %>% filter(Era == "TIME") %>% select(Yr, Bio_smry)

#last year 60


tester <- SS_output("../tester")
aselex <- tester$ageselex
aselex <- aselex %>% filter(Fleet == 1, Factor == "Asel") %>% select(Yr, as.character(0:10)) %>%
  melt(id.var = "Yr")

aselex %>% filter(Yr %in% c(1, 11:60)) %>% 
  ggplot( aes(x = variable, y = as.character(Yr), height = value, group = Yr)) + 
  geom_density_ridges(stat = "identity", alpha = .5)

#Look at changes in age 1 selectivity


aselex  %>% ggplot(aes(x = Yr, y = value)) + geom_line() + 
  facet_wrap(~ variable)

#Compare year 41 to year 4
aselex %>% filter(Yr %in% c(1, 41)) %>% 
  ggplot( aes(x = variable, y = as.character(Yr), height = value, group = Yr)) + 
  geom_density_ridges(stat = "identity", alpha = .5)

aselex %>% filter(Yr %in% c(1, 41)) %>% 
  ggplot( aes(x = variable, y = value, group = Yr, color = as.character(Yr))) + 
  geom_line() + geom_point()


#------------------------
#Look at variability in age 1 and age 2 growths
tester$growthseries %>% select(Yr, as.character(0:10)) %>%
  melt(id.var = 'Yr')



#----------------------------------------------------------------------
#Modify growth deviations



















#----------------------------------------------------------------------
#Visualizing the results

r_om <- r4ss::SS_output(file.path(scname[1], "1", "om"),
                        verbose = FALSE, printstats = FALSE, covar = FALSE
)
r_em <- r4ss::SS_output(file.path(scname[1], "1", "em"),
                        verbose = FALSE, printstats = FALSE, covar = FALSE
)
r4ss::SSplotComparisons(r4ss::SSsummarize(list(r_om, r_em)),
                        legendlabels = c("OM", "EM"), subplots = 1
)

#----------------------------------------------------------------------------
#Modify the default OMs
system.file("models", package = "ss3models")
system.file("ss", package = "ss3models")
