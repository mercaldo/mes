##### Detailed Example of MES Algorithm

Suppose it was of interest to sample 50 individuals from a population of 250 that were allocated to each of 10 strata. If 25 individuals belonged to each stratum, then a MES sample would include 5 from each stratum resembling a stratified sampling scheme. If stratum counts vary significantly, the determination of the MES sample is not as straightforward. The figure below graphically summarizes the MES algorithm in a situation where stratum counts vary between 0 and 75. Four iterations of the MES algorithm were required to determine the MES stratum counts. Since there were no subjects assigned to stratum 1, sampled counts did not change at the conclusion of the first iteration. Iteration 2 resulted in 1 being added to strata 2-10 followed by 3 being added to strata 3-10 after iteration 3. To achieve the desired sample size of 50, counts for strata 5-10 were incremented by 3 followed by the random removal of 1, in this case from stratum 5, during iteration 4. MES schemes are not necessarily unique and thus alternative schemes could also be obtained by removing 1 from any strata between 5 and 10. Shannon's entropy (also called information or diversity index) is used to quantify the qualitative variation of the sample.  


##### Installation instructions
* Install R (see http://cran.fhcrc.org)
* Open R and install and load both the devtools and mes libraries by typing the following:
```r
install.packages('devtools',repos='http://cran.us.r-project.org')
library(devtools)
install_github('mercaldo/mes')
library(mes)
```
##### R Example
```r
set.seed(1) 
dat <- rpois(1000, lambda=1)
table(dat)

## dat
##   0   1   2  3  4 6 7 
## 364 378 164 72 20 1 1
```
Suppose it is of interest to obtain an MES sample of size 50
```r
(out <- mes(dat, N=50, seed=1, ix=TRUE))

##   strata freq mes
##1       0  364  10
##2       1  378  10
##3       2  164   9
##4       3   72  10
##5       4   20   9
##6       6    1   1
##7       7    1   1

attr(out, 'entropy')
##   max_entropy rs_entropy mes_entropy
## 1    2.807355   1.895108    2.509526
```
The mes column of the out object summarizes the frequencies to sample such that the overall entropy (Shannon's information or diversity index) is maximized. Random sampling mes individuals per stratum can be performed to identify the final sample. Entropy estimates are also computed for the ideal scenario (when there are enough individuals to sample from each stratum) and under random and maximum entropy sampling.

If the ix argument is TRUE, then we can simply extract the indicies from the out object.  Note, ix=TRUE only works when raw data is supplied to the mes function (see ?mes for additional details). 
```r
ix <- attr(out, 'ix')
cbind(ix[1:10,],ix[11:20,],ix[21:30,],ix[31:40,],ix[41:50,])

##    strata  ix strata  ix strata  ix strata  ix strata  ix
## 1       0  73      1 179      2  15      3 250      4 306
## 2       0 197      1 365      2  95      3 410      4 331
## 3       0 221      1 371      2 251      3 492      4 355
## 4       0 638      1 485      2 330      3 570      4 411
## 5       0 678      1 614      2 387      3 609      4 547
## 6       0 698      1 687      2 388      3 611      4 880
## 7       0 906      1 729      2 489      3 701      4 969
## 8       0 914      1 731      2 595      3 759      4 971
## 9       0 951      1 911      2 832      3 808      6 780
## 10      0 999      1 979      3 194      4  18      7 989
```
