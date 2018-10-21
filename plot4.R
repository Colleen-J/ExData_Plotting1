## Data Science - Exploratory Data Analysis, week 4 project, Plot 4

# Open power file and unzip
destfile<-"C:/Users/wacja/Documents/Colleen work/Data science coursera/power.zip"
pwrfile<-"C:/Users/wacja/Documents/Colleen work/Data science coursera/power/household_power_consumption.txt"
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile, mode="wb")
unzip(destfile, list=TRUE)

# Pull in headers from the file
ptemp<-read.table(pwrfile,sep=';',header=TRUE, nrows=1)

# Pull only the data needed, which is dated: 2/1/2007 - 2/2/2007 
ftemp <- file(pwrfile, "r")
pdat <- c()
while(TRUE) {
  line = readLines(ftemp, 1)
  if(length(line) == 0) break
  else if(grepl("^1/2/2007", line) | grepl("^2/2/2007", line)) pdat <- c(pdat, line)
}
remove("ptemp")
# Convert the character list to a dataframe, set headings and convert date/time and factors
pwdf <- data.frame( do.call( rbind, strsplit( pdat, ';' ) ) )
pwdf <- cbind(pwdf,Date=as.POSIXct(paste(as.character(pwdf$X1), as.character(pwdf$X2)), format="%d/%m/%Y %H:%M:%OS"))

pwdf$X1<-NULL
pwdf$X2<-NULL

for (i in 3:9) colnames(pwdf)[i-2]<- colnames(ptemp)[i]

indx <- sapply(pwdf, is.factor)
pwdf[indx] <- lapply(pwdf[indx], function(x) as.numeric(as.character(x)))


png(file="C:/Users/wacja/Documents/Colleen work/Data science coursera/plot4.png",width = 480, height = 480, unit = "px")
par(mfrow=c(2,2))

#First
plot(pwdf$Date, pwdf$Global_active_power, type="l", ylab = "Global Active Power (kilowatt)")

#Second
plot(pwdf$Date, pwdf$Voltage, type='l', ylab="Voltage", xlab="datetime")

#Third
plot(pwdf$Date, pwdf$Sub_metering_1, type="l" ,ylab="Energy sub metering")
lines(pwdf$Date, pwdf$Sub_metering_2, type="l", col="red")
lines(pwdf$Date, pwdf$Sub_metering_3, type="l", col="blue")
legend('topright', legend=names(pwdf)[-1][4:6], lty=1,col=c('black', 'red', 'blue'), bty="n")

#Fourth
plot(pwdf$Date, pwdf$Global_reactive_power , type='l', ylab=names(pwdf)[-1][1], xlab="datetime")

dev.off()
