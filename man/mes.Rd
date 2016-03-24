\name{mes}
\alias{mes}
\title{
Maximum Entropy Sampling
}
\description{
Identify maximum entropy sample from either a vector of categorical data or from a vector of frequencies.
}
\usage{
mes(dat, N, seed = 1, ix = FALSE, hx = FALSE)
}
\arguments{
  \item{dat}{either a vector of data or a vector of frequencies.}
  \item{N}{desired sample size. If dat is a vector of data, then N needs to be less than length(dat). If dat is a vector of frequencies, then N needs to be less than sum(dat).}
  \item{seed}{numeric value representing random seed value.}
  \item{ix}{indicator if indicies of MES sample should be returned. Only applicable if dat is a vector a data and not frequencies.}
  \item{hx}{indicator if iteration history should be returned.}
}
\details{
This function may be used to perform disproportionate stratified sampling.  If dat is a vector a categorical data, such as strata values, then this function may be used to identify how many (and which) subjects to sample to maximize the entropy of the strata variable. 
}
\value{
a data frame whose columns contain names of data (strata), observed frequencies (freq) and corresponding MES frequencies (mes).  To obtain an MES sample, one may randomly sample mes individuals from each stratum. Total counts and Shannon entropy values (maximum and observed) are also returned as separate attributes. If ix=TRUE or hx=TRUE, then additional attributes are returned. 
}

\author{
Nathaniel Mercaldo
}
\note{
ix option may only be used when dat is a vector of data (instead of frequencies).  
}

\examples{
set.seed(1) 
dat <- rpois(1000, lambda=1)
out <- mes(dat, N=100, seed=1, ix=TRUE, hx=TRUE)

# Observed and MES frequencies
out

# Totals and entropy
attr(out, 'totals')
attr(out, 'entropy')

# Indicies of MES sample where indicies correspond to row numbers of dat 
head(attr(out,'ix'), n=5)

# Iteration history; note that the MES sample is not necessarily unique. seed argument 
# is used for reproducibility, but other mes samples could be selected randomly selecting 
# 3 individuals from strata 0-4 (iteration 7).
attr(out, 'hx')

mes(table(dat), N=100, seed=1)  # using frequencies instead of raw data, same as above
mes(table(dat), N=100, seed=10) # a different seed may result in a slightly different MES sample.

attr(mes(dat, N=100, seed=10),'entropy')  # different samples, but same entropy values
attr(mes(dat, N=100, seed=1),'entropy')
}

\keyword{ H.se }
