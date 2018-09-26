
# Custom function definitions

summarize_frame <- function(frameframe)
{
    #returns table of summary statistics for each numeric column in dataframe
    summarytools::descr(frameframe, transpose = TRUE)
}


standardize_names <- function(frameframe)
{
    # reformats column names to a regularized format wiuth:
    # - punctuation removed
    # - all letters lowercase
    # - no leading or trailing whitespace
    frameframe %>%
    rename_all(gsub, pattern = '[[:punct:] ]+', replacement = '') %>%
    rename_all(tolower) %>%
    rename_all(trimws)

}

table_styler <- function(frameframe)
{

    # returns table formatted ready for display
    kable(frameframe) %>%
    kable_styling(position = "center"
                 , full_width = TRUE
                 , bootstrap_options = "striped")

}

cnames_save <- function(list)
{
    # Saves list of column names to a csv file
    # The output filename will be the same as the input list variable name
    # WARNING: Do not use in dplyr piping syntax. Variable names are lost in translation between actions.

    # Captures variable name of input as string
    file <- deparse(substitute(list))

    # if variable name is empty or null, replace with timestamp
    if (is.null(file) || file == "." || file == "")
    {
        file <- paste(c("cnames_", format(Sys.time(), "%Y%m%d%H%m%s"), ".csv"), collapse = "")
    }
    # Save to csv
    write.csv(list
            , file=sprintf("data/%s.csv", file)
            , row.names = FALSE
            , quote = FALSE
            )
}



