# download data if needed
if(!file.exists("summarySCC_PM25.rds")) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL, destfile = "dataset.zip", method = "curl")
    unzip("dataset.zip")
    unlink("dataset.zip")
} 

# read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
## plot answering this question.

# isolate variables of interest
baltimoreNEI <- NEI[NEI$fips == "24510", ]
baltimoreEmissions <- aggregate(Emissions ~ year, baltimoreNEI, sum)

# plot
par(mar = c(5.1, 5.1, 4.1, 2.1))

barplot(height = baltimoreEmissions$Emissions, 
        names.arg = baltimoreEmissions$year, 
        col = "gray50", 
        ylim = range(pretty(c(0, baltimoreEmissions$Emissions))), 
        main = expression("Balitmore City " * PM[2.5] * " Emissions by Year"), 
        xlab = "Year", 
        ylab = expression(PM[2.5] * " Emissions (tons)"), 
        axis.lty = 1)

# save to png file
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()