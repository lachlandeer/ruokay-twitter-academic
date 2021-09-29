#' get_tweets.R
#' 
#' What this file does:
#' 
#' Uses the Twitter academic API via academictwitteR to return tweets
#' from a query specified in a JSON file for different time periods.
#' 
#' The search query should be in a JSON file with the following fields:
#'  'SEARCH_TERMS': what words and hashtags to collect (example: '#ruokay')
#'  'LANG': the language of the tweets the user wants returned (example: 'en')
#'  'NTWEETS': the max number of tweets to be returned (example: 1e3)
#' 
#' The date ranges should be specified in a separate JSON file with the following fields:
#'  START DATE: the date to start collecting, (example: 2019-08-01T00:00:00Z)
#'  END_DATE  : the date to stop collecting, (example:  2019-08-02T00:00:00Z)
#'  DATA_PATH : file path to store output (which comes as multiple JSON files)
#'  FILE_NAME : name of a returned RDS file
#' 
#' To run the file successfully, user must have their bearer token stored in
#' the .Renviron file on their system. For help see ?set_bearer() from `academictwitteR`
#' 
#' Example Useage From Command Line:
#' 
#' Rscript get_tweets.R --query my_query.json --daterange my_dates.json
#' 

# R libraries #
library(academictwitteR)
library(rjson)
library(optparse)

 # CLI parsing #
option_list = list(
    make_option(c("-q", "--query"),
                type = "character",
                default = NULL,
                help = "a JSON file name",
                metavar = "character"),
	make_option(c("-d", "--daterange"),
                type = "character",
                default = "NULL",
                help = "a JSON file name",
                metavar = "character")
);

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$query)){
  print_help(opt_parser)
  stop("JSON file with search query terms must be provided", call. = FALSE)
}
if (is.null(opt$daterange)){
  print_help(opt_parser)
  stop("JSON file with date range for query must be provided", call. = FALSE)
}

# Load JSON #
search_terms_json <- fromJSON(file = opt$query)  
time_range_json   <- fromJSON(file = opt$daterange)  

# Unpack search json #
query <- search_terms_json$SEARCH_TERMS
lang <- search_terms_json$LANG
n_tweets <- search_terms_json$NTWEETS

# Unpack daterange json #
time_start <- time_range_json$START_DATE
time_end   <- time_range_json$END_DATE
data_path  <- time_range_json$DATA_PATH
file_name  <- time_range_json$FILE_NAME

# Report search terms to user #
message("Information on the search terms passed to Twitter API:")
message("query is: ", query)
message("Language restriction: ", lang)
message("Max number of tweets: ", n_tweets)
message("Start date: ", time_start)
message("End date: ", time_end)
message("Data JSONs saved to path: ", data_path)
message("Data saved to RDS file: ", file_name)


# Run query #
message("Running query...")
get_all_tweets(
        query        = query,
        start_tweets = time_start,
        end_tweets   = time_end,
        file         = file_name,
        data_path    = data_path,
        n            = n_tweets,
        lang         = lang,
        bind_tweets  = FALSE
    )
message("... query successfully executed")
