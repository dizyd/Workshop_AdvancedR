library(Rcpp)
library(bench)



# Some tips :
# - y += x[i] is equivalent to y = y + x[i]
# - x.size()  gives you the size of vector n
# - m.ncol() and m.nrow() give you the number of rows and columns of a matrix
# - Each vector has an equivalent matrix, e.g.,  NumericVector - NumericMatrix
# - You can define vectors of length n with name xx as: NumericVector xx(n)
# - You index matrix elements with (,) instead of [,]


# 1. Sum             ---------------------------------------------------------------------

# 1) Write a Rcpp-function which calculates the sum of a vector



cppFunction('double sumC(NumericVector x) {








}')



# This is the equivalent R function

sum_for_r <- function(x){
  
  n     <- length(x) 
  total <- 0
  
  for(i in 1:n){
    
    total = total + x[i]
    
  }
  
  return(total)
}

# 2) compare your Rcpp Sum function to the following R-functions

x <- runif(1e6)

bench::mark(
  "sum_for"  = sum_for_r(x),
  "sum"      = sum(x),
  "sum_Rcpp" = sumC(x)
)



# 2. Mean            --------------------------------------------------------------------

# 1) Write a Rcpp-function which calculates the sum of a vector

cppFunction('double meanC(NumericVector x) {
 
 
 
 
 
 
 
 
 
 
}')



# This is the equivalent R function

mean_for_r <- function(x){
  
  n     <- length(x) 
  total <- 0
  
  for(i in 1:n){
    
    total = total + x[i]
    
  }
  
  m <- total/n
  
  return(m)
}

# 2) compare your Rcpp Sum function to the following R-functions

x <- runif(1e6)

bench::mark(
  "mean_for"  = mean_for_r(x),
  "mean"      = mean(x),
  "mean_Rcpp" = meanC(x)
)



# 3. Linear Additive ----------------------------------------------------------

# 1) Write an Rcpp -function which computes the linear additive combination for each 
#    row of val with the given weights w, i.e.:
#    res = 25 + 10*val[,2]+12*val[,3]+13*val[,4]+14*val[,5]+16*val[,6]

val  <- matrix(round(runif(1000)),ncol=5)
w    <- c(25,10,12,13,14,16)



cppFunction("NumericVector ladd_Rcpp(NumericMatrix val, NumericVector w) {











}")


# 2) Compare this with these to R equivalent functions

ladd_Rfor <- function(val,w) {
  
  nCols <- ncol(val)
  nRows <- nrow(val)
  
  res <- vector(mode="integer",length=nRows)
  
  for(row in 1:nRows){
    
    summe = w[1]
    
    for(col in 1:nCols){
      
      summe = summe + val[row,col]*w[col+1]
      
      
    }
    
    res[row] = summe
    
  }
  
  return(res)
}

ladd_R    <- function(val,w) {
  res <- w[1]+rowSums(t(w[-1]*t(val)))
  return(res)
}


bench::mark(
  "ladd_Rfor" = ladd_Rfor(val,w),
  "ladd_R"    = ladd_R(val,w),
  "ladd_Rcpp" = ladd_Rcpp(val,w)
)




