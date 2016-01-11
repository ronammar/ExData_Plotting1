library(dplyr)

# PRECONDITION: Expecting data file in same working directory as this script

# Load data and ensure points are between 2007-02-01 and 2007-02-02.
# Instead of screening the lines as they're input, I'm inputing the entire
# table and then filtering. We've got enough memory.
dStart <- as.Date("2007-02-01")
dEnd <- as.Date("2007-02-02")
hpc <- read.table("household_power_consumption.txt",
                  sep=";",
                  stringsAsFactors=FALSE, 
                  header=TRUE,
                  na.strings=c("NA", "N/A", "?"))
hpc <- hpc %>%
  mutate(asDate=as.Date(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))) %>%
  filter(asDate >= dStart & asDate <= dEnd)

# Add a column using POSIXlt time. Can't be done using dplyr mutate.
hpc$posix <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")

# Plot line graphs (plot 4)
png("plot4.png", width=480, height=480, units="px")

par(mfrow=c(2, 2))  # Create 2x2 grid for plots

plot(hpc$posix, hpc$Global_active_power, ylab='Global Active Power (kilowatts)',
     type="l")

plot(hpc$posix, hpc$Voltage, xlab="datetime", ylab="Voltage", type="l")

plot(hpc$posix, hpc$Sub_metering_1, ylab='Energy sub metering',
     xlab="", type="l")
lines(hpc$posix, hpc$Sub_metering_2, col="red")
lines(hpc$posix, hpc$Sub_metering_3, col="blue")
legend("topright", legend=colnames(hpc)[7:9],
       col=c("black", "red", "blue"), lty='solid')
# NOTE: Legend doesn't appear correctly in R window. However, it is resized
# correctly in final png.

plot(hpc$posix, hpc$Global_reactive_power, xlab="datetime",
     ylab="Global_reactive_power", type="l")

dev.off()