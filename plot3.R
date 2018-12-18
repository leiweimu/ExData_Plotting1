# The script reads data from UCI Individual household electric power consumption Data Set, 
# and generates a line chart showing different household energy sub-meterings over a 2-day 
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
df$datetime <- as.POSIXct(strptime(df$datetime, format = "%d/%m/%Y-%H:%M:%S"))
df <- df[, c("datetime", names(df)[-c(1, 2, length(names(df)))])]

# generates graph, and saves to the preferable graphics device
imageName <- "plot3.png"
png(imageName, width = 480, height = 480)
with(df, plot(subMetering1 ~ datetime, type = "n", xlab = "", ylab = "Energy sub metering"))
lines(data = df, subMetering1 ~ datetime, col = "black")
lines(data = df, subMetering2 ~ datetime, col = "red")
lines(data = df, subMetering3 ~ datetime, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = c(1, 1, 1), col = c("black", "red", "blue"))
dev.off()

# prompts success message, and removes temporary objects
message("\"", imageName, "\" has been successfully saved to the current directory.")
rm(list = ls())