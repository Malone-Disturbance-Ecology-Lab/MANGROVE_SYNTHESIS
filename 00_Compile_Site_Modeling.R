# Author: Sparkle L. Malone
# This Code further compiles data:

library(stringr)
library(tidyverse)
library(ggplot2)
library(usedist)
library(sf)
library(terra)
library(gtools)

# Import Canopy Height data

# Only Run Once:
# setwd('/Volumes/MaloneLab/Research/Mangrove_Synthesis/Canopy_Height/CMS_Global_Mangrove_Forest_Ht_2251/data')
# files <- list.files( pattern=".tif") # Makes a list of all the files in the directory
# vrt(files, filename="CanopyHeight") # Makes a mosiac of all the files in the list and maes a Conopy Height Object

CHeight <- rast( '/Volumes/MaloneLab/Research/Mangrove_Synthesis/Canopy_Height/CMS_Global_Mangrove_Forest_Ht_2251/data/CanopyHeight') # Imports the canopy Height object to use

# Import the site file and extract Canopy Height:
sites <- read.csv( '/Volumes/MaloneLab/Research/Mangrove_Synthesis/Site_Information/Site_Information.csv', fileEncoding="latin1") %>% st_as_sf(                        
               coords = c("Longitude", "Latitude"), crs = 4326)

sites.buffer <- sites %>% st_buffer(100) # Makes a buffer 
sites$CHeight <- extract(CHeight, sites.buffer, fun="max")$CanopyHeight # Extract height for the buffer

# Imports the other data 
files <- list.files( '/Volumes/MaloneLab/Research/Mangrove_Synthesis/RF_Model_All_Variable_DATA', full.names = FALSE)
data <- data.frame( dates = as.character(), 
                    ERA5_2T = as.numeric(), 
                    ERA5_ST = as.numeric(), 
                    ERA5_Turb= as.numeric(), 
                    ERA5_SW_IN = as.numeric(), 
                    ERA5_TP= as.numeric(), 
                    ERA5_VPD= as.numeric(), 
                    ERA5_WS= as.numeric(), 
                    ERA5_NetRad= as.numeric(),
                    P_runningsum = as.numeric(),
                    MODIS_NDVI = as.numeric(), 
                    MODIS_LAI = as.numeric(), 
                    LANDSAT_NDVI = as.numeric(),
                    Site= as.character())

for(i in 1:length(files)){
print(i)
  setwd('/Volumes/MaloneLab/Research/Mangrove_Synthesis/RF_Model_All_Variable_DATA')
site1 <- read.csv( files[i])
site1 %>% names
site1$Site <- str_split(files, "_") [[i]] [[3]]  %>% unlist %>% str_replace(".csv", "") %>% unlist
data <- smartbind( data, site1 ) }

# merge data with site simple feature:
data.final <- data %>% left_join(sites, by= 'Site') %>% mutate( MangroveHeight = coalesce(Canopy_Height_Max, CHeight ))

# Export: 
save( data.final, file='/Volumes/MaloneLab/Research/Mangrove_Synthesis/HarmonizedData.RDATA')

