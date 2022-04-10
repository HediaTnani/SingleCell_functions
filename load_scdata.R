
## load single cell data 

load_scdata <- function (dir, workers) {
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
    dirname <- dir
    in.list <- list.files(path=dirname, recursive = F, full.names = T) %>% sort()
    in.list
    samples.ls <- in.list %>% furrr::future_map( ~ paste0(.x,"/filtered_feature_bc_matrix"))
    names(samples.ls) <- sapply(in.list, basename) %>% purrr::set_names() 
    seurat.ls <- samples.ls %>% furrr::future_map( ~ Read10X(.x)) %>% furrr::future_map( ~ CreateSeuratObject(.x,min.features = 100), project = names(samples.ls))
    return(seurat.ls)
  }else {
    message(paste("Number of cores available:", availableCores()))
    ncores = workers  
    message(paste("Using:", workers, "Cores"))
    plan("multicore", workers = ncores)
    #options(future.globals.maxSize = 8000 * 1024 ^ 5)
    options(future.globals.onReference = "ignore")
    dirname <- dir
    in.list <- list.files(path=dirname, recursive = F, full.names = T) %>% sort()
    in.list
    samples.ls <- in.list %>% furrr::future_map( ~ paste0(.x,"/filtered_feature_bc_matrix"))
    names(samples.ls) <- sapply(in.list, basename) %>% purrr::set_names() 
    seurat.ls <- samples.ls %>% furrr::future_map( ~ Read10X(.x)) %>% furrr::future_map( ~ CreateSeuratObject(.x,min.features = 100), project = names(samples.ls))
    return(seurat.ls)
  }
}

