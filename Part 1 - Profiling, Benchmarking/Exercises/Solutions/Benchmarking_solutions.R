library(tidyverse)
library(tictoc)
library(microbenchmark)
library(benchmarkme)
library(bench)
library(data.table)


##### Benchmarking #####


# Exercise 1 - Reading in Data Files    --------------------------------------------------------------


# small <- matrix(runif(1e3*100),ncol=100)
# big   <- matrix(runif(1e5*100),ncol=100)
# 
# 
# write_rds(small,path="Part 1 - Profiling, Benchmarking/Data/small.RDS")
# write_rds(big,path="Part 1 - Profiling, Benchmarking/Data/big.RDS")



bench::mark(
  "read.csv"   = read.csv(file="Part 1 - Profiling, Benchmarking/Data/small.csv"),
  "read.table" = read.table(file="Part 1 - Profiling, Benchmarking/Data/small.csv"),
  "read.RDS"   = readRDS(file = "Part 1 - Profiling, Benchmarking/Data/small.rds"),
  "fread"      = fread(file="Part 1 - Profiling, Benchmarking/Data/small.csv"),
  check=FALSE
)

bench::mark(
  "read.csv"   = read.csv(file="Part 1 - Profiling, Benchmarking/Data/big.csv"),
  "read.table" = read.table(file="Part 1 - Profiling, Benchmarking/Data/big.csv"),
  "read.RDS"   = readRDS(file = "Part 1 - Profiling, Benchmarking/Data/big.rds"),
  "fread"      = fread(file="Part 1 - Profiling, Benchmarking/Data/big.csv"),
  check=FALSE
)

# Exercise 2 - Selecting a single value --------------------------------------------------------------

# Example from http://adv-r.had.co.nz/Performance.html

# keep in mind ns  = 10^-9 s and us = 10^-6 s

bench::mark(
  "[2, 1]"           = iris[2, 1],
  "$Sepal.Length[2]" = iris$Sepal.Length[2],
  "[[c(1, 2)]]"      = iris[[c(1, 2)]],
  "[[1]][2]"         = iris[[1]][2],
  ".subset2"         = .subset2(iris, 1)[2]
)


# but not try the same with the last column

bench::mark(
  "[2, 5]"           = iris[2, 5],
  "$Species[2]"      = iris$Species[2],
  "[[c(5, 2)]]"      = iris[[c(5, 2)]],
  "[[5]][2]"         = iris[[5]][2],
  ".subset2"         = .subset2(iris, 5)[2],
  check              = FALSE
)


# Exercise 3 - Rows or Columns          --------------------------------------------------------------


mat <- matrix(runif(1000*1000),ncol = 1000)


bench::mark(
  "rowMeans" = rowMeans(mat),
  "colMeans" = colMeans(mat),
  check     = FALSE
)


# Exercise 4 - Data.frames vs Matrices  --------------------------------------------------------------


d <- function() {
  data.frame(
    x = runif(1:1000),
    y = runif(1:1000)
  )
}

# Complete the matrix solution
m <- function() {
  matrix(c(runif(1:1000),
           runif(1:1000)),ncol=2)
}


bench::mark(
    "data.frame" = d(),
    "matrix"     = m(),
    check        = FALSE
)



mat <- matrix(runif(100*100),ncol=100)
df  <- as.data.frame(mat)


bench::mark(
  "data.frame" = colMeans(df),
  "matrix"     = colMeans(mat),
  check        = FALSE
)


# Exercise 5 - Mean vs Sum/n            --------------------------------------------------------------

x <- rnorm(1000)

bench::mark(
  "mean" = mean(x),
  "sum"  = sum(x)/length(x),
  check  = FALSE
)

# Hint: check mean and sum in console


# Exercise 6 - Ifelse                   --------------------------------------------------------------



df <- data.frame(x = runif(1000))



foo_ifelse  <- function(){
  
  ifelse(df$x>0.5,"greater","less")
  
}

foo_if_else <- function(){
  
  if_else(df$x>0.5,"greater","less")
  
}

foo_apply   <- function(){
  
  apply(df,1,function(x){
    if(x>0.5){
      "greater"
    } else {
      "less"
    }
  })
  
  
}

foo_for     <- function(){
  output <- vector(mode="character",length=nrow(df))
  
  for(i in 1:nrow(df)){
    if(df$x[i] > 0.5){
      
      output[i] <- "greater"
      
    } else {
      
      output[i] <-"less"
      
    }
    
  }
  output
  
  
}

foo_base   <- function(){
  
  output = rep("less",nrow(df))
  output[df$x > 0.5] = "greater"
  output
}

bench::mark(
  foo_ifelse(),
  foo_if_else(),
  foo_apply(),
  foo_for(),
  foo_base()
)








# Exercise 7 - & or &&                  --------------------------------------------------------------

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
  

bench::mark(
  "base"       = fun_base(df),
  "dplyr"      = fun_dplyr(df),
  "data.table" = fun_data.table(dt),
  check        = FALSE
)


larger_df <- df %>% slice(rep(row_number(), 100))
larger_dt <- data.table(largeChickens)



bench::mark(
  "base"       = fun_base(larger_df),
  "dplyr"      = fun_dplyr(larger_df),
  "data.table" = fun_data.table(larger_dt),
  check        = FALSE
)


large_df <- df %>% slice(rep(row_number(), 70000))
large_dt <- data.table(largeChickens)



bench::mark(
  "base"       = fun_base(large_df),
  "dplyr"      = fun_dplyr(large_df),
  "data.table" = fun_data.table(large_dt),
  check        = FALSE
)



















