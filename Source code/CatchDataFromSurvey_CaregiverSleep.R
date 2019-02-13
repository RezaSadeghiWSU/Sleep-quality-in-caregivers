#Project Name: Studing the Dementia Caregiver Sleep
#File Name: Catch Data From the surveys of caregiver sleep study and cleaning the data
#Author: Reza Sadeghi
#Email: sadeghi.2@wright.edu; reza@knoesis.org
#Ver:1.2
#Last modification:6/17/2018

#>> load E4 data
load("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset\\DataP1_8.RData")

#>> Catching data from surveys
library(readxl)
survey<-read_xlsx("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset\\Sleep Survey.xlsx")
#read.csv
#>> Some Nights of data which require extra pre-processing
#(i.e. the device was removed but not turned off, therefore a portion of the data is useless)
# a.)	Participant 7, week 1, night 3
# b.)	Participant 7, week 2, night 4
# c.)	Participant 8, week 1, night 3

# a.)
p_i=7;w_i=1;d_i=3
Temp<-data[[p_i]][[w_i]][[d_i]]$ACC
#par(mar=rep(2,4))
#plot.ts(Temp[3:length(Temp[,1]),1])
time_start=survey$`Question 1`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
time_finish=survey$`Question 3`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
interval=as.integer(difftime(strptime(time_finish,"%H:%M"),strptime(time_start,"%H:%M"),units = "sec"))
#ACC
samplingrate=data[[p_i]][[w_i]][[d_i]]$ACC[2,1]#32
data[[p_i]][[w_i]][[d_i]]$ACC <- data[[p_i]][[w_i]][[d_i]]$ACC[1:(2+interval*samplingrate),]
#BVP
samplingrate=data[[p_i]][[w_i]][[d_i]]$BVP[2,1]#64
data[[p_i]][[w_i]][[d_i]]$BVP <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$BVP[1:(2+interval*samplingrate),])
#EDA
samplingrate=data[[p_i]][[w_i]][[d_i]]$EDA[2,1]#4
data[[p_i]][[w_i]][[d_i]]$EDA <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$EDA[1:(2+interval*samplingrate),])
#HR
samplingrate=data[[p_i]][[w_i]][[d_i]]$HR[2,1]#1
data[[p_i]][[w_i]][[d_i]]$HR <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$HR[1:(2+interval*samplingrate),])
#Temp
samplingrate=data[[p_i]][[w_i]][[d_i]]$Temp[2,1]#1
data[[p_i]][[w_i]][[d_i]]$Temp <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$Temp[1:(2+interval*samplingrate),])
#IBI
Temp<-which(data[[p_i]][[w_i]][[d_i]]$IBI[2:length(data[[p_i]][[w_i]][[d_i]]$IBI[,1]),1]>=interval)
data[[p_i]][[w_i]][[d_i]]$IBI <- data[[p_i]][[w_i]][[d_i]]$IBI[1:(1+Temp[1]),1:2]

# b.)
p_i=7;w_i=2;d_i=4
Temp<-data[[p_i]][[w_i]][[d_i]]$ACC
#par(mar=rep(2,4))
#plot.ts(Temp[3:length(Temp[,1]),1])
time_start=survey$`Question 1`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
time_finish=survey$`Question 3`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
#interval=as.integer(difftime(strptime(time_finish,"%H:%M"),strptime(time_start,"%H:%M"),units = "sec"))
interval=33300
#ACC
samplingrate=data[[p_i]][[w_i]][[d_i]]$ACC[2,1]#32
data[[p_i]][[w_i]][[d_i]]$ACC <- data[[p_i]][[w_i]][[d_i]]$ACC[1:(2+interval*samplingrate),]
#BVP
samplingrate=data[[p_i]][[w_i]][[d_i]]$BVP[2,1]#64
data[[p_i]][[w_i]][[d_i]]$BVP <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$BVP[1:(2+interval*samplingrate),])
#EDA
samplingrate=data[[p_i]][[w_i]][[d_i]]$EDA[2,1]#4
data[[p_i]][[w_i]][[d_i]]$EDA <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$EDA[1:(2+interval*samplingrate),])
#HR
samplingrate=data[[p_i]][[w_i]][[d_i]]$HR[2,1]#1
data[[p_i]][[w_i]][[d_i]]$HR <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$HR[1:(2+interval*samplingrate),])
#Temp
samplingrate=data[[p_i]][[w_i]][[d_i]]$Temp[2,1]#1
data[[p_i]][[w_i]][[d_i]]$Temp <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$Temp[1:(2+interval*samplingrate),])
#IBI
Temp<-which(data[[p_i]][[w_i]][[d_i]]$IBI[2:length(data[[p_i]][[w_i]][[d_i]]$IBI[,1]),1]>=interval)
data[[p_i]][[w_i]][[d_i]]$IBI <- data[[p_i]][[w_i]][[d_i]]$IBI[1:(1+Temp[1]),1:2]

# c.)
p_i=8;w_i=1;d_i=3
Temp<-data[[p_i]][[w_i]][[d_i]]$ACC
#par(mar=rep(2,4))
#plot.ts(Temp[3:length(Temp[,1]),1])
time_start=survey$`Question 1`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
time_finish=survey$`Question 3`[which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)]
#interval=as.integer(difftime(strptime(time_finish,"%H:%M"),strptime(time_start,"%H:%M"),units = "sec"))
interval=28800
#ACC
samplingrate=data[[p_i]][[w_i]][[d_i]]$ACC[2,1]#32
data[[p_i]][[w_i]][[d_i]]$ACC <- data[[p_i]][[w_i]][[d_i]]$ACC[1:(2+interval*samplingrate),]
#BVP
samplingrate=data[[p_i]][[w_i]][[d_i]]$BVP[2,1]#64
data[[p_i]][[w_i]][[d_i]]$BVP <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$BVP[1:(2+interval*samplingrate),])
#EDA
samplingrate=data[[p_i]][[w_i]][[d_i]]$EDA[2,1]#4
data[[p_i]][[w_i]][[d_i]]$EDA <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$EDA[1:(2+interval*samplingrate),])
#HR
samplingrate=data[[p_i]][[w_i]][[d_i]]$HR[2,1]#1
data[[p_i]][[w_i]][[d_i]]$HR <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$HR[1:(2+interval*samplingrate),])
#Temp
samplingrate=data[[p_i]][[w_i]][[d_i]]$Temp[2,1]#1
data[[p_i]][[w_i]][[d_i]]$Temp <- as.data.frame(data[[p_i]][[w_i]][[d_i]]$Temp[1:(2+interval*samplingrate),])
#IBI
Temp<-which(data[[p_i]][[w_i]][[d_i]]$IBI[2:length(data[[p_i]][[w_i]][[d_i]]$IBI[,1]),1]>=interval)
data[[p_i]][[w_i]][[d_i]]$IBI <- data[[p_i]][[w_i]][[d_i]]$IBI[1:(1+Temp[1]),1:2]

#>> There is no recorded data for following people
# a.)	Participant 8, week 1, night 7
p_i=8;w_i=1;d_i=7
survey <- survey[-c(which(survey$`Particiapnt #`==p_i & survey$Week==w_i & survey$`Survey Number`==d_i)),]
