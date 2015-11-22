library(ggplot2)

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

## How have emissions from motor vehicle sources changed from 1999–2008 in 
## Baltimore City?

# merge NEI and subsetted SCC data
mergeData <- merge(x = NEI, y = SCC, by = "SCC")

# isolate Baltimore City emissions related to motor vehicles
baltimore <- mergeData[mergeData$fips == "24510", ]
vehicles <- baltimore[grep("Vehicle", baltimore$SCC.Level.Two), ]

# plot
ggplot(data = vehicles, aes(x = factor(year), y = Emissions)) +
    geom_bar(stat = "identity", width = 0.6, fill = "gray50") + 
    ggtitle(expression("Baltimore City Motor Vehicle " * PM[2.5] * " Emissions")) + 
    xlab("Year") + ylab(expression(PM[2.5] * " Emissions (tons)"))

# save to png file
dev.copy(png, file = "plot5.png", height = 480, width = 480)
dev.off()