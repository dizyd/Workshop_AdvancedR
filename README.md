# Workshop: Advanced R

This repository contains the materials for the workshop **Advanced R** at the SMiP graduate school in Mannheim, Germany. 

The workshop consists of three parts:

- Introduction to Benchmarking &  Profiling
- Introduction to Vectorization & the Power of C++ with Rcpp
- Introduction to Parallelization


The following code can be used to install the packages used in this workshop:

```r
wanted.packages <- c("tidyverse","devtools","tictoc","shiny","benchmarkme","bench","data.table")
  
# Check what packages need to be installed
new.packages <- wanted.packages[!(wanted.packages %in% installed.packages()[,"Package"])]
  
 # install the not yet installed but required packages and load them
if(length(new.packages)) install.packages(new.packages,dependencies = TRUE)
sapply(wanted.packages, require, character.only = TRUE)
```



**Note:** The workshop is based on R 4.0.0. 

