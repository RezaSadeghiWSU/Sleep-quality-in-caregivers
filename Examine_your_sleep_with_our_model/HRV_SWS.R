#Project Name: Studing the Dementia Caregiver Sleep
#File Name: Computing the SWS drived from HRV based on the following paper:
# "Reproducibility of heart rate variability is parameter and sleep stage dependent.,"
#Author: Reza Sadeghi
#Email: sadeghi.2@wright.edu; reza@knoesis.org
#Ver:1.4
#Last modification:11/7/2020

#>>> computing rRR time series with sliding windows of
#windows (windowsLength) with moving (stepLength)

HRV_SWS<-function(IBI){
  #p_i=1;w_i=1;d_i=1
  #temp <- data[[p_i]][[w_i]][[d_i]]$IBI
  temp <- IBI
  rangeStart=1#2 ->for original file of IBI
  rangeEnd=length(temp[,1])
  timeSignal=temp[rangeEnd,1]-temp[rangeStart,1]
  windowsLength=5*60#5*60s
  stepLength=20#20s
  segmentNumber=floor((timeSignal-windowsLength)/stepLength)
  rRR=rep(0,segmentNumber+1)
  
  start1 <- rangeStart#2 ->for original file of IBI
  finish1 <- which(temp[start1:length(temp[,1]),1]>=(windowsLength+temp[start1,1]))[1]
  rRR[1] <- cor(as.double(temp[start1:(finish1-1),2]),as.double(temp[(start1+1):finish1,2]),method = "pearson")
  
  for (i in 1:segmentNumber-1){
    #print(i)
    startSegmentTime=(stepLength*i)+temp[start1,1]
    startSegment <- which((temp[rangeStart:rangeEnd,1])>=(startSegmentTime))[1]
    finishSegment <- which(temp[rangeStart:rangeEnd,1]>=(windowsLength+startSegmentTime))[1]
    # if(i==(segmentNumber-1)){
    #   print(i)
    # }
    rRR[i+1] <- cor(as.double(temp[startSegment:(finishSegment-1),2]),as.double(temp[(startSegment+1):finishSegment,2]),method = "pearson")
  }
  
  #>>> finding the threshold of deep sleep stages -> 0.1*average rRR for initial 4 hours
  obserivingTime<- 4*3600
  finalrRR<-rep(0,(stepLength*segmentNumber))#extend to second range
  for (i in 1:segmentNumber){
    finalrRR[(1+((i-1)*stepLength)):(i*stepLength)]=rRR[i]
  }
  #plot.ts(finalrRR)
  threshold=mean(finalrRR[1:obserivingTime],na.rm = TRUE)-0.1
  
  #>>> catching the intervals below the the threshold
  underThreshold=as.numeric(finalrRR<threshold)
  #plot.ts(underThreshold)
  
  #>>> SWS recogntion
  stableTime=10*60
  segrigatedSections = rle(underThreshold)
  segrigatedSections$sws<-as.numeric(segrigatedSections$values==1 & segrigatedSections$lengths>=stableTime)
  swsLength <-sum(segrigatedSections$lengths[which(segrigatedSections$sws==1)])/(sum(segrigatedSections$lengths))
  swsTime <-length(which(segrigatedSections$sws==1))
  
  #>>> SWS plot
  
  returnList<-list(swsLength, swsTime)
  return(returnList)
}
