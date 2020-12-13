#' @title Generate URL
#'
#' @param start_date start date
#' @param end_date end date
#' @param states states
#' @param fields fields
#' @param consent_cases consent cases
#' @param consent_deaths consent deaths
#' @param limit limit
#'
#' @return a string
#'
#' @export
generate_url <- function(start_date, end_date, states, fields,
                         consent_cases, consent_deaths, limit) {

  # Base URL for all queries
  base_url <- "https://data.cdc.gov/resource/9mfq-cb36.csv"

  # API key
  app_token <- "?$$app_token=ntB8MouZpMwkcr4O7WWOZKeQx"

  # Set up a SQL type query in the URL string
  qry_select <- "&$query=SELECT "

  # Create comma separated fields
  fields <- paste(fields, collapse=",")

  # Expand this, currently only supporters start/end date filtering
  filter <- paste0(" WHERE submission_date >='", start_date, "' and submission_date <='", end_date, "'")

  if (!is.null(states)) {
    filter <- paste0(filter, " and state in (", paste(shQuote(states), collapse=","), ")")
  }

  order_by <- " ORDER BY submission_date, state"

  # Need to figure out how to ensure all records are included
  limit <- paste(" LIMIT", format(limit, scientific=FALSE))

  # Build final query string
  qry <- paste0(base_url, app_token, qry_select, fields, filter, order_by, limit)

  # Format the string so that it's URL ready (eg: replaces spaces with %20)
  return(URLencode(qry))
}


#' @title formatting covid data
#'
#' @param df
#'
#' @return a data.frame
#'
#' @keywords internal
format_covid_data <- function(df){
  if("submission_date" %in% colnames(df)){
    df$submission_date <- as.Date(df$submission_date)
  }

  if("created_at" %in% colnames(df)){
    df$created_at <- as.Date(df$created_at)
  }

  if("consent_cases" %in% colnames(df)){
    df$consent_cases <- ifelse(df$consent_cases == "Agree", TRUE, FALSE)
  }

  if("consent_deaths" %in% colnames(df)){
    df$consent_deaths <- ifelse(df$consent_deaths == "Agree", TRUE, FALSE)
  }

  return(df)
}

#' @title Pull COVID data from CDC
#'
#' @param start_date start date
#' @param end_date end date
#' @param states this input argument can be (1) `"default"`, which uses a vector of default vector of states from the
#'               internal data `data_fields`; (2) a vector of state abbreviations specified
#'               by the user, e.g., `c("GA", "FL")`.
#' @param fields a vector of fields, e.g., `c("submission_date", "state")`. If nothing is provided
#'               the function extracts the default vector of fields from the internal data `data_fields`.
#' @param consent_cases consent cases
#' @param consent_deaths consent deaths
#' @param limit limit of records
#'
#' @examples
#' df_filtered_1 <- pull_covid_data("2020-09-30", "2020-10-30")
#' df_filtered_2 <- pull_covid_data("2020-09-30", "2020-10-30", limit=100)
#' df_filtered_3 <- pull_covid_data("2020-01-01", "2020-10-30",
#'                  states=c("FL", "TX", "CA"),
#'                  fields=c("state", "new_case", "new_death", "tot_cases", "tot_death", "submission_date"),
#'                  limit=100)
#'
#' @export
pull_covid_data <- function(start_date, end_date,
                            states = NULL, fields = NULL,
                            consent_cases = TRUE, consent_deaths = TRUE, limit = 100000){

  if (is.null(fields)) fields <- data_fields$default_fields
  if (is.null(states)) states <- data_fields$default_states
  
  url <- generate_url(start_date, end_date, states, fields,
                      consent_cases, consent_deaths, limit)
  df <- read.csv(url)
  df <- format_covid_data(df)
  setDT(df)
  return(df)
}
