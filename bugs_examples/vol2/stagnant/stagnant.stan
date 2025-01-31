// Change point model with very poor parameterization from BUGS, vol 2

// Bradley P. Carlin; Alan E. Gelfand; Adrian F. M. Smith.
// Hierarchical Bayesian Analysis of Changepoint Problems
// Applied Statistics, Vol. 41, No. 2. (1992), pp. 389-405.
//
// In these data, X represents the logarithm of the flow rate of
// water down an inclined channel (grams per centimetre per second) 
// and Y represents the logarithm of the height of the stagnant
// surface layer (centimetres) for different surfactants.

data {
  int<lower=0> N;
  array[N] real x;
  array[N] real Y;
}
parameters {
  real<lower=0> sigma;
  real<lower=0> alpha;
  array[2] real beta;
  simplex[N] theta;
}
model {
  // local variables
  array[N] real log_probs;
  array[N] real mu;
  
  // priors
  theta ~ dirichlet(rep_vector(0.01, N));
  alpha ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma ~ cauchy(0, 5);
  
  // mixture likelihood
  for (k in 1 : N) {
    for (n in 1 : N) {
      mu[n] = alpha + ((n <= k) ? beta[1] : beta[2]) * (x[n] - x[k]);
    }
    log_probs[k] = log(theta[k]) + normal_lpdf(Y | mu, sigma);
  }
  target += log_sum_exp(log_probs);
}
