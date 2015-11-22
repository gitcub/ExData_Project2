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

## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?

# merge NEI and subsetted SCC data
mergeData <- merge(x = NEI, y = SCC, by = "SCC")

# isolate emissions related to coal combustion
coal <- mergeData[grep("Coal", mergeData$SCC.Level.Four), ]
coalcomb <- coal[grep("Combustion", coal$SCC.Level.One), ]
agg <- aggregate(Emissions ~ year, coalcomb, sum)

# plot
ggplot(data = agg, aes(x = factor(year), y = Emissions/1000)) +
    geom_bar(stat = "identity", width = 0.6, fill = "gray50") + 
    geom_text(aes(label = round(Emissions/1000, digits = 2), vjust = 1.5)) +
    ggtitle(expression("U.S. Coal Combustion " * PM[2.5] * " Emissions")) + 
    xlab("Year") + ylab(expression(PM[2.5] * " Emissions (kilotons)"))

# save to png file
dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()