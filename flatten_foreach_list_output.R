library(foreach)
library(doSNOW)



foreach_fun <- function(){
  
  
  design <- expand.grid("n" = c(5,10,30,100,400),
                        "d" = c(0,0.2,0.4,0.8))
  
  n_d    <- nrow(design)
  n_reps <- 100
  
  cl       <- makeSOCKcluster(4)
  registerDoSNOW(cl)
  
  res <- foreach(d       = 1:n_d,
                 .combine = "list")  %:% #<<
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
              p
              
              
              
            } # end foreach-design
  
  stopCluster(cl)
  
  
  
  
  
  return(res)
  
} # end function

a <- foreach_fun()


flattenlist     <- function(x){  
  more_lists <- sapply(x, function(first_x) class(first_x)[1]=="list")
  out        <- c(x[!more_lists], unlist(x[more_lists], recursive=FALSE))
  if(sum(more_lists)){ 
    Recall(out)
  }else{
    return(out)
  }
}

b <- flattenlist(a)
