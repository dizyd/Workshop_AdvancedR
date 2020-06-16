#include <Rcpp.h>
using namespace Rcpp;
using namespace R;


// [[Rcpp::export(".pwr_binom")]]
NumericVector pwr_binom(double l0, double l1, double alpha, double beta, int nLow = 1, int nUp = 1000000){

	NumericVector out(2);
	int n = nLow;
	int c;
	double b;

	do {
		c = R::qbinom(1 - alpha, n, l0, true, false);
		b = R::pbinom(c, n, l1, true, false);
		n++;
	} while (n < nUp && b > beta);

	if (b <= beta)
	{
		out[0] = n - 1;
    	out[1] = c + 1;
	} else
	{
		out = NAN;
	}

	return out;
}

