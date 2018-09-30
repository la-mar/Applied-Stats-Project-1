# Vignette: http://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html

# Source external R dependencies
source("src/setup.R")
source("src/functions.R")
source("src/import-and-clean-datasets.R")

# load(file="data/train.RData")

require(glmnet)
require(glmnetUtils)

require(Sleuth3)

sat <- case1201
sat$ltakers <- log(sat$Takers)
sat[-29,2] %>% dim()
sat[1,4:9] %>% dim()
sat[-29,1] %>% dim()


data <- train %>% dplyr::select(-id, -timestamp) %>% na.omit()

# data %>% colnames()


fit <- glmnetUtils::cv.glmnet(price.doc ~ ., data= data, alpha = 1)


plot(fit)

##Optimal tuning parameter
lambda.best <- min(fit$lambda)

##Check parameter estimates for the optimal model
c <- coef(fit, s=lambda.best)

plot(c)

lasso.pred <- predict(fit, data, s=lambda.best)
lasso.rmse <- sqrt(mean((lasso.pred - data$price.doc)^2))

plot(lasso.pred)

lasso.rmse


#######################

colnames(x)

sat <- train_small
sat$ltakers <- log(sat$Takers)
head(sat)

####################
##Ridge Regression##
####################

t.glmnet <- cv.glmnet(x, y, alpha=0)
attributes(train_small.glmnet)

##Optimal tuning parameter
best.lambda <- t.glmnet$lambda.min

##Check parameter estimates for the optimal model
coef(t.glmnet, s=best.lambda)

#########
##Lasso##
#########

sat.glmnet2 <- cv.glmnet(as.matrix(sat[-29,4:9]), sat[-29,2], alpha=1)

##Optimal tuning parameter
best.lambda2 <- sat.glmnet2$lambda.min

##Check parameter estimates for the optimal model
coef(sat.glmnet2, s=best.lambda2)

###############
##Elastic Net##
###############

##Note to use the elastic net we must tune both alpha and lambda
##The easiest way to do this is to utilize a powerful package for
##many model fitting procedures: caret

#install.packages("caret")
library(caret)

tcontrol <- trainControl(method="repeatedcv", number=10, repeats=5)

sat.glmnet3 <- train(as.matrix(sat[-29,4:9]), sat[-29,2], trControl=tcontrol,
                     method="glmnet", tuneLength=10)
attributes(sat.glmnet3)
sat.glmnet3$results
##Note it actually says the lasso is best
sat.glmnet3$bestTune

sat.glmnet4 <- sat.glmnet3$finalModel
coef(sat.glmnet4, s=sat.glmnet3$bestTune$lambda)

###########################################
##Check predictive strength of the models##
###########################################

lm.sat <- lm(SAT ~ Income + Years + Expend + Rank, data=sat[-29,])

ridge.pred <- predict(sat.glmnet, as.matrix(sat[-29,4:9]), s=best.lambda)
ridge.rmse <- sqrt(mean((ridge.pred - sat[-29,2])^2))

lasso.pred <- predict(sat.glmnet2, as.matrix(sat[-29,4:9]), s=best.lambda2)
lasso.rmse <- sqrt(mean((lasso.pred - sat[-29,2])^2))

en.pred <- predict(sat.glmnet4, as.matrix(sat[-29,4:9]), s=sat.glmnet3$bestTune$lambda)
en.rmse <- sqrt(mean((en.pred - sat[-29,2])^2))

stepwise.pred <- predict(lm.sat, sat[-29,4:9])
stepwise.rmse <- sqrt(mean((stepwise.pred - sat[-29,2])^2))






















