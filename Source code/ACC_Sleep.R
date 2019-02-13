#Project Name: Studing the Dementia Caregiver Sleep
#File Name: Finding the changing attitude of Accelerametor
#Author: Reza Sadeghi
#Email: sadeghi.2@wright.edu; reza@knoesis.org
#Ver:1.2
#Last modification:6/17/2018

#>>> computing rRR time series with sliding windows of
#windows (windowsLength) with moving (stepLength)

ACC_Sleep<-function(ACC){
  temp <- ACC
  temp <- sqrt((temp[,1]^2)+(temp[,2]^2)+(temp[,3]^2))
  samplingrate=32
  rangeStart=1#2 ->for original file of IBI
  rangeEnd=length(temp)
  timeSignal=rangeEnd/samplingrate
  windowsLength=5*60#5*60s
  stepLength=20#20s
  segmentNumber=floor((timeSignal-windowsLength)/stepLength)
  rRR=rep(0,segmentNumber+1)
  
  start1 <- rangeStart
  finish1 <- windowsLength+start1
  rRR[1] <- cor(as.double(temp[start1:(finish1-1)]),as.double(temp[(start1+1):finish1]),method = "pearson")
  
  for (i in 1:segmentNumber-1){
    #print(i)
    startSegmentTime=(stepLength*i)+start1
    startSegment <- startSegmentTime
    finishSegment <- windowsLength+startSegmentTime
    rRR[i+1] <- cor(as.double(temp[startSegment:(finishSegment-1)]),as.double(temp[(startSegment+1):finishSegment]),method = "pearson")
  }
  
  #>>> finding the threshold of deep sleep stages -> 0.1*average rRR for initial 4 hours
  obserivingTime<- 4*3600
  finalrRR<-rep(0,(stepLength*segmentNumber))#extend to second range
  for (i in 1:segmentNumber){
    finalrRR[(1+((i-1)*stepLength)):(i*stepLength)]=rRR[i]
  }
  #plot.ts(finalrRR)
  threshold=mean(finalrRR[1:obserivingTime])-0.1
  
  #>>> catching the intervals below the the threshold
  underThreshold=as.numeric(finalrRR<threshold)
  #plot.ts(underThreshold)
  
  #>>> SWS recogntion
  stableTime=10*60
  segrigatedSections = rle(underThreshold)
  segrigatedSections$sws<-as.numeric(segrigatedSections$values==1 & segrigatedSections$lengths>=stableTime)
  #swsLength <-sum(segrigatedSections$lengths[which(segrigatedSections$sws==1)])
  #swsTime <-length(which(segrigatedSections$sws==1))
  swsLength <-sum(segrigatedSections$lengths[which(segrigatedSections$sws==1)])/(sum(segrigatedSections$lengths))
  swsTime <-length(which(segrigatedSections$sws==1))
  
  #>>> ACC plot
  #plot(temp, type="l", col=grey(.5))
  ## Smoothed symmetrically
  windowsSize <- rep(1/((samplingrate*60)+1),((samplingrate*60)+1))
  smoothed <- filter(temp, windowsSize, sides=2)
  #lines(smoothed, col="blue")
  smoothed <- na.omit(smoothed)
  decreasePercentage <- sum((smoothed[2:length(smoothed)]-smoothed[1:(length(smoothed)-1)])<0)/(length(smoothed)-1)
  
  returnList<-list(swsLength, swsTime, decreasePercentage)
  return(returnList)
}
