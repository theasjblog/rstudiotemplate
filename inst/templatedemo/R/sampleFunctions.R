#' @title getRawData
#' @description Place holder function to get data for the report
#' @return the mtcars dataset
#' @export
getRawData <- function(){
  return(mtcars)
}

#' @title getSummaryData
#' @description Placeholder function for data processing
#' @param rawData A data.frame
#' @return the first n rows of the data.frame, where n is determined by the
#' R_CONFIG_ACTIVE (config package)
#' @export
getSummaryData <- function(rawData){
  head_data <- config::get('head_data')
  return(head(rawData, head_data))
}
