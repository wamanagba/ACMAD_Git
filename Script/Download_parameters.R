


###########   RH_level_700 ou RH_level_850: Dekadal Values  #######


# http://iridl.ldeo.columbia.edu/expert/expert/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/.Intrinsic/.
# PressureLevel/.rhum/T/(1%20Apr%202014)/(10%20Apr%202014)/RANGEEDGES/Y/(50N)/(50S)/RANGEEDGES/P/
#(850)/VALUES/X/(40W)/(72E)/RANGEEDGES/%5BT%5Daverage/ngridtable/3+ncoltable.html

library(rio)
library(dplyr)
Sys.setlocale("LC_TIME","English")
#If you have problem with to download please comment options(download.file.method = 'wget')
options(download.file.method = 'wget')
options(timeout=100)

options(download.file.extra = '--no-check-certificate')


#Remove all the data that are contained in the enironment
rm(list = ls())

setwd("D:/Onset_Methods/") #Specify the working directory