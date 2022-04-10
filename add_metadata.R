add_metadata <- function (seurat.ls, col1, col2) {
  require(Seurat)
  require(tidyverse)
  require(magrittr)
  if(missing(col1)) {
  seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^MT-", col.name = "percent.MT")
  seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^RP[SL]", col.name = col2)
  return(seurat.ls)
  } else if (missing(col2)) {
    seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^MT-", col.name = col1)
    seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^RP[SL]", col.name = "percent.Ribo")
    return(seurat.ls)
  } else {
    seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^MT-", col.name = col1)
    seurat.ls <- PercentageFeatureSet(object = seurat.ls, pattern = "^RP[SL]", col.name = col2)
    return(seurat.ls)
  }
} 
