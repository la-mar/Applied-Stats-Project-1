
# Source external R dependencies
source("src/setup.R")
source("src/functions.R")


load(file="data/train.RData")

library(MASS)

lm <- lm(exp_red2
, data = train)

coef <- lm$coefficients
## (Intercept)      Agriculture      Examination        Education         Catholic
## 66.9151817       -0.1721140       -0.2580082       -0.8709401        0.1041153
## Infant.Mortality
## 1.0770481

st1 <- stepAIC(lm, direction = "both")
st2 <- stepAIC(lm, direction = "forward")
st3 <- stepAIC(lm, direction = "backward")

############################################

sink('src/var_select/stepwise_mass_red2.txt')
print(exp_red2)
print(paste("AIC: ", AIC(st1)))
print(anova(st1))
print(coef)
print(summary(st1))
sink()

pdf('src/var_select/stepwise_mass_red2.pdf')
plot(st1)
dev.off()

############################################

sink('src/var_select/forward_mass_red2.txt')
print(exp_red2)
print(paste("AIC: ", AIC(st2)))
print(anova(st2))
print(coef)
summary(st2)
sink()

pdf('src/var_select/forward_mass_red2.pdf')
plot(st2)
dev.off()

############################################

sink('src/var_select/backward_mass_red2.txt')
print(exp_red2)
print(paste("AIC: ", AIC(st3)))
print(anova(st3))
print(coef)
summary(st3)
sink()

pdf('src/var_select/backward_mass_red2.pdf')
plot(st3)
dev.off()

############################################


