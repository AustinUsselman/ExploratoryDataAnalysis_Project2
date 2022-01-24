# Loading dplyr for the %>% operator
if (!require("dplyr")) {
  install.packages("dplyr")
}
require("dplyr")

if (!require("ggplot2")) {
  install.packages("ggplot2")
}
require("ggplot2")

# Importing the data
filename <- "exdata_data_NEI_data.zip"

if(!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename, method="curl")
}

# Checking if file exists
if (!file.exists("Source_Classification_Code.rds") || !file.exists("summarySCC_PM25.rds")) { 
  unzip(filename) 
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCC_coal <- SCC[grep("[Cc]oal",SCC$EI.Sector),]
NEI_coal <- subset(NEI, 
                   NEI$SCC %in% SCC_coal$SCC)


NEI_coal_merg <- merge(x = NEI_coal, 
                       y = SCC, 
                       by.x = "SCC", 
                       by.y = "SCC")

NEI_coal_total <- NEI_coal_merg %>% 
  group_by(year) %>%
  summarize(Total.Coal.Comb = sum(Emissions, na.rm = TRUE))

NEI_plot <- ggplot(NEI_coal_total, aes(year, Total.Coal.Comb))

NEI_plot <- NEI_plot + 
  geom_point(color = "blue", 
             size = 4, 
             alpha = 1,shape = 6) + 
  xlab("Year") +
  ylab("Total Emissions [Tons]") +
  ggtitle("Total Annual Coal Combustion Emissions")

NEI_plot