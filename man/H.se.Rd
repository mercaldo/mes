\name{H.se}
\alias{H.se}
\title{
Shannon information entropy
}
\description{
Compute the Shannon information entropy (H statistic)
}
\usage{
H.se(X)
}

\arguments{
  \item{X}{a vector of frequencies.  
}
}

\value{ A numeric value is returned up to -log2(K) where K = the number of unique data values $>0$. }

\author{ Nathaniel Mercaldo }

\note{ See qualvar package for other indicies of qualitative variation. H.se produces same output as qualvar(X)*log2(K).  }

\examples{
set.seed(1) 
dat <- table(rpois(1000, lambda=1))

H.se(dat)

library(qualvar)
HREL(dat)*log2(length(dat))
}

