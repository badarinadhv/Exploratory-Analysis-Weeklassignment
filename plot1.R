## Down load the file from the Course site

fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!file.exists(".data")){dir.create("./data")}
download.file(fileurl,destfile="./data/FNEI_data.zip") 

## Unzip the downloaded file 

unzip("./data/FNEI_data.zip", exdir = "./data") 

## Reading the data files

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Emission Computations

Total_Emission_by_year<-NEI %>% group_by(year) %>% summarise_if(is.numeric, funs(sum))
Mean_Emission_by_year<-NEI %>% group_by(year) %>% summarise_if(is.numeric, funs(mean))

## Plotting Base plots

png(filename = "plot1.png")
par(mar=c(4,4,4,1),oma=c(0,0,2,0),mfcol=c(2,2))
with(Total_Emission_by_year,{
  plot(year,Emissions,main="PM2.5-United States",col=3,pch=20,cex=.5,xlab="Year",ylab="Total Emission (Tons)",type="n",
       xlim=c(1998,2009),xaxs="i")
  
  points(year,Emissions,col=year,pch=20,cex=3)
  points(year,Emissions,col=3,type="l",lwd=2,cex=2)
  legend("topright",col=year,pch=20,legend=year,cex=1)
  grid(nx = 11, ny = 11, col = "lightgray", lty = "dotted",lwd = par("lwd"), equilogs = FALSE)
  mtext("(1999-2008)")
})
## Total Emission Histogram
barplot(height=Total_Emission_by_year$Emissions,col=Total_Emission_by_year$year,names.arg=Total_Emission_by_year$year,main="Total Emissions")
## Mean Emissions
with(Mean_Emission_by_year,{
  plot(year,Emissions,main="PM2.5-United States",col=3,pch=20,cex=.5,xlab="Year",ylab="Mean Emission (Tons)",type="n",
       xlim=c(1998,2009),xaxs="i")
  
  points(year,Emissions,col=year,pch=20,cex=3)
  points(year,Emissions,col=3,type="l",lwd=2,cex=2)
  legend("topright",col=year,pch=20,legend=year,cex=1)
  grid(nx = 11, ny = 11, col = "lightgray", lty = "dotted",lwd = par("lwd"), equilogs = FALSE)
  mtext("(1999-2008)")
})
barplot(height=Mean_Emission_by_year$Emissions,col=Mean_Emission_by_year$year,names.arg=Mean_Emission_by_year$year,main="Mean Emissions")
dev.off()