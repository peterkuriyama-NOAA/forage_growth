#---Check specific runs

om <- SS_output("C://Users//FRDScientist//Peter//forage_growth//results//D31_OM14_EM11//13//om")
em <- SS_output("C://Users//FRDScientist//Peter//forage_growth//results//D31_OM14_EM11//13//em")

#---compare the om and em leng comps
omlen <- om$lendbase %>% select(Yr, Time, Fleet, Bin, Exp) %>% rename(om = 'Exp')
emlen <- em$lendbase %>% select(Yr, Time, Fleet, Bin, Nsamp_adj, Nsamp_in, Obs) %>% rename(em = 'Obs')


emlen %>% left_join(omlen) %>% head

emlen %>% left_join(omlen) %>% filter(is.na(om) == F, Fleet == 2) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)
  

#---Age compositions
omage <- om$agedbase %>% select(Yr, Time, Fleet, Bin, Exp) %>% rename(om = 'Exp')
emage <- em$agedbase %>% select(Yr, Time, Fleet, Bin, Nsamp_adj, Nsamp_in, Obs) %>% rename(em = 'Obs')


emage %>% left_join(omage) %>% head


emage %>% left_join(omage) %>% filter(is.na(om) == F, Fleet == 1) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)


emage %>% left_join(omage) %>% filter(is.na(om) == F, Fleet == 2) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)





#---------------Check run with poor size comps

om <- SS_output("C://Users//FRDScientist//Peter//forage_growth//results//D36_OM14_EM11//13//om")
em <- SS_output("C://Users//FRDScientist//Peter//forage_growth//results//D36_OM14_EM11//13//em")

#---compare the om and em leng comps
omlen <- om$lendbase %>% select(Yr, Time, Fleet, Bin, Exp) %>% rename(om = 'Exp')
emlen <- em$lendbase %>% select(Yr, Time, Fleet, Bin, Nsamp_adj, Nsamp_in, Obs) %>% rename(em = 'Obs')



emlen %>% left_join(omlen) %>% filter(is.na(om) == F, Fleet == 1) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)


emlen %>% left_join(omlen) %>% filter(is.na(om) == F, Fleet == 2) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)


#---Age compositions
omage <- om$agedbase %>% select(Yr, Time, Fleet, Bin, Exp) %>% rename(om = 'Exp')
emage <- em$agedbase %>% select(Yr, Time, Fleet, Bin, Nsamp_adj, Nsamp_in, Obs) %>% rename(em = 'Obs')


emage %>% left_join(omage) %>% head


emage %>% left_join(omage) %>% filter(is.na(om) == F, Fleet == 1) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)


emage %>% left_join(omage) %>% filter(is.na(om) == F, Fleet == 2) %>%
  group_by(Yr, Fleet) %>% mutate(omprop = om / sum(om), emprop = em / sum(em)) %>%
  ggplot(aes(x = Bin, group = Yr)) + 
  geom_line(aes(y = omprop), col = 'black') + 
  geom_line(aes(y = emprop), col = 'red') + facet_wrap(~ Yr)
