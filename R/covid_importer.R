# Available fields from the CDC
available.fields <- c("submission_date", "state", "tot_cases", "conf_cases", "prob_cases", "new_case", "pnew_case", "tot_death", "conf_death", "prob_death", "new_death", "pnew_death", "created_at", "consent_cases", "consent_deaths")
default.fields <- c("submission_date", "state", "tot_cases", "conf_cases", "prob_cases", "new_case", "pnew_case", "tot_death", "conf_death", "prob_death", "new_death", "pnew_death")

# Available state in CDC data (Last row are non-state abbreviates available in the data)
available.states <- c("AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA",
                      "HI","IA","ID","IL","IN","KS","KY","LA","MA","MD",
                      "ME","MI","MN","MO","MS","MT","NC","ND","NE","NH",
                      "NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC",
                      "SD","TN","TX","UT","VA","VT","WA","WI","WV","WY",
                      "NYC","DC","PR","AS","GU","VI","FSM","MP","PW","RMI")
default.states <- c("AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA",
                    "HI","IA","ID","IL","IN","KS","KY","LA","MA","MD",
                    "ME","MI","MN","MO","MS","MT","NC","ND","NE","NH",
                    "NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC",
                    "SD","TN","TX","UT","VA","VT","WA","WI","WV","WY")


generate_url <- function(start_date, end_date, states, fields, consenst_cases, consent_deaths, limit) {
  
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
  if(!is.null(states)) {
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

pull_covid_data <- function(start_date, end_date, states=default.states, fields=default.fields, consent_cases=TRUE, consent_deaths=TRUE, limit=100000){
  url <- generate_url(start_date, end_date, states, fields, consent_cases, consent_deaths, limit)
  df <- read.csv(url)
  df <- format_covid_data(df)
  return(df)
}


# Example 1
df.filtered.1 <- pull_covid_data("2020-09-30", "2020-10-30")

# Example 2
df.filtered.2 <- pull_covid_data("2020-09-30", "2020-10-30", available_states, available_fields, limit=100)

# Example 3
df.filtered.3 <- pull_covid_data("2020-01-01", "2020-10-30", states=c("FL", "TX", "CA"), fields=c("state", "new_case", "new_death", "tot_cases", "tot_death", "submission_date"), limit=100)
