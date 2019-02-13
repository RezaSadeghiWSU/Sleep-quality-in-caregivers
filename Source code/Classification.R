# Author: Reza Sadeghi
# Email: reza@knoesis.org; sadeghi.2@wright.edu
# Date: 4/24/2018
# Description: Classification of data

#install.packages("randomForest")
#install.packages("cart")
#install.packages(psych)
#install.packages(RSNNS)

require(caret)
require(randomForest)
require(psych)
require(RSNNS)
require(corrplot)
library(Hmisc)
library(mlbench)
#library(readxl)
#>>>>>>>>>>>>>>>>>>>>>>> Load the data
#>> loading data
#survey<-read_xlsx("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset\\Output.xlsx")
survey <- readRDS("C:/Users/Reza Sadeghi/Desktop/Dementia Caregiver Sleep Dataset/survey.rds")

#>> Tiredness
 FeatureSet <- survey[,c("swsLengthHR","swsTimeHR","swsLengthT","swsTimeT","decreasePercentageT","swsTimeM","swsLengthM","decreasePercentageM","amountAsleep","amountAwake","sleepEfficiency","timesAwoken","epochCapacity","epochPeak","epochPeakCounter","stormPeak","largestStorm","timesEdaStorm","meanEdaStorm","lengthEdaStorm","Question 10")]
#>> Sleep Quality
#FeatureSet <- survey[,c("swsLengthHR","swsTimeHR","swsLengthT","swsTimeT","decreasePercentageT","swsTimeM","swsLengthM","decreasePercentageM","amountAsleep","amountAwake","sleepEfficiency","timesAwoken","epochCapacity","epochPeak","epochPeakCounter","stormPeak","largestStorm","timesEdaStorm","meanEdaStorm","lengthEdaStorm","Question 9")]
#FeatureSet$`Question 9`[which(FeatureSet$`Question 9`==4)]<- "3"

#>> dataset naming
dataset <- FeatureSet
#colnames(dataset)[1]<- "Label"
colnames(dataset)[length(dataset)]<- "Label"

#>>>>>>>>>>>>>>>>>>>>>>> Clean the data
# get rid of columns where for ALL rows the value is NA
dataset <- dataset[, colSums(is.na(dataset))<nrow(dataset)]
# unlist every columns
for (i in 1:length(dataset)){
  if(class(dataset[,i])=='list'){
    dataset[,i]<-unlist(dataset[,i])
  }
}
## Impute missing values with mean of each column in respect to each label group
#Labels=unique(dataset$Label)
#for (coln in 1:length(dataset)){
#  for (groupj in 1:length(Labels)){
#    MMean=mean(na.omit(dataset[which(dataset$Label==Labels[groupj]),coln]))
#    #NA enteties
#    dataset[is.na(dataset[which(dataset$Label==Labels[groupj]),coln]),coln]<-MMean
#    #Inf enteties
#    dataset[is.infinite(dataset[which(dataset$Label==Labels[groupj]),coln]),coln]<-MMean
#  }
#}
# converting labels to factors
dataset$Label<-as.factor(dataset$Label)

for(coln in 1:length(dataset)){
  dataset[which(is.na(dataset[,coln])==1),coln]<-mean(na.omit(dataset[,coln]))
}

#>>>>>>>>>>>>>>>>>>>>>>> Correlation coefficient
#Temp<-as.data.frame(dataset[,c(predictors(results),"Label")])
Temp<-as.data.frame(dataset)
Temp$Label<-as.numeric(Temp$Label)
Temp <- as.matrix(Temp)
#colnames(Temp)<-1:length(c(predictors(results),"Label"))
colnames(Temp)<-1:length(dataset)

cor <- rcorr(as.matrix(Temp), type="pearson")
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot.mixed(cor$r)

#>>>>>>>>>>>>>>>>>>>>>>> Balanced vs. Imbalanced
x <- dataset[,(1:20)]
y <- dataset$Label
#>> balancing the sleep quality
set.seed(600)
#A <- caret::upSample(x, y, list = FALSE, yname = "Class")
#y <- A[,"Class"]
#x <- A[-length(A)]
#dataset <- A
#colnames(dataset)[length(dataset)]<- "Label"
#>>>>>>>>>>>>>>>>>>>>>>> Feature selection using RF-RFE
#searching for random number
# seed <- sample(500,10)
# A <- rep(0,10)
# for (i in 1:10){
#   set.seed(seed[i])
#   # define the control using a random forest selection function
#   control <- rfeControl(functions=rfFuncs, method="cv", number=10)
#   # run the RFE algorithm
#   results <- rfe(x, y, sizes=c(1:20), rfeControl=control)
#   A[i]<- max(results$results$Accuracy)
# }

#>>> RF
seed=399
set.seed(seed)
# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
resultsRF <- rfe(x, y, sizes=c(1:20), rfeControl=control)
# summarize the results
print(resultsRF)
# list the chosen features
predictors(resultsRF)
# plot the results
plot(resultsRF, type=c("g", "o"))
max(resultsRF$results$Accuracy)

#>>> NB
set.seed(seed)
# define the control
control <- rfeControl(functions=nbFuncs, method="cv", number=10)
# run the RFE algorithm
resultsNB <- rfe(x, y, sizes=c(1:20), rfeControl=control)
# summarize the results
print(resultsNB)
# list the chosen features
predictors(resultsNB)
# plot the results
plot(resultsNB, type=c("g", "o"))
max(resultsNB$results$Accuracy)

#>>> bagged trees
set.seed(seed)
# define the control
control <- rfeControl(functions=treebagFuncs, method="cv", number=10)
# run the RFE algorithm
resultsBT <- rfe(x, y, sizes=c(1:20), rfeControl=control)
# summarize the results
print(resultsBT)
# list the chosen features
predictors(resultsBT)
# plot the results
plot(resultsBT, type=c("g", "o"))
max(resultsBT$results$Accuracy)

#>>>>>>>>>>>>>>>>>>>>>>>> Classification
# define training control and metrics for checking the performance
control <- trainControl(method="cv", number=10)
#control <- trainControl(method="repeatedcv", number=10, repeats=10)
#control <- trainControl(method="none")
metric <- "Accuracy"

# Navie Bayes
SelectedDataset<-as.data.frame(dataset[,c(predictors(resultsNB),"Label")])
set.seed(seed)
fit.nb <- caret::train(Label~., data=SelectedDataset, trControl=trainControl(method="cv", number=10), method="nb")
confusionMatrix.train(fit.nb)

# Random Forest
SelectedDataset<-as.data.frame(dataset[,c(predictors(resultsRF),"Label")])
set.seed(seed)
fit.rf <- caret::train(Label~., data=SelectedDataset, method="rf", metric=metric, trControl=control)
confusionMatrix.train(fit.rf)

# Bagged CART
SelectedDataset<-as.data.frame(dataset[,c(predictors(resultsBT),"Label")])
set.seed(seed)
fit.treebag <- caret::train(Label~., data=SelectedDataset, method="treebag", metric=metric, trControl=control)
confusionMatrix.train(fit.treebag)

results <- resamples(list(Naive_Bayes=fit.nb, Random_Forest=fit.rf, Bagged_CART=fit.treebag))
summary(results)

# compare accuracy of models
dotplot(results)