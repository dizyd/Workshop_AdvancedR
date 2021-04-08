library(plyr)
files <- list.files(path = "../Data/sprt/", pattern = "*.RData", full.names = TRUE)
data <- ldply(files, function(x) get(load(x)))


##### An Alternative

# There is actually an even more efficient way
# Based on the purrr package 

library(purrr)
data <- map_df(files, function(x) get(load(x)))


# Some Benchmarking

results <- bench::mark(
  plyr = ldply(files, function(x) get(load(x))),
  purrr = map_df(files, function(x) get(load(x))),
  iterations = 10
)

results[, 1:8]


