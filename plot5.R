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

vehicle_SCC <- SCC[grep("[Vv]eh", SCC$Short.Name), ]

emissions_Baltimore <- NEI %>% 
  subset(fips == "24510" & NEI$SCC %in% vehicle_SCC$SCC) %>%
  merge(y = vehicle_SCC, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(Vehicle.Emissions.Type = sum(Emissions, na.rm = TRUE))


emissions_plot <- ggplot(emissions, aes(year, Vehicle.Emissions.Type)) +
  geom_point(color = "blue", 
             size = 4, 
             alpha = 1,shape = 6) + 
  xlab("Year") +
  ylab("Total Emissions [Tons]") +
  ggtitle("Total Annual Vehicle Emissions: Baltimore")

emissions_plot