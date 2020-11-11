This package can pull COVID-19 daily data from CDC. 


Install the package by running /inst/create_package.R.


df_filtered_1 <- pull_covid_data("2020-09-30", "2020-10-30")

df_filtered_2 <- pull_covid_data(start_date="2020-09-30", 
                                 end_date="2020-10-30", 
                                 limit=100)

df_filtered_3 <- pull_covid_data(start_date="2020-01-01", 
                                 end_date="2020-10-30",
                                 states=c("FL", "TX", "CA"),
                                 fields=c("state", "new_case", "new_death", 
                                          "tot_cases", "tot_death", 
                                          "submission_date"),
                                 limit=100)
