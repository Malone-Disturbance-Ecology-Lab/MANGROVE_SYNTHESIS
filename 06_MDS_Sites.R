# Multidimensional scaling of site data: https://uc-r.github.io/kmeans_clustering

# This analysis is done by quantile, month, and annual for each site to understand dissimilarity between the dites:

library(stringr)
library(factoextra)
library(tidyverse)
library(ggplot2)
library( usedist)
library(ggforce)

# Data is on the Malone Lab server:
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
data$dates <- format( data$dates , format="%Y%m%d%H")


# Create a summary of the data for a simple MDS
Data.summary.annual <- data %>% reframe( .by=Site, 
                                     ERA5_2T = quantile(ERA5_2T , 0.5),
                                     ERA5_ST = quantile(ERA5_ST , 0.5),
                                     ERA5_Turb = quantile(ERA5_Turb , 0.5),
                                     ERA5_SW_IN = quantile(ERA5_SW_IN , 0.5),
                                     ERA5_TP = quantile(ERA5_TP , 0.5),
                                     ERA5_VPD = quantile(ERA5_VPD , 0.5),
                                     ERA5_WS = quantile(ERA5_WS , 0.5),
                                     ERA5_NetRad = quantile(ERA5_NetRad , 0.5),
                                    
                                    ERA5_2T.var = var(ERA5_2T),
                                    ERA5_ST.var = var(ERA5_ST),
                                    ERA5_Turb.var = var(ERA5_Turb),
                                    ERA5_SW_IN.var = var(ERA5_SW_IN),
                                    ERA5_TP.var = var(ERA5_TP),
                                    ERA5_VPD.var = var(ERA5_VPD),
                                    ERA5_WS.var = var(ERA5_WS ),
                                    ERA5_NetRad.var = var(ERA5_NetRad ))

# Scaling:
Data.summary.annual %>% names
distance.annual <- dist(Data.summary.annual[, 2:17] %>% scale ) # euclidean distances between the rows
distance.annual <- dist_setNames(distance.annual, Data.summary.annual$Site[1:8])
fit.annual <- cmdscale(distance.annual ,eig=TRUE, k=2)

Data.summary.annual$x.annual <- fit.annual$points[,1]
Data.summary.annual$y.annual <- fit.annual$points[,2]

# Cluster analysis and Explanation of clusters:
library(caret)

cluster.annual <- distance.annual %>% kmeans( centers = 3, nstart = 30)
Data.summary.annual$cluster.annual <- cluster.annual$cluster %>% as.factor

ggplot( data = Data.Summary, aes(x= x.annual , y = y.annual, col = cluster.annual, label=Site )) + geom_point( ) + geom_text(nudge_y = 0.15, nudge_x =- 0.15, size = 2) 

fviz_dist(distance.annual, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

fviz_cluster(cluster.annual, data= Data.Summary[, c('x.annual', 'y.annual')])
