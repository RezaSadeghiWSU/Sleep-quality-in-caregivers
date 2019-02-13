#Project Name: Studing the Dementia Caregiver Sleep
#File Name: Catch Data From E4 for caregiver sleep study
#Author: Reza Sadeghi
#Email: sadeghi.2@wright.edu; reza@knoesis.org
#Ver:1.2
#Last modification:6/10/2018

person=c(1:8)
week=c(1:2)
day=c(1:7)
signal=list('ACC','BVP','EDA','HR','IBI','Temp')
data=list(person,week,day,signal)


data <- vector(mode = "list", length = 8)
for (p_i in 1:8){
  data[[p_i]] <- vector(mode="list", length = 2)
  for (w_i in 1:2){
    data[[p_i]][[w_i]] <- vector(mode="list", length = 7)
    for (d_i in 1:8){
      data[[p_i]][[w_i]][[d_i]] <- structure(vector(mode="list", length = 6), names= signal)
    }
  }
}

root="C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset\\Dataset\\";
for (p_i in 1:8){
  for (w_i in 1:2){
    for (d_i in 1:8){
      possibleError <- tryCatch({
        direction=paste(root,'Participant ',as.character(p_i),'\\Week ', as.character(w_i),'\\',as.character(d_i), sep = '')
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

setwd("C:\\Users\\Reza Sadeghi\\Desktop\\Dementia Caregiver Sleep Dataset")
save(data,file = "DataP1_8.RData")
