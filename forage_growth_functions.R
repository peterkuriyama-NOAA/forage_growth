

#Functions to pull selectivity parameters and growth estimates
pull_ageselex <- function(input_list, ages = 0:10){
  temp <- lapply(input_list, FUN = function(xx){
    tt <- xx$ageselex %>% filter(Factor == "Asel") %>% 
      select(Fleet, Yr, Seas, as.character(ages) )
    tt <- tt %>% melt(id.var = c("Fleet", "Yr", "Seas"))
    tt$age <- as.numeric(as.character(tt$variable))
    tt <- tt %>% select(Fleet, Yr, Seas, age, value)
    return(tt)
  })
  temp <- ldply(temp)
  temp$model <- temp[, 1]
  temp <- temp %>% select(Yr, Fleet, Seas, age, value, model)
  return(temp)
}

pull_lenselex <- function(input_list){
  temp <- lapply(input_list, FUN = function(xx){
    tt <- xx$sizeselex %>% filter(Factor == "Lsel") %>% 
      select(-Factor, -Sex, -Label)
    tt <- tt %>% melt(id.var = c("Fleet", "Yr"))
    tt$len <- as.numeric(as.character(tt$variable))
    tt <- tt %>% select(Fleet, Yr, len, value)
    return(tt)
  })
  temp <- ldply(temp)
  temp$model <- temp[, 1]
  temp <- temp %>% select(Yr, Fleet, len, value, model)
  return(temp)
}

pull_growthseries <- function(input_list, ages = 0:10){
  temp <- lapply(input_list, FUN = function(xx){
    tt <- xx$growthseries %>%
      select(Yr, Seas, as.character(ages) )
    tt <- tt %>% melt(id.var = c("Yr", "Seas"))
    tt$age <- as.numeric(as.character(tt$variable))
    tt <- tt %>% select(Yr, Seas, age, value)
    return(tt)
  })
  temp <- ldply(temp)
  temp$model <- temp[, 1]
  temp <- temp %>% select(Yr, Seas, age, value, model)
  return(temp)
}


# calc_re <- function(res, colname){ #Must have model column with file path
# browser()
#     # temp <- ldply(strsplit(res$model, split = "/"))
#   # res$folder <- paste(temp$V1, temp$V2, sep = "/")
#   # res$iter <- temp$V3
#   # res$mod <- temp$V4
#   
#   res <- res[, c("Yr", colname, "model", "scenario", "iter")]
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

pull_natage <- function(reslist){
  out <- lapply(reslist, FUN = function(xx){
    temp <- xx$natage
    names(temp)[11] <- "beg_mid"
    temp <- temp %>% filter(beg_mid == "B", Era == "TIME")  
    agecols <- names(temp)[13:ncol(temp)]
    
    temp <- temp %>% select(Yr, Seas, agecols)
    temp <- temp %>% melt(id.var = c("Yr", "Seas"))
    
    temp$variable <- as.numeric(as.character(temp$variable))  
    names(temp)[3] <- "age"
    return(temp)
  })
  names(out) <- names(reslist)  
  out <- ldply(out)
  names(out)[1] <- "model"
  return(out)
}

calc_re <- function(res, colname){ #Must have model column with file path
  
  
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



pull_results <- function(model_desc, mods = c("om", "em"), ncores = 24){
  
  folds <- paste0("results/", 
                  paste0(model_desc$dscen, "_", model_desc$OM, "_", model_desc$EM))
  
  flz <- lapply(1:length(folds), FUN = function(xx) {
    tempiters <- list.files(folds[xx])
    alliters <- paste0(folds[xx], "/", tempiters)
    return(alliters)
  })
  
  flz <- unlist(flz)
  ff <- expand.grid(flz, mods) 
  flz <- paste0(ff$Var1, "/", ff$Var2)
  
  #Check that all these files have a report file
  #Check par files
  flznorun <- vector(length = length(flz))
  
  for(ii in 1:length(flz)){
    ssrun <- list.files(flz[ii])
    flznorun[ii] <- ifelse(length(ssrun) == 0, FALSE, TRUE)
  }
  
  flz <- flz[flznorun]
  
  #---Read in the report files
  cl <- makeCluster(ncores)
  registerDoParallel(cl)
  
  start_time <- Sys.time()
  reslist <- foreach::foreach(ii = flz, .packages = "r4ss") %dopar%
    SS_output(ii, printstats = F, covar = F)
  stopCluster(cl)
  end_time <- Sys.time() - start_time; end_time
  
  names(reslist) <- flz
  
  print(end_time)
  return(reslist)  
}



#Function to pull all the scenario characteristics
#Run after adding in model runs and before plotting

get_scens <- function(){
  resfiles <- list.files("results")
  
  resfiles <- resfiles[grep("EM", resfiles)]
  allres <- strsplit(resfiles, split = "_") %>% ldply
  names(allres) <- c("dscen", "OM", "EM")
# browser()
  
  # e1 <- data.frame(EM = "EM1", )

emdesc <- allres %>% distinct(EM) %>% mutate(em_desc = c("No TV Growth; No TV Selex",
                                                           "TV Growth; No TV selex",
                                                           "No TV Growth; TV selex",
                                                           "TV growth + TV selex",
                                                         "No TV Growth; No TV selex; SR-regime",
                                                         "TV Growth; No TV selex; SR-regime",
                                                         "No TV Growth; TV selex; SR-regime",
                                                         "TV growth + TV selex; SR-regime"))
  
  
  omdesc <- allres %>% distinct(OM) %>% mutate(om_desc = c("TV growth; TV selex; SR Regime",
                                                           "TV Growth; TV selex", 
                                                           "TV growth; TV selex; TV survey selex; SR regime"))
  
  
  #Read 
  ###Dat files 
  
  #Check to see which files exist
  datfiles <- paste0('results/', resfiles, "/1/em/")
  
  keeps <- rep(999, length(datfiles))
  
  for(ii in 1:length(datfiles)){
    temp <- list.files(datfiles[ii])
    
    if(length(temp) == 0) next
    if(length(temp) != 0) keeps[ii] <- ii
    
    # ifelse(length(temp) != 0, ii, next)
    # keeps[ii] <- ifelse(grep("data_echo.ss_new", temp), ii, 999)  
  }
  
  keeps <- keeps[which(keeps != 999)]
  
  #--------------
  
  ncores <- 24
  cl <- makeCluster(ncores)
  registerDoParallel(cl)
  
  start_time <- Sys.time()
  datlist <- foreach::foreach(ii = keeps, .packages = "r4ss") %dopar%
    SS_readdat(paste0(datfiles[ii], "data_echo.ss_new"))
  stopCluster(cl)
  end_time <- Sys.time() - start_time; end_time
  
  names(datlist) <- datfiles[keeps]
  
  # datlist[[2]]$sourcefile
  # datlist[[2]]$lencomp %>% filter(FltSvy == 2)
  # 
  
  #####
  #
  #Index sampled CVs
  #Age comp samples
  #Frequency of each samples
  datscen <- lapply(1:length(datlist), FUN = function(xx){
    #Index sampling frequency and CV
    index_year <- datlist[[xx]]$CPUE$year
    index_year <- unique(diff(index_year)) 
    index_CV <- unique(datlist[[xx]]$CPUE$se_log)
    
    #Age Compositions
    agecomp <- datlist[[xx]]$agecomp 
    agecomp1 <- agecomp %>% filter(FltSvy == 1, Lbin_lo == -1)
    acomp1_year <- unique(diff(agecomp1$Yr))
    acomp1_nsamp <- unique(agecomp1$Nsamp)
    
    agecomp2 <- agecomp %>% filter(FltSvy == 2, Lbin_lo == -1)
    acomp2_year <- unique(diff(agecomp2$Yr))
    acomp2_nsamp <- unique(agecomp2$Nsamp)
    
    
    #Length compositions
    lencomp <- datlist[[xx]]$lencomp
    lencomp1 <- lencomp %>% filter(FltSvy == 1)
    lencomp1_year <- unique(diff(lencomp1$Yr))
    lencomp1_nsamp <- unique(lencomp1$Nsamp)
    
    
    lencomp2 <- lencomp %>% filter(FltSvy == 2)
    
    lencomp2 %>% select(Yr, Seas, Nsamp)
    
    lencomp2_year <- unique(diff(lencomp2$Yr))
    lencomp2_nsamp <- unique(lencomp2$Nsamp)
    
    
    caalrow <- agecomp %>% filter(Lbin_lo != -1) %>% nrow
    # caalrow
    
    scen <- datlist[[xx]]$sourcefile
    dscen <- unlist(strsplit(unlist(strsplit(scen, split = "/"))[2], split = "_"))[1]
    
    out <- data.frame(dscen, scen, index_year, index_CV, acomp1_year, acomp1_nsamp, acomp2_year, 
                      acomp2_nsamp, lencomp1_year, lencomp1_nsamp, lencomp2_year, lencomp2_nsamp, caalrow)    
    return(out)  
  })
  
  datscen <- datscen %>% ldply
  datscen$number <- as.numeric(gsub("D", "", datscen$dscen))
  datscen <- datscen %>% arrange(number)
  
  #####Some of the model runs have duplicated lencomps for Fleet 2
  #Related to having CAAl samples
  # datscen %>% filter(lencomp2_year == -50) #
  # datscen %>% filter(caalrow == 0)
  # 
  # 
  # datscen %>% distinct(dscen, acomp1_year, acomp2_year, 
  #                      lencomp1_year, lencomp2_year)
  # 
  # 
  
  
  
  ###Combine the model descriptions
  
  datscen1 <- datscen %>% filter(lencomp2_year == 1)
  datscen1 <- datscen1 %>% distinct(dscen, .keep_all = T)
  
  allres1 <- allres %>% left_join(datscen1)
  allres1 <- allres1 %>% left_join(emdesc)
  allres1 <- allres1 %>% left_join(omdesc)
  
  allres1 <- allres1 %>% mutate(dat_desc = paste0(dscen, "; ",
                                                  "index:", index_year, "yr", " CV=", index_CV, "; \n ",
                                                  "Fishery(fleet1) agecomp", acomp1_year, "yr, n=", acomp1_nsamp, "; \n ", 
                                                  "Survey(fleet2) agecomp", acomp2_year, "yr, n=", acomp2_nsamp, "; \n ", 
                                                  "Fishery lencomp", lencomp1_year, "yr, n=", lencomp1_nsamp, "; \n ", 
                                                  "Survey lencomp", lencomp2_year, "yr, n=", lencomp2_nsamp))
  
  ##Model Descriptions
  modeldesc <- allres1
  # modeldesc %>% filter(dscen == "D91")
  # write.csv(modeldesc, 'results/model_descriptions.csv')
  return(modeldesc)
}



process_results <- function(modres = m1res, model_desc, emorder = c("EM1", "EM2", 
                                                                    "EM3", "EM4")){
  modnames <- data.frame(model = names(modres))
  mm <- strsplit(modnames$model, split = "/") %>% ldply
  modnames$scenario <- mm$V2
  modnames$iter <- mm$V3
  modnames$mod <- mm$V4
  
  #Rename model_desc columns to merge with tsRE
  model_desc1 <- model_desc %>% mutate(opmod = OM, estmod = EM, datscen = dscen) %>% 
    select(opmod, estmod, datscen, dat_desc, om_desc, em_desc)
  
  #factor order the EMs
  model_desc1$estmod <- factor(model_desc1$estmod, levels = emorder)
  model_desc1$em_desc <- factor(model_desc1$em_desc, levels = model_desc1 %>% distinct(estmod, em_desc) %>% pull(em_desc))
  
  #---Check convergence of the models
  lls <- lapply(modres, FUN = function(xx){
    return(cbind(xx$likelihoods_used[1, ], xx$maximum_gradient_component))
  })
  
  lls <- ldply(lls)
  
  #filter out the EMs
  names(lls) <- c("scen", "values", "lambdas", "gradient")
  
  #Set gradient threshold at 0.1
  lls <- lls %>% slice(grep("em", scen)) %>% filter(gradient < .1)
  lls$scen <- gsub("/em", "", lls$scen)
  
  llscens <- ldply(strsplit(lls$scen, split = "/")) %>% select(V2, V3) %>% 
    rename(scen1 = V2, iter = V3)
  llscens$scen <- lls$scen
  
  lls <- lls %>% left_join(llscens)
  
  
  lls <- lls %>% select(scen1, iter, values, gradient) %>% rename(totlike = values, scen = scen1)
  
  #---Pull the growth results
  growths <- pull_growthseries(modres)
  scens <- ldply(strsplit(growths$model, split = "/" ))
  scens <- scens %>% select("V2", "V3", "V4") %>% rename(scen = V2, 
                                                         iter = V3, mod = V4)
  growths <- cbind(growths, scens)
  
  omgrowths <- growths %>% filter(mod == "om") %>% rename(om = value) %>% 
    select(-Seas, -model, -mod)
  
  emgrowths <- growths %>% filter(mod == "em") %>% rename(em = value) %>% 
    select(-Seas, -model, -mod)
  
  growthRE <- emgrowths %>% left_join(omgrowths) %>% mutate(re = (om - em) / om * 100)
  growthRE <- growthRE %>% left_join(lls)
  # opmod, estmod, datscen
  
  ss <- ldply(strsplit(growthRE$scen, split = "_")) %>% 
    rename(datscen = V1, opmod = V2, estmod = V3)
  growthRE <- cbind(growthRE, ss)
  growthRE <- growthRE %>% left_join(model_desc1)
  growthRE$resid <- growthRE$em - growthRE$om
  
  #Sum residual across ages (keep by iteration)
  growthRE <- growthRE %>% group_by(Yr, iter, datscen, opmod, estmod) %>% mutate(iter_resid = sum(resid, na.rm = T)) %>%
    as.data.frame 
  

  #---Pull the selectivity results
  selex <- pull_ageselex(modres)
  scens <- ldply(strsplit(selex$model, split = "/" ))
  scens <- scens %>% select("V2", "V3", "V4") %>% rename(scen = V2, 
                                                         iter = V3, mod = V4)
  selex <- cbind(selex, scens)
  
  omsel <- selex %>% filter(mod == "om") %>% rename(om = value) %>% 
    select(-Seas, -model, -mod)
  
  emsel <- selex %>% filter(mod == "em") %>% rename(em = value) %>% 
    select(-Seas, -model, -mod)
  
  selexRE <- emsel %>% left_join(omsel) %>% mutate(re = (om - em) / om * 100)
  selexRE <- selexRE %>% left_join(lls)
  
  ss <- ldply(strsplit(selexRE$scen, split = "_")) %>% 
    rename(datscen = V1, opmod = V2, estmod = V3)
  selexRE <- cbind(selexRE, ss)
  selexRE <- selexRE %>% left_join(model_desc1)
  selexRE$resid <- selexRE$em - selexRE$om
  
  selexRE <- selexRE %>% group_by(Yr, iter, scen) %>% mutate(iter_resid = sum(resid, na.rm = T)) %>% as.data.frame
  
  #---Pull the summary biomass results
  #
  tsres <- pull_timeseries(modres)
  
  # tsres %>% filter(model %in% c("results/D1_OM14_EM1/1/om", "results/D1_OM14_EM1/1/em"))
  
  tsRE <- calc_re(tsres, colname = "Bio_smry")
  
  #Add in the model descriptions  
  
  
  tsRE <- tsRE %>% left_join(model_desc1)  
  
  tsRE <- tsRE %>% group_by(Yr, scen) %>% mutate(lo5 = quantile(re, .05),
                                                 hi95 = quantile(re, .95),
                                                 med = median(re))
  tsRE <- tsRE %>% left_join(lls)
  
  return(list(growthRE = growthRE, selexRE = selexRE, tsRE = tsRE))
}
