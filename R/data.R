#' Default and available fields and states
#'
#' @format A list of field and state names
#' \describe{
#'   \item{available_fields}{available fields in the CDC data}
#'   \item{available_states}{available names of the US territory in the CDC data}
#'   \item{default_fields}{default fields specified for all functions in the package}
#'   \item{default_states}{default states specified for all functions in the package}
#' }
"data_fields"

#' Age and sex demographics by state
#'
#' @format Age and sex demographics by state
#' \describe{
#'   \item{State}{US States}
#'   \item{Sex}{Gender}
#'   \item{LBound}{Lower bound of age range}
#'   \item{UBound}{Upper bound of age range}
#'   \item{Population}{Population with applicable attributes}
#' }
"age_sex"

#' Race demographics by state
#'
#' @format Race demographics by state
#' \describe{
#'   \item{State}{US State}
#'   \item{Race}{Race of population}
#'   \item{Population}{Population count}
#' }
"race_ethnicity"

#' Insurance characteristics by population
#'
#' @format Insurance characteristics by state
#' \describe{
#'   \item{State}{available fields in the CDC data}
#'   \item{year}{Self explanatory}
#'   \item{agecat}{Self explanatory}
#'   \item{racecat}{Self explanatory}
#'   \item{sexcat}{Self explanatory}
#'   \item{iprcat}{Self explanatory}
#'   \item{Number in Demographic Group}{Self explanatory}
#'   \item{Number Uninsured}{Self explanatory}
#'   \item{Number Insured}{Self explanatory}
#'   \item{Percent uninsured in demographic group for income category}{Self explanatory}
#'   \item{Percent insured in demographic group for income category}{Self explanatory}
#'   \item{Percent uninsured in demographic group for all income levels}{Self explanatory}
#'   \item{Percent insured in demographic group for all income levels}{Self explanatory}
#' }
"insurance"