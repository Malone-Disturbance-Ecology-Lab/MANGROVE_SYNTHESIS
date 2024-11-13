# Multidimensional scaling of site data:

library(stringr)

# Data is on the MaloneLab server:

files <- list.files( '/Volumes/MaloneLab/Research/Mangrove_Synthesis/ERA_Site_DATA', full.names = TRUE)
file.names <- list.files( '/Volumes/MaloneLab/Research/Mangrove_Synthesis/ERA_Site_DATA', full.names = FALSE)

data <- data.frame( dates = as.character(), ERA5_2T = as.numeric(), ERA5_ST = as.numeric(), ERA5_Turb= as.numeric(), ERA5_SW_IN = as.numeric(), ERA5_TP= as.numeric(), ERA5_VPD= as.numeric(), ERA5_WS= as.numeric(), ERA5_NetRad= as.numeric(), Site= as.character())

for(i in 1:length(file.names)){
  print(i)
  site1 <- read.csv( files[i])
  site1$Site <- str_split(file.names, "_") [[i]] [[3]]  %>% unlist %>% str_replace(".csv", "") %>% unlist
  data <- rbind( data, site1 )
}

# Format the date:


# Create a summary of the data for a simple MDS
library(tidyverse)
Data.summary.25 <- data %>% reframe( .by=Site, 
                                  ERA5_2T = quantile(ERA5_2T , 0.25),
                                  ERA5_ST = quantile(ERA5_ST , 0.25),
                                  ERA5_Turb = quantile(ERA5_Turb , 0.25),
                                  ERA5_SW_IN = quantile(ERA5_SW_IN , 0.25),
                                  ERA5_TP = quantile(ERA5_TP , 0.25),
                                  ERA5_VPD = quantile(ERA5_VPD , 0.25),
                                  ERA5_WS = quantile(ERA5_WS , 0.25),
                                  ERA5_NetRad = quantile(ERA5_NetRad , 0.25),
                                  Quantile=0.25 %>% as.factor)

Data.summary.5 <- data %>% reframe( .by=Site, 
                                     ERA5_2T = quantile(ERA5_2T , 0.5),
                                     ERA5_ST = quantile(ERA5_ST , 0.5),
                                     ERA5_Turb = quantile(ERA5_Turb , 0.5),
                                     ERA5_SW_IN = quantile(ERA5_SW_IN , 0.5),
                                     ERA5_TP = quantile(ERA5_TP , 0.5),
                                     ERA5_VPD = quantile(ERA5_VPD , 0.5),
                                     ERA5_WS = quantile(ERA5_WS , 0.5),
                                     ERA5_NetRad = quantile(ERA5_NetRad , 0.5),
                                     Quantile=0.5 %>% as.factor)

Data.summary.75 <- data %>% reframe( .by=Site, 
                                     ERA5_2T = quantile(ERA5_2T , 0.75),
                                     ERA5_ST = quantile(ERA5_ST , 0.75),
                                     ERA5_Turb = quantile(ERA5_Turb , 0.75),
                                     ERA5_SW_IN = quantile(ERA5_SW_IN , 0.75),
                                     ERA5_TP = quantile(ERA5_TP , 0.75),
                                     ERA5_VPD = quantile(ERA5_VPD , 0.75),
                                     ERA5_WS = quantile(ERA5_WS , 0.75),
                                     ERA5_NetRad = quantile(ERA5_NetRad , 0.75),
                                     Quantile=0.75 %>% as.factor)

Data.Summary <- rbind(Data.summary.25, Data.summary.5, Data.summary.75 )

Data.summary.annual <- data %>% reframe( .by=Site, 
                                    ERA5_2T = quantile(ERA5_2T , 0.5),
                                    ERA5_ST = quantile(ERA5_ST , 0.5),
                                    ERA5_Turb = quantile(ERA5_Turb , 0.5),
                                    ERA5_SW_IN = quantile(ERA5_SW_IN , 0.5),
                                    ERA5_TP = quantile(ERA5_TP , 0.5),
                                    ERA5_VPD = quantile(ERA5_VPD , 0.5),
                                    ERA5_WS = quantile(ERA5_WS , 0.5),
                                    ERA5_NetRad = quantile(ERA5_NetRad , 0.5),
                                    Quantile=0.5 %>% as.factor)


# Scaling:
distance <- dist(Data.Summary[, 2:10] ) # euclidean distances between the rows
fit <- cmdscale(distance ,eig=TRUE, k=2)

Data.Summary$x <- fit$points[,1]
Data.Summary$y <- fit$points[,2]

library(ggplot2)

ggplot( data = Data.Summary) + geom_point( aes(x= x , y = y, col = Site, shape = Quantile ))


distance.annual <- dist(Data.summary.annual[, 2:10] ) # euclidean distances between the rows
fit.annual<- cmdscale(distance.annual ,eig=TRUE, k=4)

Data.Summary$x.annual <- fit.annual$points[,1]
Data.Summary$y.annual <- fit.annual$points[,2]

ggplot( data = Data.Summary) + geom_point( aes(x= x.annual , y = y.annual, col = Site, shape = Quantile ))

