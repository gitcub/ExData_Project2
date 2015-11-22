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

## Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California (fips == 
## "06037"). Which city has seen greater changes over time in motor vehicle 
## emissions?

# merge NEI and subsetted SCC data
mergeData <- merge(x = NEI, y = SCC, by = "SCC")

# isolate Baltimore and LA emissions related to motor vehicles
baltimore <- mergeData[mergeData$fips == "24510", ]
baltimore$city <- "Baltimore City"

la <- mergeData[mergeData$fips == "06037", ]
la$city <- "Los Angeles"

cities <- rbind(baltimore, la)
citiesVehicles <- cities[grep("Vehicle", cities$SCC.Level.Two), ]

# plot
ggplot(data = citiesVehicles, aes(x = factor(year), y = Emissions)) +
    geom_bar(stat = "identity", width = 0.6, fill = "gray50") + 
    facet_grid(.~city) +
    ggtitle(expression("Motor Vehicle " * PM[2.5] * " Emissions")) + 
    xlab("Year") + ylab(expression(PM[2.5] * " Emissions (tons)"))

# save to png file
dev.copy(png, file = "plot6.png", height = 480, width = 480)
dev.off()