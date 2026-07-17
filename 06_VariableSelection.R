# Sample Code for Variable Selections

# Create a model for SRS6, HK, and one for both sites. 

library(tidyverse)
library(VSURF)
library(parallel)
library(randomForest)

# Load data:
load( file='/Volumes/MaloneLab/Research/Mangrove_Synthesis/HarmonizedData.RDATA') 

data.final <- data.final %>%
  mutate( TIMESTAMP = as.POSIXct(date, format="%d-%b-%Y %H:%M:%S", tz="EST"),
  Date= as.Date(TIMESTAMP),
  YearMon = format(Date, "%Y-%m"))

data.final$geometry <- NULL
LS <- read.csv('/Volumes/MaloneLab/Research/Mangrove_Synthesis/Harmonized Landsat Sentinel/MANGROVE-SYNTHESIS-HLSS30-020-results.csv') %>% 
  mutate(Site = ID, Date = as.Date(Date)) 
LS[LS == -9999]<- NA

LS <-  LS %>% mutate( NDVI = (HLSS30_020_B05 - HLSS30_020_B04) / (HLSS30_020_B05 + HLSS30_020_B04),
                      EVI = 2.5 * ((HLSS30_020_B05 - HLSS30_020_B04) / (HLSS30_020_B05 + 6 * HLSS30_020_B04 -7.5 * HLSS30_020_B02 + 1))) 
LS$NDVI[ LS$NDVI < 0 ] <- NA
LS$EVI[ LS$EVI < 0 ] <- NA


data.sites <- data.final %>% left_join( LS, by=c('Site', "Date")) 
data.sites %>% summary


# Train and Test data


data.sub <- data.sites  %>% filter(Site == "HKMPM"| Site == "SRS6") %>% select(
  'date', 'Site', 'ERA5_2T',  'ERA5_ST', 'ERA5_Turb', 'ERA5_SW_IN', 'ERA5_TP',
  'ERA5_VPD',   'ERA5_WS', 'ERA5_NetRad',  'LANDSAT_NDVI', 
  'MODIS_NDVI', 'MODIS_LAI', 'NEE', 'FCH4', "MangroveHeight", "NDVI", 'EVI') %>% na.omit

# Landsat Sentinel Data:
# Calculate Indices:

data.train <- data.sub %>% sample_frac(0.25) 
data.test <- anti_join(data.sub, data.train)




# Correlation Matrix
data.train %>% names
sum.MT <- data.train[, c(3:18)] %>% na.omit()
summary( sum.MT)
M <- cor(sum.MT)
corrplot::corrplot(M, method="circle")



HKMP_rf_index.vsurf <- VSURF(data.train[, c(3:13, 15:18)], data.train[, 14], ntree = 500,
                            RFimplem = "randomForest", 
                            clusterType = "PSOCK", 
                            verbose = TRUE,
                            ncores = detectCores() - 2, parallel= TRUE)

HKMP_rf_index.vars <-names( data.train[, c(3:13, 15:18)]) [HKMP_rf_index.vsurf$varselect.thres] 

HKMP_rf_index <- randomForest( FCH4 ~ .,
                              data= data.train,
                              importance=TRUE,
                              predicted=TRUE,
                              keep.inbag=TRUE)

HKMP_rf_index 

varImpPlot(HKMP_rf_index)

data.train$HKMP_rf_index <- predict(HKMP_rf_index , data.train)
data.test$HKMP_rf_index <- predict(HKMP_rf_index , data.test)

lm( data = data.test, FCH4 ~ HKMP_rf_index ) %>%  summary

# Save Model 
save(HKMP_rf_index, data.HKMP.test, data.HKMP.train,HKMP_rf_index.vars , file="RF_Models.RDATA")
