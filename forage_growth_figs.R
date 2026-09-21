#------------------------------------------------------------------------
#Read in results
options(max.print = 100)

list.files("results_sep2026")

#D31 to D36 results for EM11 to EM14
#Modification of compositions
load("results_sep2026/D31toD36_EM11toEM14_tsRE.Rdata")
d31tsRE <- tsRE
rm(tsRE)

load("results_sep2026/D11toD23_EM11toEM14_tsRE.Rdata")
d11tsRE <- tsRE


#------------------------------------------------------------------------
#D31 to D36 results
#Modify the numbers of size comp samples for the fishery (F1) and survey (F2)


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



d31tsRE %>% head



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




