#------------------------------------------------------
####
#Run 3; Comp year scens



compyear_scens <- read.csv("models/compyear_scens.csv")

#Turn on overdispersion parameter to 2; 2x input SD
compyear_scens$ce.par_phase

#Run with values of 1 and 2

compyear_scens$sl.cpar <- 1
compyear_scens$sa.cpar <- 1

#Make new data labels with an additional digit
compyear_scens$scenarios
compyear_scens$scenarios <- gsub("D41","D411",  compyear_scens$scenarios)
compyear_scens$scenarios <- gsub("D42","D422",  compyear_scens$scenarios)
compyear_scens$scenarios <- gsub("D43","D433",  compyear_scens$scenarios)
compyear_scens$scenarios <- gsub("D44","D444",  compyear_scens$scenarios)
compyear_scens$scenarios <- gsub("D45","D455",  compyear_scens$scenarios)
compyear_scens$scenarios <- gsub("D46","D466",  compyear_scens$scenarios)

compyear_scens$scenarios <- paste0(compyear_scens$scenarios, "_cpar1")
#------------------------------------------------------
#Run models
iters <- 1:50
ncores <- 50
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = compyear_scens, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) #2 hour run




#------------------------------------------------------
#Read in Results
iters <- 1:50
# c("411", "422", "433", "444", "455", "466")
#Data scenarios that focus on index sampling
folds <- list.files("results")[grep(paste0("D", c("411", "422", "433", "444", "455", "466"), collapse ="|"), list.files("results"))]
folds <- paste0("results/", folds)

folds <- folds[grep("cpar1", folds)]


# folds <- folds[grep("EM11|EM12|EM13|EM14", folds)]

mods <- c("om", "em")
flz <- expand_grid(folds, iters, mods) %>% mutate(unq = paste(folds,
                                                              iters, mods, sep = '/')) %>%
  pull(unq)


ncores <- 50

cl <- makeCluster(ncores)
registerDoParallel(cl)

start_time <- Sys.time()
reslist <- foreach::foreach(ii = flz, .packages = "r4ss") %dopar%
  SS_output(ii, printstats = F, covar = F)
stopCluster(cl)
end_time <- Sys.time() - start_time; end_time

#50 iterations, 24 scenarios run took 3.2 minutes

names(reslist) <- flz
save(reslist, file = "results/D411toD466_EM11toEM14_cpar1_reslist.Rdata")



#------------------------------------------------------
#Process the results
tsres <- pull_timeseries(reslist)
save(tsres, file = "results/D411toD466_EM11toEM14_cpar1_tsres.Rdata")


tsRE <- calc_re(tsres, colname = "Bio_smry")

# datdesc <- data.frame(datscen = paste0("D", c("411", "422", "433", "444", "455", "466")), 
#                       datdesc  =paste0("D", c("411", "422", "433", "444", "455", "466"), "_F1_", 
#                                        datscen$sl.Nsamp.1, "_F2_", datscen$sl.Nsamp.2))
# datdesc <- datdesc %>% distinct(datscen, datdesc)
# tsRE <- tsRE %>% left_join(datdesc, by = 'datscen')  

#Save the results
save(tsRE, file = "results/D411toD466_EM11toEM14_cpar1_tsRE.Rdata")





#------------------------------------------------------
#Pull OMs and EMs from each folder

models <- list.files("results")
models <- models[-grep(".Rdata", models)]

omem_files <- lapply(1:length(models), FUN = function(ii){
  iter <- list.files(paste0("results/",models[ii]))[1]
  
  omem <- paste0("results/", models[ii],"/", iter)
  omem <- paste0(omem, c("/om", "/em"))
  return(omem)  
})


omem_files <- unlist(omem_files)


ncores <- 100

cl <- makeCluster(ncores)
registerDoParallel(cl)

start_time <- Sys.time()
omem_res <- foreach::foreach(ii = omem_files, .packages = "r4ss") %dopar%
  SS_output(ii, printstats = F)
stopCluster(cl)
end_time <- Sys.time() - start_time; end_time


save(omem_res, file = "results/omem_res.Rdata" )


















