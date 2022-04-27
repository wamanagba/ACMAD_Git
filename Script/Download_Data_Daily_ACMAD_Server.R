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






################################################################################
#
#  Number Rain day
#
###############################################################################

for (i in 1:length(Station$Station)) {
  station= Station$Station[i]
  CounTry=Station$Country[i]
  data=rio::import(paste('Data/',Data_Source,"/",CounTry,'/',station,'.csv',sep=""))
  data$Precipitation= ifelse(data$Precipitation<2.5,0,1)
  data$Year = as.numeric(format(data$Date,'%Y'))
  
  # Calculation of Number Rain day for each station
  Data_numberDay = data%>%
    group_by(Country,Station,Year) %>%
    summarise(Number_Rain_day = sum(Precipitation,na.rm = T))
  
  # Create a folder each station
  dir.create(paste('Data/',Data_Source,"/",CounTry,'/Number_Rain_day',sep = ""),recursive = T, showWarnings = F)
  rio::export(Data_numberDay,paste('Data/',Data_Source,"/",CounTry,'/Number_Rain_day/Data_numberDay_',station,'.csv',sep = ""))
  
}


## #############################################################################
## 
##  Cumulative precipitation
##
################################################################################
for (i in 1:length(Station$Station)) {
  station= Station$Station[i]
  CounTry= Station$Country[i]
  data_S=rio::import(paste('Data/',Data_Source,"/",CounTry,'/',station,'.csv',sep=""))
  #data_$Precipitation= ifelse(data_$Precipitation<2.5,0,1)
  data_S$Year = as.numeric(format(data_S$Date,'%Y'))
  
  # Calculation of annual precipitation sum for each station
  data_S_Sum_Precipitation = data_S%>%
    group_by(Country,Station,Year) %>%
    summarise(Sum_Precipitation = sum(Precipitation,na.rm = T))
  
  # Create a folder to put the
  dir.create(paste('Data/',Data_Source,"/",CounTry,'/Sum_Precipitation',sep = ""),recursive = T, showWarnings = F)
  rio::export(data_S_Sum_Precipitation,paste('Data/',Data_Source,"/",CounTry,'/Sum_Precipitation/',station,'.csv',sep = ""))
  
}

###############################################################################
##                                                                          ###  
##                 Extrem precipitation by year                             ###
##                                                                          ###
###############################################################################
#rm(list=ls())


for (i in 1:length(Station$Station)) {
  station= Station$Station[i]
  CounTry=Station$Country[i]
  data=rio::import(paste('Data/',Data_Source,"/",CounTry,'/',station,'.csv',sep=""))
  #data_$Precipitation= ifelse(data_$Precipitation<2.5,0,1)
  data$Year = as.numeric(format(data$Date,'%Y'))
  
  # Calculation of annual precipitation sum for each station
  data_Extrem_Precipitation = data%>%
    group_by(Country,Station,Year) %>%
    summarise(Extreme_Precipitation = max(Precipitation,na.rm = T))
  
  # Create a folder to put the
  dir.create(paste('Data/',Data_Source,"/",CounTry,'/Extrem_Precipitation',sep = ""),recursive = T, showWarnings = F)
  rio::export(data_Extrem_Precipitation,paste('Data/',Data_Source,"/",CounTry,'/Extrem_Precipitation/',station,'.csv',sep = ""))
}




################################################################################
#
#  Plot Number Rain day
#
###############################################################################


Indice="Sum_Precipitation"

#importation of the Data Set
data_sation<-rio::import(paste("Data/",Data_Source,"/",CounTry,"/",Indice,"/",station,".csv",sep  =""))


p <- ggplot(data = data_sation, aes(x = Year, y = Sum_Precipitation)) + 
  geom_line(color = "#00AFBB", size = 1)


last_graph <- ggplot2::ggplot(data=data_sation, mapping=ggplot2::aes(x=Year, y=Sum_Precipitation))+ ggplot2::geom_smooth(mapping=ggplot2::aes(y=Sum_Precipitation), method="lm", formula="y ~ x", colour="black", se=FALSE) + theme_grey() + ggplot2::theme(axis.text.x=ggplot2::element_text(angle=90, size=20, colour="black"), axis.title=ggplot2::element_text(face="bold"), axis.text=ggplot2::element_text(face="bold"), axis.title.x=ggplot2::element_text(size=15.0, face="bold"), axis.title.y=ggplot2::element_text(size=15.0), plot.title=ggplot2::element_text(size=20.0, face="bold"), axis.text.y=ggplot2::element_text(size=20, face="bold", colour="black")) + ggplot2::labs(title=paste("Anomaly of Annual Total Rainfall for data_sation"), subtitle="", caption="") + ggplot2::xlab(label="Years") + ggplot2::scale_x_continuous(breaks=seq(by=1, to=2022, from=1983)) + ggplot2::ylab(label="Rainfall Anomaly (mm)") + ggplot2::scale_y_continuous(breaks=seq(by=40, to=800, from=-800))

ggplot2::ggsave(filename=paste("Products/Sum_Precipitation.jpeg",sep=""), width=14,height=8,limitsize = FALSE ,plot=last_graph)

summary(lm(data_sation$Year~data_sation$Anomaly))
