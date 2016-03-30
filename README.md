##### Installation instructions
* Install R (see http://cran.fhcrc.org)
* After R has been installed, open R and install and load both the devtools and mes libraries by typing the following:
```r
install.packages('devtools',repos='http://cran.us.r-project.org')
library(devtools)
install_github('mercaldo/mes')
library(mes)
```
##### Example
```r
set.seed(1) 
dat <- rpois(1000, lambda=1)
table(dat)
```
