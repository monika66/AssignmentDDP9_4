# Load, subset, merge and mutate the two Swiss Forest Data Files for "Forest area in Switzerland, in hectare" and
# "Number of plantations in Swiss forest". 
# Write dataset ForestData.csv used for Shiny App AssignDDP94
setwd('C:/Users/acer/Desktop/Coursera/DDP9/94/AssignDDP94')
library(plyr)
library(tidyr)
# Read raw data and write joined data
ForestData <- read.csv("./rawdata/px-x-0703010000_101.csv", header = FALSE, sep = ";", quote = "\"")
FDrows <- nrow(ForestData)
ForestData <- subset(ForestData[3:FDrows, ])
ForestData <- subset(ForestData[which(ForestData$V2 == "Switzerland"), ])
PlantingData <- read.csv("./rawdata/px-x-0703030000_112.csv", header = FALSE, sep = ";", quote = "\"")
PDrows <- nrow(PlantingData)
PlantingData <- subset(PlantingData[3:PDrows, ])
PlantingData <- subset(PlantingData[which(PlantingData$V2 == "Switzerland"), ])
ForestData <- join(ForestData, PlantingData, by = c("V1", "V2", "V3",  "V4"), type = "left", match = "all")
names(ForestData)[8] <- "WoodSpecies"
names(ForestData)[9] <- "NrofPlantations"
ForestData <- spread(ForestData, WoodSpecies, NrofPlantations)
ForestData <- ForestData[ , c(1, 3:10)]
names(ForestData) <- c("Year", "Canton", "TypeofOwner", "NrofOwners", "TotalArea", "ProductiveArea", "Hardwood", "Softwood", "TotalSpecies")
write.csv(ForestData, file = "./ForestData.csv", row.names = FALSE)

