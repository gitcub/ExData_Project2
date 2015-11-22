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

## Of the four types of sources indicated by the type (point, nonpoint, onroad, 
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999–2008 for Baltimore City? Which have seen increases in 
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
## answer this question.

# isolate variables of interest
baltimoreNEI <- NEI[NEI$fips == "24510", ]

# plot
ggplot(data = baltimoreNEI, aes(x = factor(year), y = log(Emissions))) +
    geom_boxplot(aes(fill = "type")) + 
    facet_grid(type~.) + theme(legend.position = "none") +
    ggtitle(expression("Balitmore City " * PM[2.5] * " Emissions by Type")) + 
    xlab("Year") + ylab(expression("Log of " * PM[2.5] * " Emissions (tons)"))

# save to png file
dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()