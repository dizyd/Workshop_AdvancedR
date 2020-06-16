#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector seqC(int x, int y) {
  
  int len = y - x + 1;
  NumericVector out(len);
  
  for(int i = 0; i < len; i++) {
    out[i] = x;
    x++;
  }
  return out;
}
