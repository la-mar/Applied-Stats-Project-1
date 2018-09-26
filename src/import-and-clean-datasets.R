

# Source external R dependencies
source("src/setup.R")
source("src/functions.R")

train <- read.csv('data/train.csv') %>% as.tibble()

train <- train %>%
  rename_all(
      funs(
        stringr::str_to_lower(.) %>%
        stringr::str_replace_all(., '_', '.')
      )
  )


save(train, file="data/train.RData")

# Preview column names and types
# train %>% str()
# train %>% head()


# Summarize dataset
train.summary <- descr(train) %>% round(2)
train.summary <- train.summary %>% rownames_to_column() %>%rename("column_name" = 1)
save(train.summary, file="data/trainSummary.RData")

# Write summary to file
train.summary %>% write.csv('data/train_summary.csv')

### Generate feature lists ###

# Capture all column names in original dataset
cnames_full <- train %>% colnames()

# Save names to csv
cnames_save(cnames_full)

# Collapse list of names into one string delimited by '+'
cnames_full <- cnames_full %>% paste(collapse="+")

# Create expression
exp_full <- paste(target_name, "~", paste(cnames_full))


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

