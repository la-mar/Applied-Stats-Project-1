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

sf <- summary(fit)


options(max.print = 10000)
print(sf)


☺plot(fit)

cf <- coef(fit)

plot(cf)

pred <- predict(fit, data, s=lambda.best)
res <- residuals(fit, data, s=lambda.best)
rmse <- sqrt(mean((pred - data[[target_name]])^2))

plot(pred)

ols.fit <- fit
ols.res <- res
ols.lambda.best <- lambda.best
ols.coef <- cf
ols.pred <- pred
ols.rmse <- rmse

## ---- p1-lasso-reduced

# fit <- glmnetUtils::cv.glmnet(price.doc ~ ., data= data, alpha = 1)
fit <- glmnetUtils::cv.glmnet(price.doc ~ full.sq+life.sq+floor+max.floor+material+build.year+num.room+kitch.sq+state+area.m+raion.popul+green.zone.part+indust.part+children.preschool+preschool.quota+preschool.education.centers.raion+children.school+school.quota+school.education.centers.raion+school.education.centers.top.20.raion+hospital.beds.raion+healthcare.centers.raion+university.top.20.raion+sport.objects.raion+additional.education.raion+culture.objects.top.25.raion+shopping.centers.raion+office.raion+full.all+male.f+female.f+young.all+young.male+young.female+work.all+work.male+work.female+ekder.all+ekder.male+ekder.female+x0.6.all+x0.6.male+x0.6.female+x7.14.all+x7.14.male+x7.14.female+x0.17.all+x0.17.male+x0.17.female+x16.29.all+x16.29.male+x16.29.female+x0.13.all+x0.13.male+x0.13.female+raion.build.count.with.material.info+build.count.block+build.count.wood+build.count.frame+build.count.brick+build.count.monolith+build.count.panel+build.count.foam+build.count.slag+build.count.mix+raion.build.count.with.builddate.info+build.count.before.1920+build.count.1921.1945+build.count.1946.1970+build.count.1971.1995+build.count.after.1995+id.metro+metro.min.avto+metro.km.avto+metro.min.walk+metro.km.walk+kindergarten.km+school.km+park.km+green.zone.km+industrial.km+water.treatment.km+cemetery.km+incineration.km+railroad.station.walk.km+railroad.station.walk.min+id.railroad.station.walk+railroad.station.avto.km+railroad.station.avto.min+id.railroad.station.avto+public.transport.station.km+public.transport.station.min.walk+water.km+mkad.km+ttk.km+sadovoe.km+bulvar.ring.km+kremlin.km+big.road1.km+id.big.road1+big.road2.km+id.big.road2+railroad.km+zd.vokzaly.avto.km+id.railroad.terminal+bus.terminal.avto.km+id.bus.terminal+oil.chemistry.km+nuclear.reactor.km+radiation.km+power.transmission.line.km+thermal.power.plant.km+ts.km+big.market.km+market.shop.km+fitness.km+swim.pool.km+ice.rink.km+stadium.km+basketball.km+hospice.morgue.km+detention.facility.km+public.healthcare.km+university.km+workplaces.km+shopping.centers.km+office.km+additional.education.km+preschool.km+big.church.km+church.synagogue.km+mosque.km+theater.km+museum.km+exhibition.km+catering.km+green.part.500+prom.part.500+office.count.500+office.sqm.500+trc.count.500+trc.sqm.500+big.church.count.500+church.count.500+mosque.count.500+leisure.count.500+sport.count.500+market.count.500+green.part.1000+prom.part.1000+office.count.1000+office.sqm.1000+trc.count.1000+trc.sqm.1000+big.church.count.1000+church.count.1000+mosque.count.1000+leisure.count.1000+sport.count.1000+market.count.1000+green.part.1500+prom.part.1500+office.count.1500+office.sqm.1500+trc.count.1500+trc.sqm.1500+big.church.count.1500+church.count.1500+mosque.count.1500+leisure.count.1500+sport.count.1500+market.count.1500+green.part.2000+prom.part.2000+office.count.2000+office.sqm.2000+trc.count.2000+trc.sqm.2000+big.church.count.2000+church.count.2000+mosque.count.2000+leisure.count.2000+sport.count.2000+market.count.2000+green.part.3000+prom.part.3000+office.count.3000+office.sqm.3000+trc.count.3000+trc.sqm.3000+big.church.count.3000+church.count.3000+mosque.count.3000+leisure.count.3000+sport.count.3000+market.count.3000+green.part.5000+prom.part.5000+office.count.5000+office.sqm.5000+trc.count.5000+trc.sqm.5000+big.church.count.5000+church.count.5000+mosque.count.5000+leisure.count.5000+sport.count.5000+market.count.5000+rowsum, data = data, alpha = 1)

s <- summary(fit)

# glmnet::coef.cv.glmnet(fit, s=lambda.best)

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


