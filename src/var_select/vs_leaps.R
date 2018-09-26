# Source external R dependencies
source("src/setup.R")
source("src/functions.R")


exp_red2

lps <-  regsubsets(price.doc ~ full.sq+life.sq+floor+max.floor+material+build.year+num.room+kitch.sq+state+product.type+sub.area+area.m+green.zone.part+indust.part+children.preschool+children.school+male.f+female.f+young.male+young.female+work.male+work.female+ekder.male+ekder.female+ecology
                   , data = train
                   , nbest = 1
                   , nvmax = 3
                   , really.big = T)

# view results
summary(lps)



# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(lps,scale="r2")

# plot statistic by subset size
library(car)
subsets(lps, statistic="rsq")
