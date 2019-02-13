# Author: Reza Sadeghi
# Email: reza@knoesis.org; sadeghi.2@wright.edu
# Date: 4/22/2018
# Description: Servay analysis of Dementia Caregiver managment

# Import data
#library(readxl)
#Sleep_Survey <- read_excel("C:/Users/Reza Sadeghi/Desktop/Dementia Caregiver Sleep Dataset/Sleep Survey.xlsx")
Sleep_Survey <- survey
#View(Sleep_Survey)

#-------------------------------------------------Wake up during night------------------------------------------------

RecordNumbers<-length(Sleep_Survey$`Particiapnt #`)
ParticipantID<-unique(Sleep_Survey$`Particiapnt #`)

H<- summary (as.factor(Sleep_Survey$`Question 8`))
M<- c("Less than thirty minutes", "Between thirty and sixty minutes", "More than sixty minutes", "Not applicable")

barplot(H,names.arg = M,xlab = "Categories",ylab = "Frequency",col = "blue", main = "The time takes participants to fall back to sleep",border = "red")

#-------------------------------------------------Quality of Sleep Vs. Feeling rest------------------------------------------------
pp<- Sleep_Survey$`Question 9`
pg<- Sleep_Survey$`Question 10`

New<- NULL
pp<- as.integer(pp)
New$pp<- pp
pg<- as.factor(pg)
library(plyr)
pg<-revalue(pg, c("1"="Feeling Rest", "0"="Tired"))
summary(pg)
New$pg<- pg
New <- as.data.frame(New)
a<-boxplot(pp~pg,data=New,ylab="Quality of Sleep", xlab= "Mood")
stripchart(pp~pg, vertical = TRUE, data=New, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')

pp<- Sleep_Survey$`Question 9`
pg<- Sleep_Survey$`Question 10`
pp<- as.factor(pp)
pg<- as.factor(pg)
pp<-revalue(pp, c("0"="Very Good", "1"="Good", "2"="Okay", "3"="Fairly Bad", "4"="Bad"))
pg<-revalue(pg, c("1"="Feeling Rest", "0"="Feeling Tired"))
Mood<-pg
Sleep_Quality<-pp
New <- table(Mood, Sleep_Quality)
mosaicplot(New,main = "The relation of Sleep quality and tiredness", xlab = "Mood", ylab = "Sleep quality")

library(vcd)
mosaic(New, shade=T, legend=T, pop= FALSE)
labs <- round(prop.table(New), 2)
labs <- as.data.frame(labs)
labs$Freq <- "   "
labs$Freq[3] <- "(a)"
labs$Freq[4] <- "(b)"
labeling_cells(text = as.data.table (labs), margin = 0)(New)

print("The percentage of caregivers Feel tired")
length(Mood[which(Mood=="Feeling Tired")])/length(Mood)

#-------------------------------------------------Quality of Sleep Vs. Time of Sleep------------------------------------------------
pp<- Sleep_Survey$`Question 4`
pg<- Sleep_Survey$`Question 9`

New<- NULL
pp<- as.double(pp)
New$pp<- pp
pg<- as.factor(pg)
pg<- factor(pg, levels = c("4", "3", "2", "1", "0"))
pg<-revalue(pg, c("0"="Very Good", "1"="Good", "2"="Okay", "3"="Fairly Bad", "4"="Bad"))
library(plyr)
New$pg<- pg
New <- as.data.frame(New)
a<-boxplot(pp~pg,data=New,ylab="Length of sleep (hour)", xlab= "Quality of Sleep")
stripchart(pp~pg, vertical = TRUE, data=New, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')

#-------------------------------------------------The portions Sleep Quality------------------------------------------------
print("The portion of Bad and Fairly Bad sleepint")
length(pg[which(pg=="Fairly Bad" | pg=="Bad")])/length(pg)
print("The portion of sleepint Okay")
length(pg[which(pg=="Okay")])/length(pg)
print("The portion of Good sleepint")
length(pg[which(pg=="Good")])/length(pg)
print("The portion of Very good sleepint")
length(pg[which(pg=="Very Good")])/length(pg)

#-------------------------------------------------The Statistical Features------------------------------------------------
# setwd("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset")
# FeatureSet <- read.csv("FeatureSet5.csv",header = T,as.is = T)
# #View(FeatureSet)
# # removing unlabeled records
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==2 & FeatureSet$Week==2 & FeatureSet$Day==7),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==3 & FeatureSet$Week==2 & FeatureSet$Day==2),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==3 & FeatureSet$Week==2 & FeatureSet$Day==3),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==3 & FeatureSet$Week==2 & FeatureSet$Day==4),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==4 & FeatureSet$Week==1 & FeatureSet$Day==7),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==5 & FeatureSet$Week==1 & FeatureSet$Day==8),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==5 & FeatureSet$Week==2 & FeatureSet$Day==7),]
# FeatureSet<-FeatureSet[-which(FeatureSet$Participant==7 & FeatureSet$Week==2 & FeatureSet$Day==6),]
# pg<- Sleep_Survey$`Question 9`
# pg<- as.integer (pg)
# FeatureSet$Sleep_Quality<- pg
# 
# library(corrplot)
# corrplot(cor(FeatureSet[,1:38]), type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)

#-------------------------------------------------The distribution of Sleep Quality ccategories------------------------------------------------
library(lattice)
#barchart(as.factor(FeatureSet$Sleep_Quality),ylab=c("Very Good", "Good", "Okay", "Fairly Bad", "Bad"))
barchart(pg)
