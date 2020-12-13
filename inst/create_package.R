#### Create R package from command line
library(data.table)
# State convert between abbreviation and full name
state_abb <- data.table(state = state.name, 
                        abb = state.abb)
add_state <- data.table(state = c("District of Columbia", "Puerto Rico"), 
                        abb = c("DC", "PR"))

state_abb <- rbindlist(list(state_abb, add_state))

# The directory should be in your project folder XX/YY/ZZ/covidDataCDC

raw_data_path <- "inst/raw_data/"

file_ls <- list.files(raw_data_path)

# Create data fields data list
data_fields <- lapply(c("availableFields.rda", "availableStates.rda", "defaultFields.rda", "defaultStates.rda"), 
                      function(x) {
                        get(load(paste0(raw_data_path, x)))
                      })

names(data_fields) <- c("available_fields", "available_states",
                        "default_fields", "default_states")

age_sex <- get(load(paste0(raw_data_path, "age_sex.rda")))
age_sex <- merge(age_sex, state_abb, by.x = "State", by.y = "state", all.x = T)
age_sex[, `:=` (State = abb, 
                abb = NULL)]
race_ethnicity <- get(load(paste0(raw_data_path, "race_ethnicity.rda")))
race_ethnicity <- data.table(race_ethnicity)
race_ethnicity <- merge(race_ethnicity, state_abb, by.x = "State", by.y = "state", all.x = T)
race_ethnicity[, `:=` (State = abb, 
                       abb = NULL)]
insurance <- get(load(paste0(raw_data_path, "insurance.rda")))
insurance <- data.table(insurance)
insurance <- merge(insurance, state_abb, by.x = "State", by.y = "state", all.x = T)
insurance[, `:=` (State = abb, 
                       abb = NULL)]


# Create internal data
usethis::use_data(data_fields, overwrite = T)
usethis::use_data(age_sex, overwrite = T)
usethis::use_data(race_ethnicity, overwrite = T)
usethis::use_data(insurance, overwrite = T)

# Create documentation for the package
devtools::document()

# Build package
package_loc <- devtools::build()
install.packages(package_loc, repos = NULL) #, lib = lib_path)
