# Exploratory Data Analysis - Assignment 1 - plot 4
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

# Get rid of a few objects to open up RAM (I have fairly little RAM)
remove(firstRows); remove(power); remove(classes); remove(entry)

# Make single column for date and time and overwrite the original date column
dateTimes <- rep(ymd_hms("1990-01-01 00:00:00"), length(powerSubset$Date)) # Initialize empty vector
for (entry in 1:length(powerSubset$Date)) {
  dateTimes[entry] <- powerSubset$Date[entry] + powerSubset$Time[entry]
}
powerSubset$Date <- dateTimes

# Set the plotting parameters to prepare for having four plots
par(mfcol = c(2, 2))

# Make the plots

# Top left
with(powerSubset, plot(Date, Global_active_power, type = "l",
                       xlab = "", ylab = "Global Active Power (kilowatts)"))

# Bottom Left
with(powerSubset, plot(Date, Sub_metering_1, type = "l",
                       xlab = "", ylab = "Energy sub metering"))
lines(x = powerSubset$Date, y = powerSubset$Sub_metering_2,
      col = "red")
lines(x = powerSubset$Date, y = powerSubset$Sub_metering_3,
      col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       seg.len = 1, inset = c(.06, 0), bty = "n")

# Top right
with(powerSubset, plot(Date, Voltage, type = "l",
                       xlab = "datetime"))

# Bottom right
with(powerSubset, plot(Date, Global_reactive_power, type = "l",
                       xlab = "datetime"))

# Save the plot to a file
dev.copy(png, filename = "plot4.png", width = 480, height = 480)
dev.off()