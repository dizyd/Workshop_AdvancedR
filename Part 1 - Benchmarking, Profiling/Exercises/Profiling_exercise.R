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
  
  old
  
})


your_function <- function(){
  

  
}



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

 df=data.frame(y_hat,y,x1,x2)
 
 df
  
}

center_data <- function(df){
  
  meanX1 <- mean(df[,3])
  meanX2 <- mean(df[,4])
  
  for(i in 1:nrow(df)){
    
    df[i,3] <- df[i,3]-meanX1
    df[i,4] <- df[i,4]-meanX2
  
  }
  
  df
  
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
# sim(nreps = 100)  1.14s    1.22s     0.705    40.7MB 