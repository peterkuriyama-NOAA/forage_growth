
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


# scens
# 
# d0scens <- scens %>% slice(grep("D0", scenarios))


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
# write.csv(index_scens, file = "models/index_scens.csv")
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
write.csv(cv_scens, file = "models/cv_scens.csv")

#----------------------------------------------------------------------------
#Composition scenarios - D31 to D36

tempscen <- scens[1, ]
tempscen$si.sds_obs.2 <- "rep(.2, 50)"

datscen <- tempscen[rep(1, 6), ]
datscen$sc.years.2 <- NA
datscen$sc.Nsamp_lengths.2 <- NA
datscen$sc.Nsamp_ages.2 <- NA

#Fishery, 50, 25, 10, 50, 50, 10
datscen$sl.Nsamp.1 <- as.character(c(50, 25, 10, 50, 50, 10))
datscen$sa.Nsamp.1 <- as.character(c(50, 25, 10, 50, 50, 10))

#Survey, 50, 50, 50, 25, 10, 10
datscen$sl.Nsamp.2 <- as.character(c(50, 50, 50, 25, 10, 10))
datscen$sa.Nsamp.2 <- as.character(c(50, 50, 50, 25, 10, 10))

datscen$scenarios <- paste0("results/", "D", 31:36, "_OM14_EM4")
datscen$scenarios <- gsub("EM4", "EM11", datscen$scenarios)
datscen$em_dir <- "models/EM11"

datscen1 <- datscen

#Datscen2
datscen2 <- datscen
datscen2$scenarios <- gsub("EM11", "EM12", datscen2$scenarios)
datscen2$em_dir <- gsub("EM11", "EM12", datscen2$em_dir)

#Datscen3
datscen3 <- datscen
datscen3$scenarios <- gsub("EM11", "EM13", datscen3$scenarios)
datscen3$em_dir <- gsub("EM11", "EM13", datscen3$em_dir)

#Datscen4
datscen4 <- datscen
datscen4$scenarios <- gsub("EM11", "EM14", datscen4$scenarios)
datscen4$em_dir <- gsub("EM11", "EM14", datscen4$em_dir)

#
dat_scens <- rbind(datscen1, datscen2, datscen3, datscen4)
write.csv(dat_scens, file = "models/dat_scens.csv")


#----------------------------------------------------------------------------
#Composition Year scenarios - D41 to D46

#D41 is every 2 years
d41 <- dat_scens %>% slice(grep("D31", scenarios))
d41$scenarios <- gsub("D31", "D41", d41$scenarios)
d41$sl.years.1 <- "seq(10, 60, by = 2)"
d41$sl.years.2 <- "seq(10, 60, by = 2)"
d41$sa.years.1 <- "seq(10, 60, by = 2)"
d41$sa.years.2 <- "seq(10, 60, by = 2)"

#D42, 50 every 3 years
d42 <- d41
d42$scenarios <- gsub("D41", "D42", d42$scenarios)
d42$sl.years.1 <- "seq(10, 60, by = 3)"
d42$sl.years.2 <- "seq(10, 60, by = 3)"
d42$sa.years.1 <- "seq(10, 60, by = 3)"
d42$sa.years.2 <- "seq(10, 60, by = 3)"

#D43 fishery 10, survey 50, every 2 years
d43 <- dat_scens %>% slice(grep("D33", scenarios))
d43$scenarios <- gsub("D33", "D43", d43$scenarios)
d43$sl.years.1 <- "seq(10, 60, by = 2)"
d43$sl.years.2 <- "seq(10, 60, by = 2)"
d43$sa.years.1 <- "seq(10, 60, by = 2)"
d43$sa.years.2 <- "seq(10, 60, by = 2)"


#D44 fishery 10, survey 50, every 3 years
d44 <- d43
d44$scenarios <- gsub("D43", "D44", d44$scenarios)
d44$sl.years.1 <- "seq(10, 60, by = 3)"
d44$sl.years.2 <- "seq(10, 60, by = 3)"
d44$sa.years.1 <- "seq(10, 60, by = 3)"
d44$sa.years.2 <- "seq(10, 60, by = 3)"

#D45 fishery 50, survey 10, every 2 years
d45 <- dat_scens %>% slice(grep("D35", scenarios))
d45$scenarios <- gsub("D35", "D45", d45$scenarios)
d45$sl.years.1 <- "seq(10, 60, by = 2)"
d45$sl.years.2 <- "seq(10, 60, by = 2)"
d45$sa.years.1 <- "seq(10, 60, by = 2)"
d45$sa.years.2 <- "seq(10, 60, by = 2)"

#D46 fishery 10, survey 50, every 3 years
d46 <- d45
d46$scenarios <- gsub("D45", "D46", d46$scenarios)
d46$sl.years.1 <- "seq(10, 60, by = 3)"
d46$sl.years.2 <- "seq(10, 60, by = 3)"
d46$sa.years.1 <- "seq(10, 60, by = 3)"
d46$sa.years.2 <- "seq(10, 60, by = 3)"


compyear_scens <- rbind(d41, d42, d43, d44, d45, d46)

write.csv(compyear_scens, file = "models/compyear_scens.csv", row.names = F)

#----------------------------------------------------------------------------