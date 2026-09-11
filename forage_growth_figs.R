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

