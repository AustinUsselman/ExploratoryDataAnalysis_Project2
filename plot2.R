# Loading dplyr for the %>% operator
if (!require("dplyr")) {
  install.packages("dplyr")
}
require("dplyr")

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
  group_by(year) %>%
  summarize(Total.Emissions.Baltimore = sum(Emissions, 
                                            na.rm = TRUE))

# plots the data
with(total_emissions, plot(x = year, 
                           y = Total.Emissions.Baltimore, 
                           ylab = "Total Annual Emissions [Tons]", 
                           xlab = "Year",
                           main = "Total Annual Emissions: Baltimore",
                           cex = 3,
                           pch = 3,
                           col = "blue",
                           lwd = 4))