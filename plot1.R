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

# Plot histogram
hist(hpc$Global_active_power,
     col="red",
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")