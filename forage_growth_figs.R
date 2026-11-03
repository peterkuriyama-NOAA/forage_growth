#------------------------------------------------------------------------
#Source the forage_growth.R script before

#Read in results


#-------------------------------------------------------------------------------------------------------------
#D
load("results_sep2026/D411toD466_EM11toEM14_tsRE.Rdata")
dir41tsRE <- tsRE

# outlier <- dir41tsRE %>% group_by(datscen, estmod, iter) %>% summarize(mean_re = mean(re))
# 
# outlier %>% arrange(desc(abs(mean_re)))
# 
# 
# #Filter out outliers
# dir41tsRE_med <- dir41tsRE %>% group_by(datscen, opmod, estmod, Yr) %>% summarize(mean_re = mean(re),
#                                                                  median_re = median(re),
#                                                                  q90 = quantile(re, prob = .9),
#                                                                  q10 = quantile(re, prob = .1))
# 
# 
# dir41tsRE_med %>% ggplot(aes(x = Yr, y = mean_re, color = datscen)) + facet_wrap( ~ estmod ) + 
#   geom_line() + geom_hline(aes(yintercept = 0), lty = 2) 
# 
# 
# #How often would management be correct
# #OM closure
# closures <- dir41tsRE
# closures$om_closed <- FALSE
# closures[which(closures$om < 150000), "om_closed"] <- "TRUE"
# closures$em_closed <- FALSE
# closures[which(closures$em < 150000), "em_closed"] <- "TRUE"
# 
# closures$false_closure <- FALSE
# 
# closures[which(closures$em_closed != closures$om_closed &
#                  closures$om_closed == T), "false_closure"] <- TRUE
# 
# closures %>% group_by(datscen, estmod) %>% summarize(nfalse = sum(false_closure)) %>%
#   dcast(datscen~ estmod, value.var = "nfalse")
# 
# #Look at the years between 30 and 40 where EMs seem to have the highest RE
# 
# 
# dir41tsRE %>% ggplot(aes(x = Yr, y = re, group = iter)) + 
#   geom_line() + facet_grid(datscen ~ estmod) + ylim(-50, 50)
# 

#-------------------------------------------------------------------------------------------------------------
#D31 to D36 results for EM11 to EM14
#Modification of compositions
load("results_sep2026/D31toD36_EM11toEM14_tsRE.Rdata")
d31tsRE <- tsRE
# rm(tsRE)

#D31 to D36 results
#Modify the numbers of size comp samples for the fishery (F1) and survey (F2)

#-------------------------------------------------------------------------------------------------------------
load("results_sep2026/D11toD23_EM11toEM14_tsRE.Rdata")
d11tsRE <- tsRE

#-------------------------------------------------------------------------------------------------------------
#--------------------------------------------------
#D41 to D46; modify frequency of comp sampling
load("results_sep2026/D41toD46_EM11toEM14_tsRE.Rdata")
d41tsRE <- tsRE

#--------------------------------------------------

#Load the scenario descriptions
tsRE <- rbind(dir41tsRE, d11tsRE, d31tsRE %>% select(-datdesc), d41tsRE %>% select(-datdesc))



#EM descriptions
emdesc <- tsRE %>% distinct(estmod) %>% mutate(estmod_desc = c("Cons growth; Cons sel",
                                                     "TV growth; Cons sel",
                                                     "Cons growth; TV sel",
                                                     "TV Growth; TV Sel"))
tsRE1 <- tsRE %>% left_join(emdesc)


###Data scenario descriptions
d1 <- read.csv("github/forage_growth/models/compyear_scens.csv")
d1 <- d1 %>% select(si.years.2, si.sds_obs.2, sl.Nsamp.1, sl.years.1,
              sl.Nsamp.2, sl.years.2, sa.Nsamp.1, sa.years.1, sa.Nsamp.2, sa.years.2, scenarios)

d2 <- read.csv("github/forage_growth/models/run1_scens.csv")
d2 <- d2 %>% select(si.years.2, si.sds_obs.2, sl.Nsamp.1, sl.years.1,
                    sl.Nsamp.2, sl.years.2, sa.Nsamp.1, sa.years.1, sa.Nsamp.2, sa.years.2, scenarios)

d3 <- read.csv("github/forage_growth/models/dat_scens.csv")
d3 <- d3 %>% select(si.years.2, si.sds_obs.2, sl.Nsamp.1, sl.years.1,
                    sl.Nsamp.2, sl.years.2, sa.Nsamp.1, sa.years.1, sa.Nsamp.2, sa.years.2, scenarios)

dd <- rbind(d1, d2, d3)
dd <- dd[grep("EM11|EM12|EM13|EM14", dd$scenarios), ]

###Parse out the data scenarios
dtemp <- ldply(strsplit(dd$scenarios, split = "/"))$V2
dd$datscen <- ldply(strsplit(dtemp, split = "_"))$V1
index1 <- gsub(")","",ldply(strsplit(dd$si.years.2, split = " by = "))$V2)
index2 <- lapply(parse(text = dd$si.sds_obs.2), eval)
index2 <- lapply(index2, range)
index2 <- sapply(index2, FUN = function(xx) paste0(xx, collapse = "_"))
dd$index <- paste0("year ", index1, "; cv ", index2)

###Length comps
l1 <- unlist(lapply(dd$sl.years.1, FUN = function(xx) unique(diff(eval(parse(text = xx))))))
l2 <- unlist(lapply(dd$sl.years.2, FUN = function(xx) unique(diff(eval(parse(text = xx))))))

l1 <- paste0("F1_n", dd$sl.Nsamp.1, "_years_", l1)
l2 <- paste0("F2_n", dd$sl.Nsamp.2, "_years_", l2)

dd$lencomp <- paste0(l1, "; ", l2)

###Age comps
a1 <- unlist(lapply(dd$sa.years.1, FUN = function(xx) unique(diff(eval(parse(text = xx))))))
a2 <- unlist(lapply(dd$sa.years.2, FUN = function(xx) unique(diff(eval(parse(text = xx))))))

a1 <- paste0("F1_n", dd$sa.Nsamp.1, "_years_", a1)
a2 <- paste0("F2_n", dd$sa.Nsamp.2, "_years_", a2)

dd$agecomp <- paste0(a1, "; ", a2)

dscen_key <- dd %>% distinct(datscen, index, lencomp, agecomp)

###Format the D41 scenarios with dirichlet cpar of 2 (2x SD in the comps)
dir_key <- dscen_key[grep("D4", dscen_key$datscen), ]
dir_key$datscen <- c("D411", "D422", "D433", "D444", "D455", "D466")
dir_key$lencomp <- paste0(dir_key$lencomp, "_dir2")
dir_key$agecomp <- paste0(dir_key$agecomp, "_dir2")

dscen_key <- rbind(dscen_key, dir_key)

#Add in to all the 
tsRE[which(tsRE$datscen == "D4111" ), "datscen"] <- "D411"


tsRE <- tsRE %>% left_join(emdesc, by = 'estmod') %>%
  left_join(dscen_key, by = 'datscen')

#--------------------------------------------------

# d41tsRE %>% group_by(scen)  %>% mutate(mare = abs(median(re))) %>%
#   group_by(scen, Yr, datscen, opmod, estmod ) %>% summarize(lo = quantile(re, .05),
#                                                             med = median(re), hi = quantile(re, .95), mare = unique(mare))
# 

tsRE_med <- tsRE %>% group_by(scen, Yr, datscen, opmod, estmod, estmod_desc, index, lencomp, agecomp) %>% 
  summarize(lo5 = quantile(re, .05), median_re = median(re), hi95 = quantile(re, .95))

#--------------------------------------------------
#Plots of median and 90% percentiles for each scenario###Relative error of age 1+ biomass
#--------------------------------------------------

tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp)

###D11, D31, D36
###Annual index with decreasing samples of length and age comps
tsRE_med %>% filter(datscen %in% c("D11", "D31", "D36"))  %>%
  mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36")), lencomp = factor(lencomp)) %>%
  ggplot(aes(x = Yr, group = lencomp,
             color = lencomp, fill = lencomp)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod_desc) + geom_hline(aes(yintercept = 0), lty = 2) + 
  theme(legend.position = c(.5, .5))




tsRE_med %>% filter(datscen %in% c("D11", "D31", "D36"))  %>% mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + agecomp + lencomp ~ estmod + estmod_desc) + geom_hline(aes(yintercept = 0), lty = 2) + 
  ylab("Relative Error Summary biomass (age-1+)") + xlab("Year") +
  theme(legend.position = 'none')
ggsave(filename = "figs/sep2026/decreasing_ncomp.png", width = 10, height = 10)



#----------------
###Index year with density-dependent CVs, and high comp sample sizes
#----------------

# Y:\My Drive\forage_growth\figs\sep2026

tsRE_med %>% filter(datscen %in% c("D11", "D21", "D22", "D23")) %>% 
  ungroup %>% 
  distinct(datscen, lencomp, agecomp)

tsRE_med %>% filter(datscen %in% c("D11", "D21", "D22", "D23"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + index ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none') + 
  ylim(c(-50, 50))
ggsave(filename = "figs/sep2026/density_dependent_indexcv.png", width = 10, height = 10)


#----------------
###Modify the fishery comp sample sizes
#----------------
tsRE_med %>% filter(datscen %in% c("D31", "D32", "D33"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')


#----------------
###Modify the survey comp sample sizes
#----------------
tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp) %>% 
  slice(grep("F1_n50", lencomp))


tsRE_med %>% filter(datscen %in% c("D31", "D34", "D35"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D31", "D34", "D33"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')



#----------------
###Frequency of size composition sampling with 50 samples
#----------------
tsRE_med %>% filter(datscen %in% c("D31","D41", "D42"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')



#----------------
###Frequency of size composition sampling with 50 samples for fishery and survey
#----------------
tsRE_med %>% filter(datscen %in% c("D33","D43", "D44"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')



#----------------
###Frequency of size composition sampling with 10 samples for fishery, 50 samples for survey
#----------------
tsRE_med %>% filter(datscen %in% c("D33","D43", "D44"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')


tsRE_med %>% filter(datscen %in% c("D33", "D43", "D44"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = lencomp,
             color = lencomp, fill = lencomp)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2) + 
  theme(legend.position = c(.5, .5))


#----------------
###Frequency of size composition sampling with 50 samples for fishery, 10 samples for survey
#----------------
tsRE_med %>% filter(datscen %in% c("D35","D45", "D46"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + lencomp + agecomp ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none')



tsRE_med %>% filter(datscen %in% c("D35","D45", "D46"))  %>%
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = lencomp,
             color = lencomp, fill = lencomp)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2) + 
  theme(legend.position = c(.5, .5))



#--------------------------------
###Dirichlet comps, cpar = 2
#--------------------------------

# Y:\My Drive\forage_growth\figs\sep2026

tsRE_med %>% filter(datscen %in% c("D411", "D422", "D433", "D444", "D455",
                                   "D466")) %>% 
  ungroup %>% 
  distinct(datscen, lencomp, agecomp)

tsRE_med %>% filter(datscen %in% c("D411", "D422", "D433", "D444", "D455",
                                   "D466")) %>% 
  # mutate(datscen = factor(datscen, levels = c("D11", "D31", "D36"))) %>%
  ggplot(aes(x = Yr, group = datscen,
             color = datscen, fill = datscen)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_grid(datscen + index ~ estmod + estmod_desc) + 
  geom_hline(aes(yintercept = 0), lty = 2) + theme(legend.position = 'none') + 
  ylim(c(-50, 175))


#-------------
#Compare the sampled age comps between the dirichlet sampling and the OM
#-------------
load("results_sep2026/D411toD466_EM11toEM14_reslist.Rdata")

names(reslist)[[1:2]]
temp <- reslist[1:2]

temp1 <- temp[[1]]
temp1$agedbase



temp2 <- temp[[2]]
temp2$agedbase 

SS_plots(temp2, dir = "results_sep2026/EMplots" )


#Compare the OM and EM age comps in an example
temp1$agedbase$model <- "OM"
temp1$agedbase$value <- temp1$agedbase$Exp

temp2$agedbase$model <- "EM"
temp2$agedbase$value <- temp2$agedbase$Obs

#Exploitation Rate
temp2$exploitation
temp2$catch %>% select(Fleet, Yr, F)

agecomps <- rbind(temp1$agedbase, temp2$agedbase)


agecomps %>% filter(Yr == 22, Fleet == 1)

agecomps %>% filter(Yr <= 25, Fleet == 1) %>% 
  ggplot(aes(x = Bin, y = value, group = model, color = model)) + geom_line() + 
  facet_wrap(~Yr)

agecomps %>% filter(Yr <= 25, Fleet == 2) %>% 
  ggplot(aes(x = Bin, y = value, group = model, color = model)) + geom_line() + 
  facet_wrap(~Yr)

# ggsave(filename = "figs/sep2026/density_dependent_indexcv.png", width = 10, height = 10)




















tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp) %>% 
  slice(grep("years_3", lencomp))

tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp) %>% 
  slice(grep("years_1", lencomp))

#D41, D43, D45
#D42, D44, D46
#D31, D35
tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp)

tsRE_med %>% filter(datscen %in% c("D41", "D43", "D45", "D42", "D44", "D46")) %>% 
  ungroup %>% distinct(datscen, index, lencomp, agecomp)




tsRE_med %>% ungroup %>% distinct(datscen, index, lencomp, agecomp) %>% 
  slice(grep("F2_n50", lencomp))










#Decreasing the survey age composition numbers from 50 to 25 to 10
d41tsRE_med %>% 
   ggplot(aes(x = Yr, group = datdesc,
                                                             color = datdesc, fill = datdesc)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2)

#Look just at EM11
d41tsRE_med %>% filter(estmod == "EM11") %>%
  ggplot(aes(x = Yr, group = datdesc,
             color = datdesc, fill = datdesc)) + 
  geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ datdesc) + geom_hline(aes(yintercept = 0), lty = 2) + 
  theme(legend.position = 'none')



#Decreasing the fishery age composition numbers from 50 to 25 to 10
d41tsRE_med %>% 
  filter(datscen %in% c("D32", "D33", "D36")) %>% ggplot(aes(x = Yr, group = datdesc,
                                                             color = datdesc, fill = datdesc)) + geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2)

#--------------------------------------------------
#Plots of median and trajectories by year and relative error
#--------------------------------------------------
d41tsRE %>% group_by(Yr, scen) %>% mutate(median_value = median(re)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = re, 
             group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + ylim(-50, 50) + geom_line(aes(x = Yr, y= median_value), color = 'red')


#Zoom in on years where the biomass is low
d41tsRE %>% group_by(Yr, scen) %>% mutate(median_value = median(re)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = re, 
             group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + ylim(-50, 50) + geom_line(aes(x = Yr, y= median_value), color = 'red') +
  xlim(25, 40)


#Plot as biomass
d41tsRE$error <- d41tsRE$em  - d41tsRE$om


d41tsRE %>% group_by(Yr, scen) %>% mutate(median_error = median(error)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = error, 
             group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + geom_line(aes(x = Yr, y= median_error), color = 'red')  + 
  ylim(-1e6, 1e6)



d41tsRE %>% group_by(Yr, scen) %>% mutate(median_error = median(error)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = error, 
             group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + geom_line(aes(x = Yr, y= median_error), color = 'red') +
  xlim(25, 40) + ylim(-200000, 200000)



#Try to figure out which runs would be consequential for management
d41tsRE %>% ggplot(aes(x = Yr, y = om, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen)

#Look at specifically when the true biomass is low
d41tsRE %>% ggplot(aes(x = Yr, y = em, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen) + xlim(29, 41) + ylim(0, 500000)

d41tsRE %>% ggplot(aes(x = Yr, y = em, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen) + xlim(29, 41) + ylim(0, 400000)









#Calculate median relative error
t31tsRE %>% group_by()


d41tsRE %>% filter(scen == "d41_OM14_EM11") %>% ggplot(aes(x = Yr, y = re, 
                                                           group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2)





d41tsRE %>% distinct(scen, datscen, opmod, estmod, .keep_all = T) 



d41sumRE <- d41tsRE %>% group_by(scen, datscen, opmod, estmod) %>%
  mutate(mare = abs(median(re))) %>% ungroup %>% group_by(scen, Yr, datscen, opmod, estmod) %>% 
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






#-------------------------------------------------------------------------------------------------------------


d31tsRE %>% group_by(scen)  %>% mutate(mare = abs(median(re))) %>%
  group_by(scen, Yr, datscen, opmod, estmod ) %>% summarize(lo = quantile(re, .05),
  med = median(re), hi = quantile(re, .95), mare = unique(mare))


d31tsRE_med <- d31tsRE %>% group_by(scen, Yr, datscen, opmod, estmod, datdesc) %>% summarize(lo5 = quantile(re, .05), median_re = median(re),
  hi95 = quantile(re, .95))

#--------------------------------------------------
#Plots of median and 90% percentiles for each scenario
#--------------------------------------------------

#Decreasing the survey age composition numbers from 50 to 25 to 10
d31tsRE_med %>% 
  filter(datscen %in% c("D31", "D34", "D35")) %>% ggplot(aes(x = Yr, group = datdesc,
  color = datdesc, fill = datdesc)) + geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2)


#Decreasing the fishery age composition numbers from 50 to 25 to 10
d31tsRE_med %>% 
  filter(datscen %in% c("D32", "D33", "D36")) %>% ggplot(aes(x = Yr, group = datdesc,
  color = datdesc, fill = datdesc)) + geom_line(aes(y = median_re)) + 
  geom_ribbon(aes(ymin = median_re, ymax = lo5), lty = 1, alpha = .2) + 
  geom_ribbon(aes(ymin = median_re, ymax = hi95), lty = 1, alpha = .2) + 
  facet_wrap(~ estmod) + geom_hline(aes(yintercept = 0), lty = 2)

#--------------------------------------------------
#Plots of median and trajectories by year and relative error
#--------------------------------------------------
d31tsRE %>% group_by(Yr, scen) %>% mutate(median_value = median(re)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = re, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + ylim(-50, 50) + geom_line(aes(x = Yr, y= median_value), color = 'red')


#Zoom in on years where the biomass is low
d31tsRE %>% group_by(Yr, scen) %>% mutate(median_value = median(re)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = re, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + ylim(-50, 50) + geom_line(aes(x = Yr, y= median_value), color = 'red') +
  xlim(25, 40)


#Plot as biomass
d31tsRE$error <- d31tsRE$em  - d31tsRE$om


d31tsRE %>% group_by(Yr, scen) %>% mutate(median_error = median(error)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = error, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + geom_line(aes(x = Yr, y= median_error), color = 'red')  + 
  ylim(-1e6, 1e6)



d31tsRE %>% group_by(Yr, scen) %>% mutate(median_error = median(error)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = error, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + geom_line(aes(x = Yr, y= median_error), color = 'red') +
  xlim(25, 40) + ylim(-200000, 200000)



#Try to figure out which runs would be consequential for management
d31tsRE %>% ggplot(aes(x = Yr, y = om, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen)

#Look at specifically when the true biomass is low
d31tsRE %>% ggplot(aes(x = Yr, y = em, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen) + xlim(29, 41) + ylim(0, 500000)
 
 d31tsRE %>% ggplot(aes(x = Yr, y = em, group = iter)) + geom_line(alpha = .5) + 
  facet_grid(estmod ~ datscen) + xlim(29, 41) + ylim(0, 400000)



 
 




#Calculate median relative error
t31tsRE %>% group_by()


d31tsRE %>% filter(scen == "D31_OM14_EM11") %>% ggplot(aes(x = Yr, y = re, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2)





d31tsRE %>% distinct(scen, datscen, opmod, estmod, .keep_all = T) 



d31sumRE <- d31tsRE %>% group_by(scen, datscen, opmod, estmod) %>%
  mutate(mare = abs(median(re))) %>% ungroup %>% group_by(scen, Yr, datscen, opmod, estmod) %>% 
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




