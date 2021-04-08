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

# even better (when res becomes larger)
p <- vapply(res, `[[`, 0, "p.value")


#### The best solution

# Once again, the best solution might be to look for a better alternative
# We only want p-values, why use binom.test()?

k <- rowSums(x)
p <- pbinom(k - 1, ncol(x), .5, lower.tail = FALSE) # k - 1 because p(K > k)


#### Some benchmarking

results <- bench::mark(
  apply = {
    res <- apply(x, 1, new_binom_test, .5, "greater", .95)
    p <- vapply(res, `[[`, 0, "p.value")
  },
  pbinom = {
    k <- rowSums(x)
    p <- pbinom(k - 1, ncol(x), .5, lower.tail = FALSE)
  },
  iterations = 100
)

results[, 1:8]

results <- bench::press(
  n = c(100, 1000),
  {
    x <- data.frame(matrix(rbinom(n * 100, 1, .5),
                           ncol = n))
    bench::mark(
      apply = {
        res <- apply(x, 1, new_binom_test, .5, "greater", .95)
        p <- vapply(res, `[[`, 0, "p.value")
      },
      pbinom = {
        k <- rowSums(x)
        p <- pbinom(k - 1, ncol(x), .5, lower.tail = FALSE)
      },
      iterations = 100
    )
  }
)

results[, 1:8]
