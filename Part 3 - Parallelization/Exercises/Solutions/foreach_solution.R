library(foreach)
library(doSNOW)
library(bench)

for_fun <- function(){
  

  design <- expand.grid("n" = c(5,10,30,100,400),
                        "d" = c(0,0.2,0.4,0.8))
  
  n_d    <- nrow(design)
  n_reps <- 1000
  
  power <- vector(mode = "integer",length=n_d) 
  
  for(d in 1:n_d){
    
    p <- vector(mode = "integer",length=n_reps)
    
    for(rep in 1:n_reps){
      
      # Generate Data
      N <- design[d,"n"]
      D <- design[d,"d"]
    
      x1 <- rnorm(N, 0, 1)
      x2 <- rnorm(N, D, 1)
      
      # Do t-test
      t      <- t.test(x1, x2, var.equal=TRUE)  
      p[rep] <- ifelse(t$p.value <0.05,1,0)
      
      
    } # end for-reps
    
    power[d] <- mean(p)
    
  } # end for-design
  
  
  design$power <- power
  
  return(design)
  
} # end function

















foreach_fun <- function(){
  
  
  design <- expand.grid("n" = c(5,10,30,100,400),
                        "d" = c(0,0.2,0.4,0.8))
  
  n_d    <- nrow(design)
  n_reps <- 1000
  
  cl       <- makeSOCKcluster(4)
  registerDoSNOW(cl)
  
  res <- foreach(d       = 1:n_d,
                .combine = "rbind")  %:% #<<
              foreach(rep      = 1:n_reps,
                      .combine = "c") %dopar% {
        
        # Generate Data
        N <- design[d,"n"]
        D <- design[d,"d"]
        
        x1 <- rnorm(N, 0, 1)
        x2 <- rnorm(N, D, 1)
        
        # Do t-test
        t  <- t.test(x1, x2, var.equal=TRUE)  
        p  <- ifelse(t$p.value <0.05,1,0)
        
        
     
      
  } # end foreach-design
  
  stopCluster(cl)
  
  
  
  power        <- rowMeans(res)  
  design$power <- power
  
  return(design)
  
} # end function














