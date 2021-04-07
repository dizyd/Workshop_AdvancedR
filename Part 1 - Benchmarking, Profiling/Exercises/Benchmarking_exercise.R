library(tidyverse)
library(tictoc)
library(microbenchmark)
library(benchmarkme)
library(bench)
library(data.table)


##### Benchmarking #####


# Exercise 1 - Reading in Data Files    --------------------------------------------------------------

# Create and save a small and a big matrix as .csv or .rds file 



# small <- as.data.frame(matrix(runif(1e3*100), ncol = 100))
# big   <- as.data.frame(matrix(runif(1e5*100), ncol = 100))
# 
# 
# write_rds(small, file = "Part 1 - Profiling, Benchmarking/Data/small.RDS")
# write_rds(big, file = "Part 1 - Profiling, Benchmarking/Data/big.RDS")
# write_csv(small, file = "Part 1 - Profiling, Benchmarking/Data/small.csv")
# write_csv(big, file = "Part 1 - Profiling, Benchmarking/Data/big.csv")



# Read in the the small.csv/small.rds and then the big.csv/big.rds files with the following functions and compare their speed.

        # read.csv(file="Part 1 - Profiling, Benchmarking/Data/small.csv")
        # read.table(file="Part 1 - Profiling, Benchmarking/Data/small.csv")
        # readRDS(file = "Part 1 - Profiling, Benchmarking/Data/small.rds")
        # fread(file="Part 1 - Profiling, Benchmarking/Data/small.csv")




# Exercise 2 - Selecting a single value --------------------------------------------------------------

# Example from http://adv-r.had.co.nz/Performance.html
# Try the following ways to select a single value from the iris data.frame

        # iris[2, 1]
        # iris$Sepal.Length[2]
        # iris[[c(1, 2)]]
        # iris[[1]][2]
        # .subset2(iris, 1)[2]


# Try the same with the factor colum (species)

        # iris[2, 5]
        # iris$Species[2]
        # iris[[c(5, 2)]]
        # iris[[5]][2]
        # .subset2(iris, 5)[2]


# Keep in mind ns  = 10^-9 s and us = 10^-6 s





# Exercise 3 - Rows or Columns          --------------------------------------------------------------

# Compare the speed of calculating the row means (rowMeans()) or column means (colMeans()) of the following  matrix

mat <- matrix(runif(1000 * 1000), ncol = 1000)





# Exercise 4 - Data.frames vs Matrices  --------------------------------------------------------------

# Compare the speed of the following functions either creating a matrix or data.frame

d <- function() {
  data.frame(
    x = runif(1:1000),
    y = runif(1:1000)
  )
}
m <- function() {
  matrix(c(runif(1:1000),
           runif(1:1000)), ncol=2)
}


# Also compare the speed of calculating the column means (colMeans) of a matrix vs. a data.frame


mat <- matrix(runif(100*100),ncol=100)
df  <- as.data.frame(mat)




# Exercise 5 - Mean vs Sum/n            --------------------------------------------------------------


# Compare these two ways of calculating the mean of a vector

x <- rnorm(1000)

        # mean(x)
        # sum(x)/length(x)




# Exercise 6 - Ifelse                   --------------------------------------------------------------

# Compare the following functions returning "greater" if x > 0.5 or "less" if not

df <- data.frame(x = runif(1000))


foo_ifelse  <- function(){
  
  ifelse(df$x > 0.5, "greater", "less")
  
}

foo_if_else <- function(){
  
  if_else(df$x > 0.5, "greater", "less")
  
}

foo_apply <- function(){
  
  apply(df, 1, function(x){
    if(x > 0.5){
      "greater"
    } else {
      "less"
    }
  })
  
  
}

foo_for <- function(){
  output <- character(nrow(df))
  
  for(i in 1:nrow(df)){
    if(df$x[i] > 0.5){
      
      output[i] <- "greater"
      
    } else {
      
      output[i] <-"less"
      
    }
  }
  output
}

foo_base <- function(){
  
  output = rep("less",nrow(df))
  output[df$x > 0.5] = "greater"
  output
  
}








# Exercise 7 - & or &&                  --------------------------------------------------------------

# Compare what happens when you use & or &&  in logical statements. What would you expect?

bench::mark(
  "&" = 
          if(5 > 4 & 7 > 8 & 8 < 10){
            "yes"
          } else {
            "no"
          }
  ,
  "&&" = 
          if(5 > 4 && 7 > 8 && 8 < 10){
            "yes"
          } else {
            "no"
          }
  
)





# Exercise 8 - data.table               --------------------------------------------------------------

# Compare these different way of filtering and aggregating with base R, dplyr, or the data.table package


df <- ChickWeight 
dt <- data.table(df)

fun_base <- function(df){
  
 aggregate(x  = df[which(df$Diet == 1),c("weight")],
           by = list(df[which(df$Diet == 1),"Time"]),
           FUN = mean)
  
}

fun_dplyr <- function(df){
  
  df %>% 
    filter(Diet == 1) %>% 
    group_by(Time) %>% 
    summarize(mean_weight = mean(weight),.groups="keep") 
  
}

fun_data.table <- function(dt){
  
  dt[Diet == 1, setNames(mean(weight),"mean_weight") , by = Time] 
  
}
  



# What happens when you have more data ?


larger_df <- df %>% slice(rep(row_number(), 100))
larger_dt <- data.table(larger_df)






# What happens when you have a lot more data ? 


# This might take a little bit longer (~1min)


large_df <- df %>% slice(rep(row_number(), 70000))
large_dt <- data.table(large_df)



bench::mark(
  "base"       = fun_base(large_df),
  "dplyr"      = fun_dplyr(large_df),
  "data.table" = fun_data.table(large_dt),
  check        = FALSE
)



















