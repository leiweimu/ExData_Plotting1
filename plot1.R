# The script reads data from UCI Individual household electric power consumption Data Set, 
# and generates a histogram showing the household global active power usage over a 2-day 
# period from 2007-02-01 to 2007-02-02.

# downloads flat file to the current directory if necessary
fileName <- "household_power_consumption.txt"
if (!file.exists(fileName)) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./household_power_consumption.zip")
    unzip("household_power_consumption.zip")
}

# locates starting and ending rows that are of interest of this analysis
startPosition <- min(grep("^1/2/2007", readLines(fileName)))
endPosition <- max(grep("^2/2/2007", readLines(fileName)))

# loads data to a data frame in R
columnNames <- c("date", "time", "globalActivePower", "globalReactivePower", "voltage", "globalIntensity", "subMetering1", "subMetering2", "subMetering3")
df <- read.table(fileName, sep = ";", na.string = "?", col.names = columnNames, nrows = endPosition - startPosition + 1, skip = startPosition - 1)

# combines date and time, and converts to Date/Time type
df$datetime <- paste(df$date, df$time, sep = "-")
df$datetime <- as.POSIXlt(strptime(df$datetime, format = "%d/%m/%Y-%H:%M:%S"))
df <- df[, c("datetime", names(df)[-c(1, 2, length(names(df)))])]

# generates graph and saves to the preferable graphics device
png("plot1.png", width = 480, height = 480)
with(df, hist(globalActivePower, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
dev.off()

# removes temporary objects and prompts success message
rm(list = ls())
message("\"plot1.png\" has been successfully saved to the current directory.")