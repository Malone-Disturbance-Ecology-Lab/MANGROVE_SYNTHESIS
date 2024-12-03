# Sample code for Variable selections

# Train and Test data

train <- stratified(driver.analysis, c("Severity","PostDateDif",
                                       "pdsi.index","freq.index",
                                       "model.NDVI", "PreNDVI", "Threshold"), 0.5)

train <- driver.analysis %>%
  sample_frac(0.5) 

test <- anti_join(driver.analysis, train, by= 'ptID')


driver.analysis %>% summary
train  %>% summary
test  %>% summary

# Correlation Matrix
train %>% names
sum.MT <- train[, c(3:6, 8:10,16:21,23, 25:27)] %>% na.omit()
summary( sum.MT)
M <- cor(sum.MT)
corrplot::corrplot(M, method="circle")


library(VSURF)
library(parallel)


train[, c(3:6, 8:9, 15:19, 25, 35)] %>% names()

T80_rf_index.vsurf <- VSURF(train[, c(3:6, 8:9, 15:19, 25, 35)], train[, 36], ntree = 500,
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
