# Exploratory Data Analysis - Assignment 1 - plot 1
# Alessandro Sisti

library(lubridate)

# Download the data file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "household_power_consumption.txt", method = "curl")
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
startDate <- ymd('2007-02-01'); endDate <- ymd('2007-02-02')
powerSubset <- power[startDate <= power$Date, ]
powerSubset <- powerSubset[powerSubset$Date <= endDate, ]

# Make histogram
hist(powerSubset$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", col = "violetred2")

# Save the histogram to a file
dev.copy(png, filename = "plot1.png", width = 480, height = 480)
dev.off()