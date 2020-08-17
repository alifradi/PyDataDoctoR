
CramerSelection <- function(data, target){
  library(FSinR)
  cramer_evaluator <- cramer()
  features <- names(data[,names(data) != target])
  x<-cramer_evaluator(data, target, features)
  df = data.frame(Features=names(x), CramerV=x) %>% 
    arrange(desc(CramerV))
  rownames(df)<- NULL
  return(df)
}

BestSubsetSelection_k <- function(data,target , k){
  library(FSinR)
  evaluator <- filterEvaluator('determinationCoefficient')
  directSearcher <- directSearchAlgorithm('selectKBest', list(k=k))
  x <- directFeatureSelection(data, target, directSearcher, evaluator)
  x1<-unlist(x$featuresSelected)
  x2<-unlist(x$valuePerFeature)
  df <- data.frame(Feature = x1, ValuePerFeature = x2)
  return(df)
}
