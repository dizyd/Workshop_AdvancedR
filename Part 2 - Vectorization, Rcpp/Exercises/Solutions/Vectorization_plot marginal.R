library(ggplot2)

#### Functions ####

# likelihood (x|mu)
integrand <- function(mu, x, a, b){
  dnorm(x, mu) * dnorm(mu, a, b)
}

# marginal likelihood (vectorize over x)
marg_lik <- Vectorize(function(x, a, b){
  integrate(integrand, -Inf, Inf, x = x, a = a, b = b)$value
}, "x")


#### Plot Marginal Likelihood ####

a <- 0
b <- 1

ggplot(data.frame(x=0), aes(x)) +
  stat_function(fun = marg_lik, args = list(a = a, b = b),
                xlim = c(-5, 5), lwd = 1, n = 300) +
  scale_x_continuous("X", expand=c(0,0.15)) +
  scale_y_continuous(element_blank(), expand = c(0,0), limits = c(0, .29)) +
  theme_classic() + 
  theme(axis.line.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(color = "black"))
