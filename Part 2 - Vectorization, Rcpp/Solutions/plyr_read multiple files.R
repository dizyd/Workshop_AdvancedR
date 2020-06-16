library(plyr)
files <- list.files(path = "../Data/sprt/", pattern = "*.RData", full.names = TRUE)
data <- ldply(files, function(X) get(load(x)), .progress = "text")