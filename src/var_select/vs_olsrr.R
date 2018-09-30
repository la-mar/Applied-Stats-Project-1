
# Source external R dependencies
source("src/setup.R")
source("src/functions.R")

require(olsrr)







library(ppcor)

X <- train %>% 
  select_if(is.numeric) %>% 
  dplyr::select(contains('cafe_count')) %>%
  na.omit() %>%
  dplyr::select(1:5)


library(GGally)
ggpairs(X)

# r <- pcor(X, method = "pearson")

# r 


# re <- r$estimate

# re %>% class()
