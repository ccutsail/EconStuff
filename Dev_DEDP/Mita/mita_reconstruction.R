rm(list = ls())
setwd("/Users/ebayseller/Downloads/")
mita <- read.csv("mitaData.csv")
mitaData <- mita
install.packages("sandwich")
install.packages("lmtest")
library(lmtest)
library(sandwich)

get_CL_vcov <- function(model, cluster){
  
  M <- length(unique(cluster))
  N <- length(cluster)
  K <- model$rank
  dfc <- (M/(M-1))*((N-1)/(N-K))
  uj <- apply(estfun(model),2,function(x) tapply(x,cluster,sum))
  vcovCL <- dfc*sandwich(model, meat=crossprod(uj)/N)
  return(vcovCL)
  
}



get_CL_df <- function(model, cluster){
  
  M <- length(unique(cluster)) 
  df=M-1
  return(df)
  
}

# This is not the only way of solving this problem. In fact, the problem suggests a different method for clustering standard errors.

rm(list=ls())
cat("\014")  

# packages and libraries
library(AER)
library(multiwayvcov)
library(lmtest)

# Load dataset 
mitaData<-read.csv("~/Desktop/mitaData.csv")

# generate long and lat vars and monomials of degree <=3
x<-mitaData$x
y<-mitaData$y

x2<-x^2
y2<-y^2
xy<-x*y
x3<-x^3
y3<-y^3
x2y<-x^2*y
xy2<-x*y^2
mitaData<-data.frame(mitaData,x2,y2,xy,x3,y3,x2y,xy2)

form_mita_ll<-lhhequiv~pothuan_mita+x+y+x2+y2+xy+x3+y3+x2y+xy2+elv_sh+slope+infants+children+adults+bfe4_1+bfe4_2+bfe4_3

for (dist in c(100,75,50)) {
  # restrict sample
  mitaData_dist<-mitaData[which(mitaData$d_bnd<dist),]
  # regress and test
  fit<-lm(formula=form_mita_ll,data=mitaData_dist)
  print(coeftest(fit,cluster.vcov(fit,mitaData_dist$district)))
}

# distances to potosi monomials
dpot<-mitaData$dpot
dpot2<-dpot^2
dpot3<-dpot^3
mitaData<-data.frame(mitaData,dpot2,dpot3)

form_mita_dp<-lhhequiv~pothuan_mita+dpot+dpot2+dpot3+elv_sh+slope+infants+children+adults+bfe4_1+bfe4_2+bfe4_3

for (dist in c(100,75,50)) {
  # restrict sample
  mitaData_dist<-mitaData[which(mitaData$d_bnd<dist),]
  # regress and test
  fit<-lm(formula=form_mita_dp,data=mitaData_dist)
  print(coeftest(fit,cluster.vcov(fit,mitaData_dist$district)))
}
