pull_covid_data <- function(start_date, end_date, fields, limit=100000) {
  
  # Base URL for all queries (should exclude the final question mark and build up in something more dynamic)
  base_url <- "https://data.cdc.gov/resource/9mfq-cb36.csv?"
  
  # API key
  app_token <- "$$app_token=ntB8MouZpMwkcr4O7WWOZKeQx"
  
  # Set up a SQL type query in the URL string
  qry_select <- "&$query=SELECT "
  
  # Create a comma separated list of fields to select
  fields <- paste(fields, collapse=",")
  
  # Expand this, currently only supporters start/end date filtering
  filter <- paste0(" WHERE submission_date >='", start_date, "' and submission_date <='", end_date, "'")
  
  # Need to figure out how to ensure all records are included
  limit <- paste(" LIMIT", format(limit, scientific=FALSE))
  
  # Build final query string
  qry <- paste0(base_url, app_token, qry_select, fields, filter, limit)
  
  # Format the string so that it's URL ready (eg: replaces spaces with %20)
  return(URLencode(qry))
}


# All available fields from the CDC
available_fields <- c("submission_date", "state", "tot_cases", "conf_cases", "prob_cases", "new_case", "pnew_case", "tot_death", "conf_death", "prob_death", "new_death", "pnew_death", "created_at", "consent_cases", "consent_deaths")
available_states <- c("AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA",
                      "HI","IA","ID","IL","IN","KS","KY","LA","MA","MD",
                      "ME","MI","MN","MO","MS","MT","NC","ND","NE","NH",
                      "NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC",
                      "SD","TN","TX","UT","VA","VT","WA","WI","WV","WY")
availble_territories <- c("NYC","DC","PR","AS","GU","VI","FSM","MP","PW","RMI")





# Example 1
df.filtered.1 <- read.csv(pull_covid_data("2020-09-30", "2020-10-30", available_fields))

# Example 2
df.filtered.2 <- read.csv(pull_covid_data("2020-01-01", "2020-10-30", fields=c("state", "new_case", "new_death", "tot_cases", "tot_death", "submission_date")))


df.filtered.2 <- read.csv(pull_covid_data("2020-01-01", "2020-10-30", fields=c("state")))



# ToDo: Convert submission_date to a date field, convert created_at to a date_time
# ToDo: Convert consent_cases, consent_deaths to booleans (do they even need to exist?)
