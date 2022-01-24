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

emissions_la <- NEI %>% 
  subset(fips == "06037" & NEI$SCC %in% vehicle_SCC$SCC) %>%
  merge(y = vehicle_SCC, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(Vehicle.Emissions.Type = sum(Emissions, na.rm = TRUE))

emissions_baltimore2 <- cbind(emissions_Baltimore, "City" = rep("Baltimore", 4))
emissions_la2 <- cbind(emissions_la, "City" = rep("LA", 4))

emissions_total <- rbind(emissions_baltimore2, emissions_la2)

emissions_total_plot <- ggplot(emissions_total, aes(year, Vehicle.Emissions.Type, col = City)) +
  geom_point(size = 6, 
             alpha = 1,
             shape = 6) +
  xlab("Year") +
  ylab("Total Emissions [Tons]") +
  ggtitle("Comparison of Total Annual Vehicle Emissions: Baltimore vs Los Angeles")

emissions_total_plot