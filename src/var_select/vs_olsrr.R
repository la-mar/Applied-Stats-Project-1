
# Source external R dependencies
source("src/setup.R")
source("src/functions.R")

require(olsrr)

model <- lm(price.doc~full.sq+life.sq+floor+max.floor+material+build.year+num.room+kitch.sq+state+product.type+sub.area+area.m+green.zone.part+indust.part+children.preschool+preschool.quota+children.school+school.quota+full.all+male.f+female.f+young.all+young.male+young.female+work.all+work.male+work.female+ekder.all+ekder.male+ekder.female+build.count.block+build.count.wood+build.count.frame+build.count.brick+build.count.monolith+build.count.panel+build.count.foam+build.count.slag+build.count.mix+metro.min.walk+railroad.station.walk.min+public.transport.station.min.walk+ecology
                   , data = train)

p <- ols_step_best_subset(model)

plot(p)

main <- function() {
 print("hi")
}

if(interactive()) {
    main()
}