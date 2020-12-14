#' @title Forecast COVID-19 new cases or new deaths in USA from now up to a maximum of 100 days
#'
#' @param start_date Start date. Default uses 2020-01-22. 
#' @param fvar Forecasting object (new_case or new_death). 
#' @param state.filter Optional vector specifying a subset of states to be used. This cannot be used in conjunction with region.filter. Default uses c("all") i.e., forecast will be done for USA. 
#' @param region.filter Optional vector specifying a subset of regions to be used from a list c("Northeast","Midwest","South","West"). This cannot be used in conjunction with state.filter. Default uses state.filter=c("all") i.e., forecast will be done for USA.
#' @param model Forecasting model to be used from a list of c('naive','ets','bats','tbats','auto.arima'). Default uses "auto.arima"
#' @param pred.days Number of days for forecasting. Limited to 100 days. Default uses 30 days.
#'
#' @examples
#' covid_ts_forecast(start_date='2020-01-01', fvar="new_case", state.filter=c("MA","CA"), pred.days = 30)
#' covid_ts_forecast(fvar="new_death", state.filter=c("all"), pred.days = 60)
#' covid_ts_forecast(start_date='2020-02-01', fvar="new_death", model=c("auto.arima"), pred.days = 60)
#' covid_ts_forecast(start_date='2020-04-30', fvar="new_case", region.filter=c("Midwest","South"), model=c("tbats"), pred.days=40)
#' covid_ts_forecast(fvar="new_death")
#' 
#' @details 
#' \describe{
#'   \item{start_date}{Input data is obtained from pull_covid_data function. The source data is from CDC website. Data is available from 2020-01-22. }
#'   \item{fvar}{Only one object can be used at a time.}
#'   \item{state.filter}{2 character codes for states should be used. If not specified, state.filter will calculate sum of new cases (new_case) or new deaths (new_death) across each day}
#'   \item{region.filter}{If this is left blank along with state.filter then state.filter=c("all") will be used}
#'   \item{model}{Only a single model can be used at a time.}
#'   
#' @export


covid_ts_forecast <- function(start_date='2020-01-22', 
                           fvar=c('new_case','new_death'),
                           state.filter = NULL,
                           region.filter=NULL,
                           model=c('ets','bats','tbats','auto.arima'),
                           pred.days = 30) 
{
  debuggingState(on=FALSE)
  end_date <- Sys.Date()
  `%nin%` = Negate(`%in%`)
  covdata  <- pull_covid_data(start_date = start_date, end_date=end_date,
                             fields=c("submission_date","state","new_case","new_death"))
                             
  #Variable selection based on var parameter (newcases or newdeaths)
  ifelse(fvar %in% "new_case", fcast.var <- c("new_case"), fcast.var <- c("new_death"))
  data1  <- covdata[,c("submission_date","state",fcast.var)]
  
  #Create region variable
  northeast <- c("CT", "ME", "MA", "NH", "RI", "VT", "NJ", "NY", "PA")
  midwest   <- c("IL", "IN", "MI", "OH", "WI", "IO", "KS", "MN", "MS", "NE", "ND", "SD")
  south     <- c("DE", "FL", "GA", "MD", "NC", "SC", "VA", "DC", "WV", "AL", "KY", "MS", "TN", "AR", "LA", "OK", "TX")
  west      <- c("AZ", "CO", "ID", "MO", "NV", "NM", "UT", "WY", "AK", "CA", "HI", "OR", "WA")

  data1$region  <- ifelse(data1$state %in% northeast,"Northeast",
                   ifelse(data1$state %in% midwest,"Midwest",
                   ifelse(data1$state %in% south,"South",
                   ifelse(data1$state %in% west,"West","False"))))

  #prediction days is limited to 100
  if(pred.days > 100)
    stop("Prediction cannot go beyond the next 100 days")

  if (!missing(state.filter) & !missing(region.filter)){
      stop("State and Region filters cannot be used together")
  }

  if (missing(state.filter) & missing(region.filter)){
    state.filter <- c("all")
  }
 
  
  if (is.null(region.filter) & !is.null(state.filter)){
#     Filter by state
     if (fvar %in% c("new_case")){
       ifelse(state.filter %in% c("all"), data2 <- mutate(aggregate(data1['new_case'], data1['submission_date'], FUN=sum),state=rep(c("USA"))),
       ifelse((!is.null(state.filter)),   data2 <- data1[match(data1$state,state.filter, nomatch=0) != 0,
                                                         c("submission_date","state",fcast.var)],"False"))
                             }
     else if(fvar %in% c("new_death")){
       ifelse(state.filter %in% c("all"), data2 <- mutate(aggregate(data1['new_death'], data1['submission_date'], FUN=sum),state=rep(c("USA"))),
       ifelse((!is.null(state.filter)),   data2 <- data1[match(data1$state,state.filter, nomatch=0) != 0,
                                                                 c("submission_date","state",fcast.var)],"False"))
                                   }
                      }
     

    #Filter by region
    if(is.null(state.filter) & !is.null(region.filter)){
      if (fvar %in% "new_case"){
        ifelse((!is.null(region.filter)),   data2 <- data1[match(data1$region,region.filter, nomatch=0) != 0,
                                                            c("submission_date","region","new_case")]
                                                            %>% group_by(submission_date, region)
                                                            %>% summarise(new_case = sum(new_case)),"False")
                               }
      else if (fvar %in% "new_death"){
        ifelse((!is.null(region.filter)),   data2 <- data1[match(data1$region,region.filter, nomatch=0) != 0,
                                                            c("submission_date","region","new_death")]
                                                            %>% group_by(submission_date, region)
                                                            %>% summarise(new_death = sum(new_death)),"False")
        
                                     }
                                                      }

  
     ######################
     ## Forecasting
     if (fvar %in% c("new_case")){
       if (is.null(region.filter) & !is.null(state.filter)){
         ##organize into groups by month of the year
         data2_cat <- data2 %>%
           mutate(order.month = as_date(as.yearmon(submission_date))) %>%
           group_by(state, order.month) %>%
           summarise(new_case = sum(new_case))
         
         ##consolidate each time series by group
         data2_nest <- data2 %>%
           group_by(state) %>%
           nest()
       }
     else if (is.null(state.filter) & !is.null(region.filter)){
       ##organize into groups by month of the year
       data2_cat <- data2 %>%
         mutate(order.month = as_date(as.yearmon(submission_date))) %>%
         group_by(region, order.month) %>%
         summarise(new_case = sum(new_case))
       
       ##consolidate each time series by group
       data2_nest <- data2 %>%
         group_by(region) %>%
         nest()
     }
   }
  else if (fvar %in% c("new_death")){
    if (is.null(region.filter) & !is.null(state.filter)){
      ##organize into groups by month of the year
      data2_cat <- data2 %>%
        mutate(order.month = as_date(as.yearmon(submission_date))) %>%
        group_by(state, order.month) %>%
        summarise(new_death = sum(new_death))
      
      ##consolidate each time series by group
      data2_nest <- data2 %>%
        group_by(state) %>%
        nest()
    }
  else if (is.null(state.filter) & !is.null(region.filter)){
    ##organize into groups by month of the year
    data2_cat <- data2 %>%
      mutate(order.month = as_date(as.yearmon(submission_date))) %>%
      group_by(region, order.month) %>%
      summarise(new_death = sum(new_death))
    
    ##consolidate each time series by group
    data2_nest <- data2 %>%
      group_by(region) %>%
      nest()
            }
  }
  
  ##add a column, and the map() function maps the contents of a list-column (.x) to a function (.f).
  data2_ts <- data2_nest %>%
    mutate(data.ts = map(.x       = data, 
                         .f       = tk_ts, 
                         select   = -submission_date, 
                         start    = start_date,
                         freq     = 1))
  
  # Model timeseries
  ifelse(model %in% "naive", data2_fit <- data2_ts %>% mutate(fit = map(data.ts, naive)),
  ifelse(model %in% "ets", data2_fit <- data2_ts %>% mutate(fit = map(data.ts, ets)),
  ifelse(model %in% "bats", data2_fit <- data2_ts %>% mutate(fit = map(data.ts, bats)),
  ifelse(model %in% "tbats", data2_fit <- data2_ts %>% mutate(fit = map(data.ts, tbats)),
  ifelse(model %in% "auto.arima", data2_fit <- data2_ts %>% mutate(fit = map(data.ts, auto.arima)),"False")))))

  if(is.null(model)){
    model = c("auto.arima")
    data2_fit <- data2_ts %>% mutate(fit = map(data.ts, auto.arima))
                    }

  # create decompositions using the same procedure
  data2_fcast <- data2_fit %>%
    mutate(fcast = map(fit, forecast, h = pred.days))
  
  data2_fcast_tidy <- data2_fcast %>%
    mutate(sweep = map(fcast, sw_sweep, fitted = FALSE, timetk_idx = TRUE)) %>%
    unnest(sweep)

  covid_ts_forecast_modeldata <<- data2_fcast_tidy  

### Titles/Subtitles for plots
  ifelse(model %in% "naive", subttl <- "Naive Model Forecast",
  ifelse(model %in% "ets", subttl <- "ETS Model Forecast",
  ifelse(model %in% "bats", subttl <- "BATS Model Forecast",
  ifelse(model %in% "tbats", subttl <- "TBATS Model Forecast",
  ifelse(model %in% "auto.arima", subttl <- "Auto ARIMA Model Forecast","False")))))

  ifelse(fvar %in% "new_case", text1 <- "cases",
  ifelse(fvar %in% "new_death", text1 <- "deaths","False"))
  
  ifelse(is.null(region.filter) & !is.null(state.filter) & state.filter %in% c("all"), text2 <- "in USA", 
  ifelse(is.null(region.filter) & !is.null(state.filter) & state.filter %nin% c("all"), text2 <- "by state", "False"))
  
  ifelse(!is.null(region.filter) & is.null(state.filter), text2 <- "by region","False")
  

  
### Generate plots  
if(fvar %in% c("new_case")) {
  if (is.null(region.filter) & !is.null(state.filter)){
    p <- data2_fcast_tidy %>%
      ggplot(aes(x = index, y = new_case, color = key, group = state)) +
      geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
                  fill = "#D5DBFF", color = NA, size = 0) +
      geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
                  fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
      geom_line() +
      labs(title = paste("Forecasting COVID-19 new",text1,text2),
           subtitle = paste(subttl),
           x = "", y = "New cases") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_color_tq() +
      scale_fill_tq() +
      facet_wrap(~ state, scales = "free_y", ncol = 2) +
      theme_tq() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    return(p)
  }
  if (!is.null(region.filter) & is.null(state.filter)){
    p <- data2_fcast_tidy %>%
      ggplot(aes(x = index, y = new_case, color = key, group = region)) +
      geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
                  fill = "#D5DBFF", color = NA, size = 0) +
      geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
                  fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
      geom_line() +
      labs(title = paste("Forecasting COVID-19 new",text1,text2),
           subtitle = paste(subttl),
           x = "", y = "New cases") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_color_tq() +
      scale_fill_tq() +
      facet_wrap(~ region, scales = "free_y", ncol = 2) +
      theme_tq() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    return(p)
  }
}
  
else if (fvar %in% c("new_death")){
  if (is.null(region.filter) & !is.null(state.filter)){
    p <- data2_fcast_tidy %>%
      ggplot(aes(x = index, y = new_death, color = key, group = state)) +
      geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
                  fill = "#D5DBFF", color = NA, size = 0) +
      geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
                  fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
      geom_line() +
      labs(title = paste("Forecasting COVID-19 new",text1,text2),
           subtitle = paste(subttl),
           x = "", y = "New Deaths") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_color_tq() +
      scale_fill_tq() +
      facet_wrap(~ state, scales = "free_y", ncol = 2) +
      theme_tq() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    return(p)
  }
  if (!is.null(region.filter) & is.null(state.filter)){
    p <- data2_fcast_tidy %>%
      ggplot(aes(x = index, y = new_death, color = key, group = region)) +
      geom_ribbon(aes(ymin = lo.95, ymax = hi.95), 
                  fill = "#D5DBFF", color = NA, size = 0) +
      geom_ribbon(aes(ymin = lo.80, ymax = hi.80, fill = key), 
                  fill = "#596DD5", color = NA, size = 0, alpha = 0.8) +
      geom_line() +
      labs(title = paste("Forecasting COVID-19 new",text1,text2),
           subtitle = paste(subttl),
           x = "", y = "New Deaths") +
      scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
      scale_color_tq() +
      scale_fill_tq() +
      facet_wrap(~ region, scales = "free_y", ncol = 2) +
      theme_tq() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    return(p)
  }
}
}



