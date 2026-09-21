#------------------------------------------------------
####
#Run 3; Comp year scens

compyear_scens <- read.csv("models/compyear_scens.csv")
# dat_scens$X <- NULL

#------------------------------------------------------
#Run models
iters <- 1:100
ncores <- 100
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = compyear_scens, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) #5 hour run


compyear_scens

#------------------------------------------------------
#Read in Results
iters <- 1:100
#Data scenarios that focus on index sampling
folds <- list.files("results")[grep(paste0("D", 41:46, collapse ="|"), list.files("results"))]
folds <- paste0("results/", folds)

# folds <- folds[grep("EM11|EM12|EM13|EM14", folds)]

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

#100 iterations, 24 scenarios run took 5.4 minutes

names(reslist) <- flz
save(reslist, file = "results/D41toD46_EM11toEM14_reslist.Rdata")

#------------------------------------------------------
#Process the results
tsres <- pull_timeseries(reslist)
save(tsres, file = "results/D41toD46_EM11toEM14_tsres.Rdata")


tsRE <- calc_re(tsres, colname = "Bio_smry")

datdesc <- data.frame(datscen = paste0("D", 41:46), 
                      datdesc  =paste0("D", 41:46, "_F1_", 
                                       datscen$sl.Nsamp.1, "_F2_", datscen$sl.Nsamp.2))
datdesc <- datdesc %>% distinct(datscen, datdesc)
tsRE <- tsRE %>% left_join(datdesc, by = 'datscen')  

#Save the results
save(tsRE, file = "results/D41toD46_EM11toEM14_tsRE.Rdata")































