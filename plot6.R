## Down load the file from the Course site

fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!file.exists(".data")){dir.create("./data")}
download.file(fileurl,destfile="./data/FNEI_data.zip") 

## Unzip the downloaded file 

unzip("./data/FNEI_data.zip", exdir = "./data") 

## Reading the data files

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

library(dplyr)
BaltimoreCity<-subset(NEI,fips=="24510")
LosAngelescity<-subset(NEI,fips=="06037")

##Motor Vehicles SCC codes
motorVehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
motorVehicles_SCC<- SCC[motorVehicles,]$SCC

##Subsetting based on SCC codes for Motor Vehicles

BaltimoreCity_motorVehicles <- BaltimoreCity[BaltimoreCity$SCC %in% motorVehicles_SCC,]
LosAngelescity_motorVehicles <- LosAngelescity[LosAngelescity$SCC %in% motorVehicles_SCC,]

MotorVehcles_Emission_sum_BM<-BaltimoreCity_motorVehicles %>% group_by(year) %>% summarise_if(is.numeric, funs(sum))
MotorVehcles_Emission_sum_BM<-LosAngelescity_motorVehicles %>% group_by(year) %>% summarise_if(is.numeric, funs(sum))

##plotting using ggplot2
library(ggplot2) 
png(filename = "plot6.png")
## Baltimore plot
g<-ggplot(MotorVehcles_Emission_sum_BM,aes(year,Emissions))+xlim(1997,2010)+ylim(0,8000)
g1<-g+geom_bar(stat="identity",aes(fill=as.factor(year)))+geom_point(size=4,alpha=0.5)+geom_line(colour="blue",lwd=1)+
ggtitle("Total PM2.5 Emission (Motor Vehicles)",subtitle = " Baltimore City (1999-2008)")+theme_bw() +
theme(plot.title = element_text(hjust = 1.5),plot.subtitle = element_text(hjust = 0.5)) +
  xlab("Years") + ylab("Total Emissions (Tons)") 
## Las Angles plot
a<-ggplot(MotorVehcles_Emission_sum_LA,aes(year,Emissions))+xlim(1997,2010)+ylim(0,8000)
a1<-a+geom_bar(stat="identity",aes(fill=as.factor(year)),show.legend=FALSE)+geom_point(size=4,alpha=0.5)+geom_line(colour="blue",lwd=1)+
ggtitle("",subtitle="Las Angles City (1999-2008)")+theme_bw() +
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) +
  xlab("Years") + ylab("Total Emissions (Tons)") 
##install.packages("patchwork")
library(patchwork)
a1+g1 ## This is to plot side by side 
dev.off() 

