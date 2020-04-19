## Down load the file from the Course site

fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!file.exists(".data")){dir.create("./data")}
download.file(fileurl,destfile="./data/FNEI_data.zip") 

## Unzip the downloaded file 

unzip("./data/FNEI_data.zip", exdir = "./data") 

## Reading the data files
library(dplyr)
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
library(dplyr)
BaltimoreCity<-subset(NEI,fips==24510)
Total_emission_by_year_type<-BaltimoreCity %>% group_by(year,type) %>% summarise_if(is.numeric, funs(sum))
library(ggplot2) 

##Plotting using ggplot2

png(filename = "plot3.png")
g<-ggplot(Total_emission_by_year_type,aes(year,Emissions))
g1<-g+geom_point(size=4,alpha=0.5,aes(colour=type))+facet_grid(.~type,scales="fixed")+geom_smooth(se=FALSE,colour="green")
g1+ggtitle("Baltimore City (Pm2.5)",subtitle = "(1999-2008)")+theme_bw() +geom_bar(stat="identity",show.legend=NULL,aes(fill=as.factor(year)))+
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5),axis.text.x =element_blank())+guides(fill=FALSE) +
  xlab("Years(1999-2002-2005-2008)") + ylab("Total Emissions (Tons)") 

dev.off() 

