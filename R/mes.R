
H.se <- function(X) { 
  if(any(X==0)) X <- X[X>0]
  p <- X/sum(X) 
  -sum(p * log2(p))
}

mes <- function(dat, N, seed=1, ix=FALSE, hx=FALSE) {
  dat.table <- is.table(dat)
  counts    <- dat
  if(!dat.table) counts <- table(counts)
  if(any(counts<=0)) counts <- counts[counts>0]
  if(ix & dat.table) {stop('Cannot return indicies when supplying counts; Check ix')}
  if(N>=sum(counts)) {stop('Sample size needs to be less than population size; Check N')}
  
  set.seed(seed)
  n_grp  <- length(counts)
  target <- floor(N/n_grp)
  iter   <- 1

  # Step 1: Create target vector = floor(N/n_grp)
  sample_obs   <- rep(target, n_grp)
  count_update <- counts<sample_obs
  sample_obs[count_update] <- counts[count_update]
  remaining2target <- target-sample_obs
  
  hx2 <- c(iter, sample_obs, sum(sample_obs))
  
  # Step 2: Check to see if all strata = target
  if(all(remaining2target==0 & sum(sample_obs)!=N)) {
    # Due to rounding, we may need to randomly select strata s.t. final N is obtained.
    # Not unique, but reproducible using seed argument.
    remaining            <- N - sum(sample_obs)
    remainingcounts      <- counts-sample_obs
    remainingcounts      <- remainingcounts[remainingcounts>0]
    update_i             <- sample(seq(length(remainingcounts)),remaining, replace=FALSE)
    sample_obs[update_i] <- sample_obs[update_i]+1
    remaining_obs        <- counts-sample_obs
    
    hx2 <- rbind(hx2, c(iter+1, sample_obs, sum(sample_obs)))
  } else {
    remaining_obs    <- counts - sample_obs
    add_i            <- which(remaining2target>0)
    remaining2target <- target - sample_obs
    
    sumSampled <- sum(sample_obs)
    
    while( sumSampled<N ) {
      iter <- iter+1
      ## Which strata have subjects left to sample?
      remaining    <- remaining_obs 
      remaining_ii <- which(remaining>0)
      remaining_ii <- remaining_ii[order(remaining[remaining_ii])]
      remaining_01 <- (remaining_obs[remaining_ii]>0)*1 # add 1 at a time (update!)
      
      # How many can we add at this iteration?
      # Since we are adding 1 at each iteration, we just check # of strata with at least 1
      # and compare that to the number needed to be sampled.
      if(sum(remaining_01) > N-sumSampled) {
        remaining_ii <- sample(remaining_ii, N-sumSampled, replace=FALSE)
      }
      sample_obs[remaining_ii] = sample_obs[remaining_ii] + remaining_01[remaining_ii]
      remaining_obs[remaining_ii] = remaining_obs[remaining_ii]-remaining_01[remaining_ii]
      sumSampled = sum(sample_obs)
      hx2 <- rbind(hx2, c(iter, sample_obs, sum(sample_obs)))
    }
  }
  out <- data.frame('original'=counts, 'sampled'=sample_obs)
  colnames(out) <- c('strata','freq','mes')
  
  attr(out, 'totals') <- data.frame('total'=sum(counts),'N'=N, 'mes'= sum(sample_obs))
  attr(out,'entropy') <- data.frame('max_entropy'=log2(sum(counts>0)), 'rs_entropy'=H.se(counts), 'mes_entropy'=H.se(sample_obs))
    
  if(ix) {
    dat2 <- data.frame(seq(length(dat)), dat)
    colnames(dat2) <- c('ix','grp')
    dat2_s <- split(dat2$ix, dat2$grp)
    tmp    <- vector('list',length(dat2_s))
    for(jx in seq(tmp)) {
      if(length(dat2_s[[jx]])==1) dat2_s[[jx]] <- rep(dat2_s[[jx]],2)
      tmp[[jx]] <- data.frame(out$strata[jx], sort(sample(dat2_s[[jx]], out$mes[jx], replace=FALSE)))
    }
    samp_ix <- do.call(rbind, tmp)
    colnames(samp_ix) <- c('strata','ix')
    attr(out,'ix') <- samp_ix
  }
  if(hx) { 
    colnames(hx2) <- c('iteration',names(counts),'total')
    attr(out,'hx') <- hx2
  }
  out
}
