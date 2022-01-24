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

total_emissions <- NEI %>% 
  subset(fips == "24510") %>%
  group_by(year, type) %>%
  summarize(Total.Emissions.Type = sum(Emissions, na.rm = TRUE))

emissions_type <- ggplot(data = total_emissions, aes(year, Total.Emissions.Type))

emissions_type <- emissions_type + 
  geom_point(color = "blue", 
             size = 4, 
             alpha = 1, shape = 6) + 
  facet_grid(. ~ type) +
  xlab("Year") +
  ylab("Total Emissions [Tons]") +
  ggtitle("Total Annual Emissions: Baltimore")

emissions_type