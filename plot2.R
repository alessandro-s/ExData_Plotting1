# Exploratory Data Analysis - Assignment 1 - plot 2
# Alessandro Sisti

library(lubridate)

# Read the data
firstRows <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?",
                        comment.char = "", header = TRUE, nrows = 100)
classes <- sapply(firstRows, class)
power <- read.table("household_power_consumption.txt", sep = ";", 
                    na.strings = "?", comment.char = "", header = TRUE, 
                    colClasses = classes)

# Convert date and time columns to appropriate formats
power[, 1] <- dmy(power[, 1]); power[, 2] <- hms(power[, 2])

# Use only data from between 2007-02-01 and 2007-02-02
dateRange <- interval(ymd('2007-02-01'), ymd('2007-02-02'))
powerSubset <- power[power$Date %within% dateRange, ]

# Make single column for date and time and overwrite the original date column
dateTimes <- rep(ymd_hms("1990-01-01 00:00:00"), length(powerSubset$Date)) # Initialize empty vector
for (entry in 1:length(powerSubset$Date)) {
  dateTimes[entry] <- powerSubset$Date[entry] + powerSubset$Time[entry]
}
powerSubset$Date <- dateTimes

# Make the plot
with(powerSubset, plot(Date, Global_active_power,
                       ylab = "Global Active Power (kilowatts)",
                       xlab = "",
                       type = "l"))

# Save the plot to a file
dev.copy(png, filename = "plot2.png", width = 480, height = 480)
dev.off()