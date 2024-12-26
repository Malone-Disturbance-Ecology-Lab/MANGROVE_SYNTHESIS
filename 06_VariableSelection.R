# Sample code for Variable selections

load( file='/Volumes/MaloneLab/Research/Mangrove_Synthesis/HarmonizedData.RDATA')
data %>% names
# Train and Test data
data.sites <- data %>% select("date", "ERA5_2T","ERA5_ST","ERA5_Turb","ERA5_SW_IN",
                "ERA5_TP","ERA5_VPD","ERA5_WS","ERA5_NetRad","LANDSAT_NDVI", "Site")

train <- data.sites %>% sample_frac(0.5) 

test <- anti_join(data.sites, train, by= 'date')

data.sites %>% summary
train  %>% summary
test  %>% summary

train  %>% names
# Correlation Matrix
sum.MT <- train[, c(2:10)] %>% na.omit()
summary( sum.MT)
M <- cor(sum.MT)
corrplot::corrplot(M, method="circle")


library(VSURF)
library(parallel)



T80_rf_index.vsurf <- VSURF(train[, c(2:10)], train[, 36], ntree = 500,
                            RFimplem = "randomForest", 
                            clusterType = "PSOCK", 
                            verbose = TRUE,
                            ncores = detectCores() - 2, parallel= TRUE)

T80_rf_index.vars <-names( train[, c(3:6, 8:9, 15:19, 25, 35)]) [T80_rf_index.vsurf$varselect.pred] 

T80_rf_index <- randomForest( rec.status ~ .,
                              data= train %>% select(c(rec.status, all_of(T80_rf_index.vars))),
                              importance=TRUE,
                              predicted=TRUE,
                              keep.inbag=TRUE)

T80_rf_index 

varImpPlot(T80_rf_index)

train$T80_rf_index <- predict(T80_rf_index , train)
# Save Model 

save(T80_rf_index, test, train,T80_rf_index.vars , file="RF_threshold_index.RDATA")
