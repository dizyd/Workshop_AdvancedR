library(tidyverse)
library(bench)
library(profvis)


##### Profiling #####


# Exercise 1 --------------------------------------------------------------



old <- function(){
  
  temp <- as.data.frame(x = matrix(rnorm(4e5 * 100, mean = 5), ncol = 100))
  
  # Get column means
  means <- apply(temp, 2, mean)
  
  # Subtract mean from each column
  for (i in 1:length(means)) {
    temp[, i] <- temp[, i] - means[i]
  }
  
  
}

profvis({
  
  old()
  
})


your_function <- function(){
  
  temp <- matrix(rnorm(4e5 * 100, mean = 5), ncol = 100) ##
  
  # Get column means
  means <- colMeans(temp) 
  
  # Subtract mean from each column
  for (i in 1:length(means)) {
    temp[, i] <- temp[, i] - means[i]
  }

  
}


profvis({
  
  your_function()
  
})


bench::mark(
  "old" = old(),
  "yours" = your_function()
)







# Exercise 2 --------------------------------------------------------------



make_data   <- function(){
  
  x1     <- rnorm(150, mean = 175, sd = 20)
  x2     <- rnorm(150, mean = 100, sd = 15)
  e      <- rnorm(150, mean = 0,   sd = 25)
  y      <- 100 + 5 * x1 + 8 * x2
  y_hat  <- 100 + 5 * x1 + 8 * x2 + e

 m=cbind(y_hat,y,x1,x2)
 
 m
  
}

center_data <- function(m){
  
  m[,3] <- scale(m[,3],scale=F)
  m[,4] <- scale(m[,4],scale=F)
  
  as.data.frame(m)
  
}

compute_lm <- function(df_c){
  
  res <- lm(y_hat~x1+x2,df_c)
  
  coefficients(res)[c(2,3)]
  
  
}

sim <- function(nreps=100){
  
  results <- matrix(ncol=nreps,nrow=2)
  
  for(i in 1:nreps){
    
    df   <- make_data()
    df_c <- center_data(df)
    
    results[,i] <- compute_lm(df_c)
    
  }
  
  x <- rowMeans(results) %>% round(3)

  
  cat(" Estimate X1:",x[1],"| TRUE: 5","\n","Estimate X2:",x[2],"| TRUE: 8","\n")
  
}



profvis({
  sim(nreps=100)
})


bench::mark(
  sim(nreps=100),
  min_iterations = 10
)

# Original: 

#    expression      min     median  `itr/sec`  mem_alloc                
# sim(nreps = 100)  325ms    329ms     3.05    40.7MB 