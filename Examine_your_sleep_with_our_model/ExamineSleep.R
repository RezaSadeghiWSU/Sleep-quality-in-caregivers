########### load the trained model
##sleep quality model
load("C:/Users/Reza Sadeghi/Desktop/Sleep-quality-in-caregivers-master/Sleep-quality-in-caregivers-master/Final models/Final sleep quality models.RData")

##feeling refreshed model
#load("C:/Users/Reza Sadeghi/Desktop/Sleep-quality-in-caregivers-master/Sleep-quality-in-caregivers-master/Final models/Final feeling refreshed models.RData")

########### load test data
# The address of E4 data
root="C:\\Users\\Reza Sadeghi\\Desktop\\Sleep-quality-in-caregivers-master\\Sleep-quality-in-caregivers-master\\Examine_your_sleep_with_our_model\\";
numberPerson = 1
numberWeek = 2
numberDay = 7
person=c(1:numberPerson)
week=c(1:numberWeek)
day=c(1:numberDay)
signal=list('ACC','BVP','EDA','HR','IBI','Temp')
data=list(person,week,day,signal)


data <- vector(mode = "list", length = numberPerson)
for (p_i in 1:numberPerson){
  data[[p_i]] <- vector(mode="list", length = numberWeek)
  for (w_i in 1:numberWeek){
    data[[p_i]][[w_i]] <- vector(mode="list", length = numberDay)
    for (d_i in 1:numberDay){
      data[[p_i]][[w_i]][[d_i]] <- structure(vector(mode="list", length = 6), names= signal)
    }
  }
}

for (p_i in 1:numberPerson){
  for (w_i in 1:numberWeek){
    for (d_i in 1:numberDay){
      possibleError <- tryCatch({
        direction=paste(root,'Data\\','Participant ',as.character(p_i),'\\Week ', as.character(w_i),'\\',as.character(d_i), sep = '')
        setwd(direction)
        Flage<<-TRUE
      },error= function(e){
        print("There is no such directory")
        print(direction)
        Flage<<-FALSE
      })
      if(inherits(possibleError, "error")) next
      #setwd("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset\\Dataset\\Participant 1\\Week 1\\1")
      if(!Flage)
      {
        next
      }
      print(direction)
      ACC <- read.csv("ACC.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$ACC <- ACC
      
      BVP <- read.csv("BVP.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$BVP <- BVP
      
      EDA <- read.csv("EDA.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$EDA <- EDA
      
      HR <- read.csv("HR.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$HR <- HR
      
      IBI <- read.csv("IBI.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$IBI <- IBI
      
      Temp <- read.csv("Temp.csv",header = F,as.is = T)
      data [[p_i]][[w_i]][[d_i]]$Temp <- Temp
    }
  }
}

########### computing the features
# Creating a null data frame for signal-based features
`Particiapnt #` <- NULL
for (p_i in 1:numberPerson) {
  `Particiapnt #` <- c(`Particiapnt #`,rep(p_i,numberWeek*numberDay))
}

Week <- NULL
for (p_i in 1:numberPerson){
  for (w_i in 1:numberWeek){
    Week <- c(Week, rep(w_i,numberDay))
  }
}

`Survey Number` <- NULL
for (p_i in 1:numberPerson){
  for (w_i in 1:numberWeek){
    `Survey Number` <- c(`Survey Number`, c(1:numberDay))
  }
}

test <- data.frame(`Particiapnt #`,Week,`Survey Number`,stringsAsFactors = FALSE)
colnames(test)<- c('Particiapnt #','Week','Survey Number')

#>>> Feature computation
test$swsLengthHR <- NA
test$swsTimeHR <- NA
test$swsLengthT <- NA
test$swsTimeT <- NA
test$decreasePercentageT <- NA
test$swsTimeM <- NA
test$swsLengthM <- NA
test$decreasePercentageM <- NA
test$amountAsleep <- NA
test$amountAwake <- NA
test$sleepEfficiency <- NA
test$timesAwoken <- NA
test$epochCapacity <- NA
test$epochPeak <- NA
test$epochPeakCounter <- NA
test$stormPeak <- NA
test$largestStorm <- NA
test$timesEdaStorm <- NA
test$meanEdaStorm <- NA
test$lengthEdaStorm <- NA

#>>>>>>> connecting to the local matlab for EDA features
# load the required functions
source(paste(root,'ACC_Sleep.R', sep = ''))
source(paste(root,'EDA.R', sep = ''))
source(paste(root,'HRV_SWS.R', sep = ''))
source(paste(root,'Temp_Sleep.R', sep = ''))

#install.packages("R.matlab")
library(R.matlab)
Matlab$startServer()
matlab <- Matlab()
isOpen <- open(matlab)
print(matlab)

for (p_i in 1:numberPerson){
  for (w_i in 1:numberWeek){
    for (d_i in 1:numberDay){
      
      #>>>>>>>>>Computing the SWS drived from HRV
      print(paste('participant:',p_i, 'weak:',w_i,'day:', d_i))
      input<-data[[p_i]][[w_i]][[d_i]]$IBI
      if(is.null(input)){
        print("no data is recorded")
        next
      }
      input <- input[2:length(input[,1]),]# removing the the unwanted header
      sws<-HRV_SWS(input)
      test$swsLengthHR[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- sws[[1]]
      test$swsTimeHR[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- sws[[2]]
      
      #>>>>>>>>>Computing the temperture trend from the data
      input <- data[[p_i]][[w_i]][[d_i]]$Temp
      input <- input[3:length(input[,1]),1]# removing the the unwanted header
      temp<-Temp_Sleep(input)
      test$swsLengthT[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- temp[[1]]
      test$swsTimeT[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- temp[[2]]
      test$decreasePercentageT[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- temp[[3]]
      
      #>>>>>>>>>Computing the movement trend from the data
      input <- data[[p_i]][[w_i]][[d_i]]$ACC
      input <- input[3:length(input[,1]),]# removing the the unwanted header
      ACC<-ACC_Sleep(input)
      test$swsLengthM[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- ACC[[1]]
      test$swsTimeM[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- ACC[[2]]
      test$decreasePercentageM[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- ACC[[3]]
      #>>>>>>>>>Importing the EDA features catched from the matlab files
      input1 <- data[[p_i]][[w_i]][[d_i]]$ACC
      input2 <- data[[p_i]][[w_i]][[d_i]]$EDA
      EDA_sleep<-EDA(input1, input2)
      test$amountAsleep[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$amountAsleep
      test$amountAwake[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$amountAwake
      test$sleepEfficiency[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$sleepEfficiency
      test$timesAwoken[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$timesAwoken
      test$epochCapacity[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$epochCapacity
      test$epochPeak[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$epochPeak
      test$epochPeakCounter[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$epochPeakCounter
      test$stormPeak[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$stormPeak
      test$largestStorm[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$largestStorm
      test$timesEdaStorm[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$timesEdaStorm
      test$meanEdaStorm[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$meanEdaStorm
      test$lengthEdaStorm[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i)] <- EDA_sleep$lengthEdaStorm
      
    }
  }
}

close(matlab)

########### Prediction
#Did you wake up feeling rested?
#0)NO 1)Yes

#I would rate the overall quality of my sleep as
# 0)Very good     1) Fairly good    2) Okay    3) Fairly bad    4) Bad

## Prediction of one by one of the nights
for (i in 1:dim(test)[1]) {
  print(test[i,c(1:3)])
  try(print(predict(fit.rf, test[i,4:dim(test)[2]])))
}

########### Feature analysis
#Select a record from test data
p_i=1
w_i=1#2
d_i=1#7
#Heart rate variability
selectedFeatures <- c("swsLengthHR","swsTimeHR")
df <- fit.rf$trainingData[,selectedFeatures]
boxplot(df,ylab ="Values",main = "Heart rate variability Features",
        col = c('blue','green'),outcol="black",outpch=20)
stripchart(test[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i),selectedFeatures],
           vertical = T, method = "jitter", add=T, pch=20, col='red',cex =3)

#Electrodermal activity
selectedFeatures <- c("epochCapacity","epochPeak","epochPeakCounter","stormPeak","largestStorm","timesEdaStorm","meanEdaStorm","lengthEdaStorm")
df <- fit.rf$trainingData[,selectedFeatures]
boxplot(df,xaxt = "n",ylab ="Values",main = "Electrodermal activity Features",
        col = rainbow(length(unique(selectedFeatures))),outcol="black",outpch=20)

## Draw x-axis without labels.
axis(side = 1, labels = FALSE)

## Draw the x-axis labels.
text(x = 1:length(selectedFeatures),
     ## Move labels to just below bottom of chart.
     y = par("usr")[3] - 0.45,
     ## Use names from the data list.
     labels = selectedFeatures,
     ## Change the clipping region.
     xpd = NA,
     ## Rotate the labels by 35 degrees.
     srt = 30,
     ## Adjust the labels to almost 100% right-justified.
     adj = 0.965,
     ## Increase label size.
     cex = 1.2)

stripchart(test[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i),selectedFeatures],
           vertical = T, method = "jitter", add=T, pch=20, col='red',cex =3)

#Body movement
selectedFeatures <- c("timesAwoken","sleepEfficiency","amountAwake","amountAsleep","swsTimeM","swsLengthM","decreasePercentageM")
df <- fit.rf$trainingData[,selectedFeatures]
boxplot(df,xaxt = "n",ylab ="Values",main = "Body movement Features",
        col = rainbow(length(unique(selectedFeatures))),outcol="black",outpch=20)

## Draw x-axis without labels.
axis(side = 1, labels = FALSE)

## Draw the x-axis labels.
text(x = 1:length(selectedFeatures),
     ## Move labels to just below bottom of chart.
     y = par("usr")[3] - 0.45,
     ## Use names from the data list.
     labels = selectedFeatures,
     ## Change the clipping region.
     xpd = NA,
     ## Rotate the labels by 35 degrees.
     srt = 30,
     ## Adjust the labels to almost 100% right-justified.
     adj = 0.965,
     ## Increase label size.
     cex = 1.2)

stripchart(test[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i),selectedFeatures],
           vertical = T, method = "jitter", add=T, pch=20, col='red',cex =3)

#Temperature
selectedFeatures <- c("swsLengthT","swsTimeT","decreasePercentageT")
df <- fit.rf$trainingData[,selectedFeatures]
boxplot(df,xaxt = "n",ylab ="Values",main = "Temperature Features",
        col = rainbow(length(unique(selectedFeatures))),outcol="black",outpch=20)

## Draw x-axis without labels.
axis(side = 1, labels = FALSE)

## Draw the x-axis labels.
text(x = 1:length(selectedFeatures),
     ## Move labels to just below bottom of chart.
     y = par("usr")[3] - 0.45,
     ## Use names from the data list.
     labels = selectedFeatures,
     ## Change the clipping region.
     xpd = NA,
     ## Rotate the labels by 35 degrees.
     srt = 30,
     ## Adjust the labels to almost 100% right-justified.
     adj = 0.965,
     ## Increase label size.
     cex = 1.2)

stripchart(test[which(test$`Particiapnt #`==p_i & test$Week==w_i & test$`Survey Number`==d_i),selectedFeatures],
           vertical = T, method = "jitter", add=T, pch=20, col='red',cex =3)

######## Comparing the trends of the extracted features
plot.ts(test[,c(12:14)],xlab='nights',main='The trends of signal-based features in different nights')
