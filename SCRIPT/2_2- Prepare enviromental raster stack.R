################################################################################

#                       Prepare Environmental raster data

################################################################################

# Load the necessary packages
library(terra)

# Load the environmental raster  at 50 m of spatial resolution
myExpl_0 <- rast("./INPUT/RASTER/environmental_100m_standardized.tiff")

# # Get only the selected variables
myExpl <- subset(myExpl_0, c("soc", "sand", "roads",
                             "green", "fla", 'rivers')
                             ) 


