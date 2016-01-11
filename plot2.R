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

# Plot line graph (plot 2)
png("plot2.R", width=480, height=480, units="px")
plot(hpc$posix, hpc$Global_active_power, ylab='Global Active Power (kilowatts)',
     type="l")
dev.off()