
# test
source("src/setup.R")
source("src/functions.R")
load(file="data/train.RData")
load(file="data/trainSummary.RData")


# Boxplot per Feature

ggplot(train.summary, aes(x = as.factor(column_name))) +
  geom_boxplot(aes(
      lower = Mean - Std.Dev,
      upper = Mean + Std.Dev,
      middle = Mean,
      ymin = Mean - 3*Std.Dev,
      ymax = Mean + 3*Std.Dev),
    stat = "identity") +
  ggtitle("Feature Variance") +
  xlab("Features") +
  ylab("Variation") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(angle=90, vjust=0.5),
        axis.text.y = element_text(size=8, margin = margin(t = 20, b = 20, l = 20)),
        plot.title = element_text(hjust = 0.5, size = 16)) +
  ylim(-1000, 1000) +
coord_flip()
