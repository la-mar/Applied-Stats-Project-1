# Source external R dependencies
source("src/setup.R")
source("src/functions.R")
source("src/import-and-clean-datasets.R")


require(glmnet)
require(glmnetUtils)


data <- train_reduced #%>% dplyr::select(-sub.area) %>% na.omit()

## ---- p1-ols-reduced

# fit <- glmnetUtils::cv.glmnet(price.doc ~ ., data= data, alpha = 1)
fit <- lm(exp_reduced_log, data= data)

summary(fit)

plot(fit)

c <- coef(fit)

plot(c)

pred <- predict(fit, data, s=lambda.best)
res <- residuals(fit, data, s=lambda.best)
rmse <- sqrt(mean((pred - data[[target_name]])^2))

plot(pred)

ols.fit <- fit
ols.res <- res
ols.lambda.best <- lambda.best
ols.coef <- c
ols.pred <- pred
ols.rmse <- rmse

## ---- p1-lasso-reduced

# fit <- glmnetUtils::cv.glmnet(price.doc ~ ., data= data, alpha = 1)
fit <- glmnetUtils::cv.glmnet(exp_reduced, data= data, alpha = 1)

summary(fit)

plot(fit)

##Optimal tuning parameter
lambda.best <- min(fit$lambda)

##Check parameter estimates for the optimal model
c <- coef(fit, s=lambda.best)

plot(c)

pred <- predict(fit, data, s=lambda.best)
rmse <- sqrt(mean((pred - data[[target_name]])^2))

plot(pred)

lasso.fit <- fit
lasso.lambda.best <- lambda.best
lasso.coef <- c
lasso.pred <- pred
lasso.rmse <- rmse


