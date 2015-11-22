# download data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "dataset.zip", method = "curl")
unzip("dataset.zip")
unlink("dataset.zip")

# read in files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Have total emissions from PM2.5 decreased in the United States from 1999 to 
## 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# isolate variables of interest
emissions <- aggregate(Emissions ~ year, NEI, sum)

# plot
par(mar = c(5.1, 5.1, 4.1, 2.1))

barplot(height = emissions$Emissions/10^6, 
        names.arg = emissions$year, 
        col = "gray50", 
        ylim = range(pretty(c(0, emissions$Emissions/10^6))), 
        main = expression("Total " * PM[2.5] * " Emissions by Year"), 
        xlab = "Year", 
        ylab = expression(PM[2.5] * " Emissions (tons/" * 10^6 * ")"), 
        axis.lty = 1)

# save to png file
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()