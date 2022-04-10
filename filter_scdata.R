filter_scdata <- function (seurat.ls, proba, workers) {
  require(Seurat)
  require(tidyverse)
  require(magrittr)
  require(future)
  options(future.globals.maxSize = 891289600)
  if(missing(workers)) {
    message(paste("Number of cores available:", availableCores()))
    ncores <- availableCores() - 2  
    message(paste("Using", ncores, "Cores"))
    plan("multicore", workers = ncores)
    #options(future.globals.maxSize = 8000 * 1024 ^ 5)
    options(future.globals.onReference = "ignore")
    minCov=1000 
    #if a sample has a good coverage (>=minCov), then don't set a lower threshold for nCount, it's already pretty good. 
      if(min(seurat.ls$nCount_RNA)>=minCov){
        countLOW=min(seurat.ls$nCount_RNA)
      }else{
        countLOW=quantile(seurat.ls$nCount_RNA, prob=c(0.01))  
      }
    countHIGH=quantile(seurat.ls$nCount_RNA, prob=0.99) 
    featureLOW=quantile(seurat.ls$nFeature_RNA, prob=0.01)
    mitHIGH=round(quantile(seurat.ls$percent.MT, prob=proba))
      
      ##subset
    seurat.ls <- subset(x = seurat.ls, 
                               subset = (nFeature_RNA >= featureLOW) & 
                                 (nCount_RNA >= countLOW)  & 
                                 (nCount_RNA < countHIGH) & 
                                 (percent.MT < mitHIGH))
    return(seurat.ls)
  }else {
    message(paste("Number of cores available:", availableCores()))
    ncores = workers  
    message(paste("Using:", workers, "Cores"))
    plan("multicore", workers = ncores)
    #options(future.globals.maxSize = 8000 * 1024 ^ 5)
    options(future.globals.onReference = "ignore")
    minCov=1000 
      #if a sample has a good coverage (>=minCov), then don't set a lower threshold for nCount, it's already pretty good. 
      if(min(seurat.ls$nCount_RNA)>=minCov){
        countLOW=min(seurat.ls$nCount_RNA)
      }else{
        countLOW=quantile(seurat.ls$nCount_RNA, prob=c(0.01))  
      }
    countHIGH=quantile(seurat.ls$nCount_RNA, prob=0.99) 
    featureLOW=quantile(seurat.ls$nFeature_RNA, prob=0.01)
    mitHIGH=round(quantile(seurat.ls$percent.MT, prob=proba))
      
      ##subset
    seurat.ls <- subset(x = seurat.ls, 
                               subset = (nFeature_RNA >= featureLOW) & 
                                 (nCount_RNA >= countLOW)  & 
                                 (nCount_RNA < countHIGH) & 
                                 (percent.MT < mitHIGH))
    return(seurat.ls)
    }
   
  }


