################################################################################
#What does the script do
#
#
#ACMAD/Copyright
################################################################################
library(rio)
library(dplyr)
#http://154.66.220.45:8080/thredds/fileServer/ACMAD/CDD/climatedataservice/Synoptic_Daily_CPC_Unified_Data/Niger/ZINDER.csv
setwd("~/Bureau/ACMAD_Git/")
#Importation of station list
Station<-rio::import("Synoptic_Station_All.csv")

Station<-filter(Station,Country %in% c("Burkina","Niger"))
Data_Source="ARC2"

for (i in 1:length(Station$Station)) {
  print(i)
  
  List<-gsub(".csv","",list.files(path =paste("Data/",Data_Source,"/",Station$Country[i],"/",sep=""),".csv"))
  
  if(Station$Station[i] %in% List){
    
    print("Yet Downloaded!!!!")
    
  }else{
    
    dir.create(paste("Data/",Data_Source,"/",Station$Country[i],sep=""),recursive = T,showWarnings = F)
    
    download.file(url = paste("http://154.66.220.45:8080/thredds/fileServer/ACMAD/CDD/climatedataservice/Synoptic_Daily_ARC2_Data/",Station$Country[i],"/",Station$Station[i],".csv",sep=""),destfile = paste("Data/",Data_Source,"/",Station$Country[i],"/",Station$Station[i],".csv",sep=""))
  }
}