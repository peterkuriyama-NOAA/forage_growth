####
#Run 2

dat_scens <- read.csv("models/dat_scens.csv")
dat_scens$X <- NULL


#Run models
iters <- 1:100
ncores <- 100
cl <- makeCluster(ncores)
registerDoParallel(cl)
start_time <- Sys.time()
scname <- run_ss3sim(iterations = iters, simdf = dat_scens, parallel = T,
                     parallel_iterations = T)

stopCluster(cl)
end_time <- Sys.time() - start_time
print(end_time) 
