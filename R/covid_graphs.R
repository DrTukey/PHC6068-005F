#' @title Plot deaths
#'
#' @param start_date start date
#' @param end_date end date
#' @param per_capita per_capita
#' @import dplyr ggplot2 scales
#' 
#' @return a ggplot object
#' 
#' @examples
#' covid_deaths_graph("2020-03-30", "2020-08-30",  per100k = T)
#' covid_deaths_graph("2020-03-30", "2020-08-30",  per100k = F)
#' 
#' @export
covid_deaths_graph <- function(start_date, end_date, per100k = T) {
  
  # Dataset for state level population
  state_population <- age_sex %>%
    group_by(State) %>%
    summarise(Pop2018 = sum(Population)) 
  
  # Pull covid data and calculate deaths per capita  
  covid_data <- pull_covid_data(start_date, end_date) %>%
    merge(state_population, by.x = "state", by.y = "State", all.x = T) %>%
    mutate(deaths_per100k = new_death / Pop2018 * 100000) # per 100k people would be a better measure
  
  # Summarise data to state level
  top_states <- covid_data %>%
    group_by(state) %>%
    summarise(maxdeath = max(tot_death)) %>%
    arrange(-maxdeath) %>% 
    head() %>% 
    pull(state) 
  
  display_data <- filter(covid_data, state %in% top_states)
  
  if (per100k == T) {
    # deaths_per100k
    ggplot(display_data,
           aes(submission_date, deaths_per100k,
               group = state, col = state))+
      geom_line() +
      facet_wrap(~state) +
      labs(x = "submission date", y = "number of daily deaths\n(per 100K people)") + 
      ggtitle("COVID Deaths per Capita of Top Six States") + 
      theme_bw() 
  } else {
    # deaths unadjusted
    ggplot(display_data,
           aes(submission_date,
               new_death,
               group = state,
               col = state))+
      geom_line() +
      scale_y_continuous(labels = comma) +
      facet_wrap(~state)+ 
      labs(x = "submission date", y = "number of daily deaths") + 
      ggtitle("COVID Death of Top Six States") + 
      theme_bw()
  }
}


#' @title Plot cases
#'
#' @param start_date start date
#' @param end_date end date
#' @param per_capita per_capita
#' @import dplyr ggplot2 scales
#' 
#' @return a ggplot object
#' 
#' @examples
#' covid_cases_graph("2020-03-30", "2020-08-30",  per100k = T)
#' covid_cases_graph("2020-03-30", "2020-08-30",  per100k = F)
#'
#' @export
covid_cases_graph <- function(start_date, end_date, per100k = T) {
  
  # Dataset for state level population
  state_population <- age_sex %>%
    group_by(State) %>%
    summarise(Pop2018 = sum(Population)) 
  
  covid_data <- pull_covid_data(start_date, end_date) %>%
    merge(state_population, by.x = "state", by.y = "State", all.x = T) %>%
    mutate(cases_per100k = new_case / Pop2018 * 100000) # per 100k people would be a better measure
  
  top_states <- covid_data %>%
    group_by(state) %>%
    summarise(maxcases = max(tot_cases)) %>%
    arrange(-maxcases) %>%
    head() %>%
    pull(state)
  
  filtered_data <- filter(covid_data, state %in% top_states)
   #new cases top six
  
  if (per100k == T) {
    ggplot(filtered_data,
           aes(submission_date,
               cases_per100k,
               group = state, col = state))+
      geom_line() +
      facet_wrap(~state) + 
      labs(x = "submission date", y = "number of daily cases\n(per 100K people)") + 
      ggtitle("COVID New Cases per capita of Top Six States") + 
      theme_bw()
  } else {
    ggplot(filtered_data,
           aes(submission_date,
               new_case,
               group = state,
               col = state))+
      geom_line()+
      facet_wrap(~state)+
      scale_y_continuous(labels = comma)+
      labs(x = "submission date", y = "number of daily cases") + 
      ggtitle("COVID New Cases of Top Six States") +
      theme_bw()
  }
}
