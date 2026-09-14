
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

#FRD Scientist server 2
setwd("C:/Users/FRDScientist/Peter/forage_growth/")

source("forage_growth_functions.R")
#----------------------------------------------------------------------
#Run define_template_scenarios
source("define_template_scenarios.R")


scens

d0scens <- scens %>% slice(grep("D0", scenarios))


#----------------------------------------------------------------------------
#####Define scenarios 

#D11 - annual index
scens1 <- scens %>% slice(grep("D0", scenarios))
scens1$scenarios <- paste0("results/D11_OM14_", "EM", 11:14)
scens1$em_dir <- paste0("models/", "EM", 11:14)
scens1$sc.Nsamp_ages.2 <- rep(100, 4)
scens1$si.sds_obs.2 <- "rep(.2, 50)"

#D12 - two year index
scens2 <- scens1
scens2$scenarios <- gsub("D11", "D12", scens2$scenarios)
scens2$si.years.2 <- "seq(11, 60, by = 2)"
scens2$si.sds_obs.2 <- "rep(.2, 25)"

#D13 - three year index
scens3 <- scens2
scens3$scenarios <- gsub("D12", "D13", scens3$scenarios)
scens3$si.years.2 <- "seq(11, 60, by = 3)"
scens3$si.sds_obs.2 <- "rep(.2, 17)"

index_scens <- rbind(scens1, scens2, scens3)

#----------------------------------------------------------------------------
#Modify index so that CV is density dependent

#D21-D23: Survey index CV mirrors F pattern

cv_scens <- index_scens
cv_scens[1:4, "si.sds_obs.2"] <- cv_scens[1:4, "cf.fvals.1"]
cv_scens[5:8, "si.sds_obs.2"] <- rep("c(seq(.02, .4, length = 12), rev(seq(.02, .4, length = 13)))", 4)
cv_scens[9:12, "si.sds_obs.2"] <- rep("c(seq(.02, .4, length = 9), rev(seq(.02, .4, length = 8)))", 4)

cv_scens$scenarios <- gsub("D11", "D21",cv_scens$scenarios)
cv_scens$scenarios <- gsub("D12", "D22",cv_scens$scenarios)
cv_scens$scenarios <- gsub("D13", "D23",cv_scens$scenarios)



#----------------------------------------------------------------------------
#Combine the index and cv scenarios
run1_scens <- rbind(index_scens, cv_scens)


#Run models
iters <- 1:100
ncores <- 100
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = run1_scens, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) 

#4 hours for 100 iterations










#----------------------------------------------------------------------------
#Run the initial 9999 parts in forage_growth.R
# load("scens.Rdata")

#----------------------------------------------------------------------------
#1. Data scenario definitions are 
#These have index every year with CV of 0.1


#NO CAAL

#Annual age and length samples
#D31: F1 - Lengths 50, ages 50; F2 - Lengths 50, ages 50
#D32: F1 - Lengths 25, ages 25; F2 - Lengths 50, ages 50
#D33: F1 - Lengths 10, ages 10; F2 - Lengths 50, ages 50
#D34: F1 - Lengths 50, ages 50; F2 - Lengths 25, ages 25
#D35: F1 - Lengths 50, ages 50; F2 - Lengths 10, ages 10
#D36: F1 - Lengths 10, ages 10; F2 - Lengths 10, ages 10



tempscen <- scens[1, ]
tempscen$si.sds_obs.2 <- "rep(.2, 50)"

datscen <- tempscen[rep(1, 6), ]
datscen$sc.years.2 <- NA
datscen$sc.Nsamp_lengths.2 <- NA
datscen$sc.Nsamp_ages.2 <- NA

datscen$sl.Nsamp.1 <- as.character(c(50, 25, 10, 50, 50, 10))
datscen$sa.Nsamp.1 <- as.character(c(50, 25, 10, 50, 50, 10))
datscen$sl.Nsamp.2 <- as.character(c(50, 50, 50, 25, 10, 10))
datscen$sa.Nsamp.2 <- as.character(c(50, 50, 50, 25, 10, 10))

datscen$scenarios <- paste0("results/", "D", 31:36, "_OM14_EM4")
datscen$em_dir <- "models/EM4"

#Run it with EM 3, 
datscen1 <- datscen

datscen1$scenarios <- gsub("EM4", "EM1", datscen1$scenarios)
datscen1$em_dir <- gsub("EM4", "EM1", datscen1$em_dir)

datscen2 <- datscen
datscen2$scenarios <- gsub("EM4", "EM2", datscen2$scenarios)
datscen2$em_dir <- gsub("EM4", "EM2", datscen2$em_dir)

datscen <- rbind(datscen1, datscen2)



#-------------------------------------

#-------------------------------------
#Run models
iters <- 51:150
ncores <- 100
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = datscen, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) 

#30 minutes for 50 iterations

#Ended here
#--------------------------------------------------------------------------

#-------------------------------------
#Results
iters <- 1:150
#Data scenarios that focus on index sampling
folds <- list.files("results")[grep(paste0("D", 31:36, collapse ="|"), list.files("results"))]
folds <- paste0("results/", folds)

# folds <- folds[grep("EM4", folds)]
# folds <- folds[grep("EM2", folds)]


mods <- c("om", "em")
flz <- expand_grid(folds, iters, mods) %>% mutate(unq = paste(folds,
                                                              iters, mods, sep = '/')) %>%
  pull(unq)


ncores <- 100

cl <- makeCluster(ncores)
registerDoParallel(cl)

start_time <- Sys.time()
reslist <- foreach::foreach(ii = flz, .packages = "r4ss") %dopar%
  SS_output(ii, printstats = F, covar = F)
stopCluster(cl)
end_time <- Sys.time() - start_time; end_time

names(reslist) <- flz

#Took 4 minutes to read in 150 iters

# modnames <- data.frame(model = flz)
# mm <- strsplit(modnames$model, split = "/") %>% ldply
# modnames$scenario <- mm$V2
# modnames$iter <- mm$V3
# modnames$mod <- mm$V4



# SS_plots(reslist[[1]])

#-------------------------------------
###Plot results
tsres <- pull_timeseries(reslist)
# tsres <- tsres %>% left_join(modnames)

tsRE <- calc_re(tsres, colname = "Bio_smry")

datdesc <- data.frame(datscen = paste0("D", 31:36), 
                      datdesc  =paste0("D", 31:36, "_F1_", 
                                       datscen$sl.Nsamp.1, "_F2_", datscen$sl.Nsamp.2))
datdesc <- datdesc %>% distinct(datscen, datdesc)
tsRE <- tsRE %>% left_join(datdesc, by = 'datscen')  

# tsRE$datscen <- ldply(strsplit(tsRE$scenario, split = "_"))$V1


# tsRE$estmod <- ldply(strsplit(tsRE$scenario, split = "_"))$V3
# tsRE$scen <- tsRE$scenario

tsRE %>% ggplot(aes(x = Yr, y = re, group = iter)) + geom_line() + geom_hline(yintercept = 0,  col = 'red') + 
  facet_grid(estmod ~ datdesc)

# dev.size()
# ggsave("figs/D31_D36_comp_effects.png", width = 11.1, height = 4)



###Median values
tsREsumm <- tsRE %>% group_by(Yr, scen, datscen, datdesc, estmod) %>% summarize(lo10 = quantile(re, .1), mid = median(re),
                                                                                hi90 = quantile(re, .9)) 


tsREsumm %>%
  ggplot(aes(x = Yr)) + geom_line(aes(y = lo10), lty = 2) + geom_line(aes(y = hi90), lty = 2) + 
  geom_line(aes(y = mid)) + facet_grid(datdesc ~ estmod) + 
  geom_hline(yintercept = 0,  col = "red") + ylab("Relative Error") + xlab("Year")


tsREsumm %>%
  ggplot(aes(x = Yr)) + 
  geom_line(aes(y = mid, group = estmod, color = estmod)) +
  geom_hline(yintercept = 0, lty = 2, col = "red") + ylab("Relative Error") + xlab("Year") + 
  facet_wrap(~ datdesc) 




#--------------------------------------------------------------------------------------------------------------
#2. Replicate datscen but with index every other year
#Add in CAAL
grep("D3", datscen$scenarios)

datscen$scenarios <- gsub("D3", "D4", datscen$scenarios)

datscen$si.years.2 <- "seq(11, 60, by = 2)"
datscen$si.sds_obs.2 <- "rep(.2, 25)"

#D37:
#D38:
#D39:


#-------------------------------------
#Run models
iters <- 1:12
ncores <- 24
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = datscen, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) 

#15 minutes for 12 iterations


#-------------------------------------
#Results

#Data scenarios that focus on index sampling
folds <- list.files("results")[grep(paste0("D", 41:46, collapse ="|"), list.files("results"))]
folds <- paste0("results/", folds)
folds <- folds[grep("EM4", folds)]

mods <- c("om", "em")
flz <- expand_grid(folds, iters, mods) %>% mutate(unq = paste(folds,
                                                              iters, mods, sep = '/')) %>%
  pull(unq)


ncores <- 24

cl <- makeCluster(ncores)
registerDoParallel(cl)

start_time <- Sys.time()
reslist <- foreach::foreach(ii = flz, .packages = "r4ss") %dopar%
  SS_output(ii, printstats = F, covar = F)
stopCluster(cl)
end_time <- Sys.time() - start_time; end_time

names(reslist) <- flz

modnames <- data.frame(model = flz)
mm <- strsplit(modnames$model, split = "/") %>% ldply
modnames$scenario <- mm$V2
modnames$iter <- mm$V3
modnames$mod <- mm$V4

#-------------------------------------
###Plot results
tsres <- pull_timeseries(reslist)
tsRE <- calc_re(tsres, colname = "Bio_smry")

datdesc <- data.frame(datscen = paste0("D", 41:46), 
                      datdesc  =paste0("D", 41:46, "_F1_", datscen$sl.Nsamp.1, "_F2_", datscen$sl.Nsamp.2))

tsRE <- tsRE %>% left_join(datdesc)  

tsRE %>% ggplot(aes(x = Yr, y = re, group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2, col = 'red') + 
  facet_wrap(~ datdesc)

ggsave("figs/D41_D46_agecomps_OM4EM4.png", width = 11, height = 4)


###Median values
tsREsumm <- tsRE %>% group_by(Yr, scen, datscen, datdesc, estmod) %>% summarize(lo10 = quantile(re, .1), mid = median(re),
                                                                                hi90 = quantile(re, .9)) 


tsREsumm %>%
  ggplot(aes(x = Yr)) + geom_line(aes(y = lo10), lty = 2) + geom_line(aes(y = hi90), lty = 2) + 
  geom_line(aes(y = mid)) + facet_wrap(~ datdesc) + 
  geom_hline(yintercept = 0, lty = 2, col = "red") + ylab("Relative Error") + xlab("Year")


tsREsumm %>%
  ggplot(aes(x = Yr)) + 
  geom_line(aes(y = mid, color = datdesc)) +
  geom_hline(yintercept = 0, lty = 2, col = "red") + ylab("Relative Error") + xlab("Year")



#---------------------------------------------------------------------------------------------------------------
#3. Run the dat scen with EM2, model misspecification
datscen$scenarios <- gsub("EM4", "EM2", datscen$scenarios)
datscen$em_dir <- gsub("EM4", "EM2", datscen$em_dir)


#Run models
iters <- 1:12
ncores <- 24
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = datscen, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) 

#-----------------------
folds <- list.files("results")[grep(paste0("D", 41:46, collapse ="|"), list.files("results"))]
folds <- paste0("results/", folds)
folds <- folds[grep("EM2", folds)]

mods <- c("om", "em")
flz <- expand_grid(folds, iters, mods) %>% mutate(unq = paste(folds,
                                                              iters, mods, sep = '/')) %>%
  pull(unq)


ncores <- 24

cl <- makeCluster(ncores)
registerDoParallel(cl)

start_time <- Sys.time()
reslist <- foreach::foreach(ii = flz, .packages = "r4ss") %dopar%
  SS_output(ii, printstats = F, covar = F)
stopCluster(cl)
end_time <- Sys.time() - start_time; end_time

names(reslist) <- flz

modnames <- data.frame(model = flz)
mm <- strsplit(modnames$model, split = "/") %>% ldply
modnames$scenario <- mm$V2
modnames$iter <- mm$V3
modnames$mod <- mm$V4

#-------------------------------------
###Plot results
tsres <- pull_timeseries(reslist)
tsRE <- calc_re(tsres, colname = "Bio_smry")

datdesc <- data.frame(datscen = paste0("D", 41:46), 
                      datdesc  =paste0("D", 41:46, "_F1_", datscen$sl.Nsamp.1, "_F2_", datscen$sl.Nsamp.2))

tsRE <- tsRE %>% left_join(datdesc)  

tsRE %>% ggplot(aes(x = Yr, y = re, group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2, col = 'red') + 
  facet_wrap(~ datdesc)

###Median values
tsREsumm <- tsRE %>% group_by(Yr, scen, datscen, datdesc, estmod) %>% summarize(lo10 = quantile(re, .1), mid = median(re),
                                                                                hi90 = quantile(re, .9)) 


tsREsumm %>%
  ggplot(aes(x = Yr)) + geom_line(aes(y = lo10), lty = 2) + geom_line(aes(y = hi90), lty = 2) + 
  geom_line(aes(y = mid)) + facet_wrap(~ datdesc) + 
  geom_hline(yintercept = 0, lty = 2, col = "red") + ylab("Relative Error") + xlab("Year")


tsREsumm %>%
  ggplot(aes(x = Yr)) + 
  geom_line(aes(y = mid, color = datdesc)) +
  geom_hline(yintercept = 0, lty = 2, col = "red") + ylab("Relative Error") + xlab("Year")





