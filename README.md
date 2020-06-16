# Workshop: Advanced R

This repository contains the materials for the workshop **Advanced R** at the SMiP graduate school in Mannheim, Germany. 

The workshop consists of three parts:

- Introduction to Benchmarking &  Profiling
- Introduction to Vectorization & the Power of C++ with Rcpp
- Introduction to Parallelization


The following code can be used to install the packages used in this workshop:

```r
wanted.packages <- c("tidyverse","devtools","tictoc","benchmarkme","bench","data.table","foreach","doSNOW","Rcpp")
  
# Check what packages need to be installed
new.packages <- wanted.packages[!(wanted.packages %in% installed.packages()[,"Package"])]
  
 # install the not yet installed but required packages and load them
if(length(new.packages)) install.packages(new.packages,dependencies = TRUE)
sapply(wanted.packages, require, character.only = TRUE)
```

You should also install Rtools

see https://cran.r-project.org/bin/windows/Rtools/ 

or https://www.rdocumentation.org/packages/installr/versions/0.22.0/topics/install.Rtools



**Note:** The workshop is based on R 4.0.0. 

