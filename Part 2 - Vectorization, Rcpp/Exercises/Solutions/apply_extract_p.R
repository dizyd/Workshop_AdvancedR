#### Load data ####

x <- read.csv("../Data/rec_exp.csv")


#### apply() ####

new_binom_test <- function(x, p, alternative, conf.level){
  y <- sum(x)
  n <- length(x)
  binom.test(y, n, p, alternative, conf.level)
}

res <- apply(x, 1, new_binom_test, .5, "greater", .95)

str(res) # each element is a named list


#### Extract p-values ####

# two steps
p <- lapply(res, `[[`, "p.value")
p <- unlist(p)

# one step
p <- sapply(res, `[[`, "p.value")
