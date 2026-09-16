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


d31tsRE %>% group_by(scen)  %>% mutate(mare = abs(median(re))) %>%
  group_by(scen, Yr, datscen, opmod, estmod ) %>% summarize(lo = quantile(re, .05),
  med = median(re), hi = quantile(re, .95), mare = unique(mare))


d31tsRE_med <- d31tsRE %>% group_by(scen, Yr, datscen, opmod, estmod, datdesc) %>% summarize(lo5 = quantile(re, .05), median_re = median(re),
  hi95 = quantile(re, .95))

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


d31tsRE$re %>% quantile

d31tsRE %>% filter(re < 100) %>% group_by()

d31tsRE_med <- d31tsRE_med %>% left_join(d31tsRE %>% select(scen, estmod, datscen, opmod) )
d31tsRE_med <- d31tsRE_med %>% distinct()


d31tsRE %>% filter(re < 100) %>% ggplot(aes(x = re)) + geom_histogram() + 
  facet_grid(estmod ~ datscen) + xlim(-50, 50) + 
  geom_vline(data = d31tsRE_med, aes(xintercept = mean_re))



d31tsRE %>% group_by(Yr, scen) %>% mutate(median_value = median(re)) %>% as.data.frame %>%
  ggplot(aes(x = Yr, y = re, 
  group = iter)) + geom_line() + geom_hline(yintercept = 0, lty = 2) + 
  facet_grid(estmod ~ datscen) + ylim(-50, 50) + geom_line(aes(x = Yr, y= median_value), color = 'red')

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













#------------------------------------------------------------------------
#Forage fish simulation figures
#source forage_growth.R

modeldesc <- get_scens()

#Only with Regime models
#Filter OM 14, which has regime
#EM4 and EM 14; to compare proper specification of regime conditions

#D91; increasing survey CV at low biomass
m91 <- modeldesc %>% filter(dscen %in% c("D91", "D92", "D93"))
res91 <- pull_results(model_desc = m91)
# save(res91, file = "results/res91.Rdata")


tsRE91 <- process_results(modres = res91, model_desc = m91, 
                          emorder = c("EM11", "EM12", "EM13", "EM14"))

#------------------------------------------------------------------------
#Operating model figures
#------------------------------------------------------------------------
#Figure 1: Experimental design with sampling


#Plot the F pattern with recdevs and other deviations
names(res91)[1]

temp <- res91[[1]] 

#F values
p1 <- temp$exploitation %>% ggplot(aes(x = Yr, y = FISHERY)) + 
  geom_line() + theme_sleek()

#Recruitment deviations
p2 <- temp$recruit %>% ggplot(aes(x = Yr, y = raw_dev)) +
  geom_line() + theme_sleek()


#Growth deviations
temp$biology



#Biomass trend
p3 <- temp$timeseries %>% filter(Yr > 0) %>% ggplot(aes(x = Yr, y = Bio_all))  +
  geom_line() + xlab("Year") + ylab("Total biomass (mt)") + 
  scale_y_continuous(label = comma) + theme_sleek()



p1/p2/p3

(p1 + p2)/p3


temp$recruit$raw_dev


temp$re %>% ggplot(aes(x = Yr, y = FISHERY)) + 
  geom_line() + theme_sleek()




#Growth (age-length relationship)






#------------------------------------------------------------------------

