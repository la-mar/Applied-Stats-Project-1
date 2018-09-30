

# Source external R dependencies
source("src/setup.R")
source("src/functions.R")



### Import Train ###

train <- read.csv('data/train.csv') %>% as.tibble()

train <- train %>%
  rename_all(
      funs(
        stringr::str_to_lower(.) %>%
        stringr::str_replace_all(., '_', '.')
      ) 
  ) %>%
  mutate(id = as.character(id))


save(train, file="data/train.RData")

### Import Test ###

test <- read.csv('data/test.csv') %>% as.tibble()

test <- test %>%
  rename_all(
    funs(
      stringr::str_to_lower(.) %>%
        stringr::str_replace_all(., '_', '.')
    )
  )


save(test, file="data/test.RData")


##############################
#         Summarize          #
##############################

# Summarize dataset
train.summary <- descr(train) %>% round(2)
train.summary <- train.summary %>% rownames_to_column() %>%rename("column_name" = 1)
save(train.summary, file="data/trainSummary.RData")

# Write summary to file
train.summary %>% write.csv('data/train_summary.csv')



##############################
### Generate feature lists ###
##############################


### Saturated ###
cnames_saturated <- train %>% colnames() # Capture all column names in original dataset
cnames_saturated <- cnames_saturated %>% paste(collapse="+") # Collapse list of names into one string delimited by '+'
exp_saturated <- paste(target_name, "~", paste(cnames_saturated)) # Create expression


### Saturated - No Timeseries ###
cnames_saturated_nts <- train %>% # Capture all column names in original dataset
                            select(-timestamp, -id) %>%
                            colnames() 
cnames_saturated_nts <- cnames_saturated_nts %>% paste(collapse="+") # Collapse list of names into one string delimited by '+'
exp_saturated_nts <- paste(target_name, "~", paste(cnames_saturated_nts)) # Create expression


### Reduced ###

cafe_counts <- train %>% 
                  # select_if(is.numeric) %>% 
                  select(id, contains('cafe.count')) %>%
                  mutate(id = as.character(id)) %>%
                  na.omit() %>%
                  replace(is.na(.), 0) %>%
                  mutate(rowsum = rowSums(select_if(., is.numeric))) %>%
                  select(id, rowsum)
              


train_reduced <- train %>% 
                  left_join(cafe_counts, by = c("id","id")) %>%
                  select(-contains('cafe.count'), -timestamp, -id, -sub.area) %>%
                  select_if(negate(is.factor)) %>%
                  mutate(price.log = log(price.doc)) %>%
                  na.omit()
                  
                  

cnames_reduced <- train_reduced %>%
                    select(-price.doc, -price.log) %>%
                    colnames() %>% 
                    paste(collapse="+")

exp_reduced <- paste(target_name, "~", paste(cnames_reduced))
exp_reduced_log <- paste('price.log', "~", paste(cnames_reduced))


### Reduced_1 ###

# Reduced - Categorically remove as much as possible
cnames_red1 <-
train %>%
  dplyr::select(  -price.doc
                , -id
                , -timestamp # explicit exclusions
                , -starts_with("cafe.count")
                , -contains("sqm")
                , -starts_with("ID.")
                , -contains("5000")
                , -contains("500")
                , -contains("avto")
                , -contains("km")
                , -contains("raion")
                , -matches("\\d{1,4}") #
                ) %>%
  colnames() 

# Save names to csv
cnames_save(cnames_red1)

# Collapse list of names into one string delimited by '+'
cnames_red1 <- cnames_red1 %>% paste(collapse="+")

# Create expression
exp_red1 <- paste(target_name, "~", paste(cnames_red1))


### Reduced_2 ###

# Reduced - Categorically remove as much as possible
cnames_red2 <-
train %>%
  dplyr::select(  -price.doc
                , -id
                , -timestamp 
                , -sub.area # explicit exclusions
                , -starts_with("cafe.count")
                , -contains("sqm")
                , -starts_with("ID.")
                , -contains("5000")
                , -contains("500")
                , -contains("avto")
                , -contains("km")
                , -contains("raion")
                , -matches("\\d{1,4}")
                , -contains("count")
                , -contains("all")
                , -contains("walk")
                , -contains("quota")
                ) %>%
  colnames()

# Save names to csv
cnames_save(cnames_red2)

# Collapse list of names into one string delimited by '+'
cnames_red2 <- cnames_red2 %>% paste(collapse="+")

# Create expression
exp_red2 <- paste(target_name, "~", paste(cnames_red2))

