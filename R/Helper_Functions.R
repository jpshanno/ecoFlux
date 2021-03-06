
# Blank Day ---------------------------------------------------------------

#' Creates a ITime vector spanning a single day with a custom time step
#'
#' #' Creates a ITime vector spanning a single day with a custom time step
#' @param timestemp The desired time step in minutes
#' @keywords ITime
#' @export
#' @examples
#' blank_day()
blank_day <- function(timestep = NULL){
  timestep_seconds = 60 * timestep
  sort(data.table::as.ITime(seq(from = data.table::as.ITime("00:00:00"), to = data.table::as.ITime("23:59:59"), by=timestep_seconds), origin = "1970-01-01 00:00:00"))
}

#' Calculate the area of a circle
#'
#' This function calculates the area of a circle given the radius
#' @param r Radius of the circle
#' @keywords Sap flux
#' @export
#' @examples
#' Circular()
Circular<-function(r) pi*r^2

# Predicted Standard Error ------------------------------------------------
#' Predicted Standard Error
#'
#' Calcualtes the standard error of predicted y-values
#' @param model Any fitted model.
#' @param Xes the x-values used in prediction
#' @keywords standard error
#' @export
#' @examples
#' SEy()
SEy <- function(model, Xes) {
  Ux <- mean(Xes, na.rm=T)
  Ey <- resid(model)
  Ex <- Xes-Ux
  n <- length(resid(model))
  s <- sqrt((sum(Ey^2))/(n-2))
  Sx <- sum((Ex)^2,na.rm=T)
  s * sqrt(1+(1/n)+(Ex^2/Sx))}

# Blank Sequence ----------------------------------------------------------
#' Create blank time sequence for each unique subject
#'
#' Returns a dataframe with subject, date, and time columns over
#' a specified range of days with a given time step
#' @param from a start date as a character string ("yyyy-mm-dd") or a date object
#' @param to a start date as a character string ("yyyy-mm-dd") or a date object
#' @param subjects a character vector of subject IDs
#' @param timestep the desired time step in minutes
#' @export
#' @examples
#' blank_seq()

blank_seq <- function(from = NULL, to = NULL, subjects = NULL, timestep = NULL){

  dates <- seq(from = ymd(from), to = as.IDate(to), by =1)
  times <- blank_day(timestep = timestep)
  
  n_subs <- length(subjects)
  n_dates <- length(dates)
  n_times <- length(times)
  
  full_sequence <- 
    data.table(
      subject = 
        rep(
          subjects, 
          each = n_dates * n_times),
      idateA = 
        rep(
          dates,
          each = n_times,
          times = n_subs),
      itimeA = 
        rep(
          times,
          times = n_subs * n_dates)
    )
  
  setkey(full_sequence, subject, idateA, itimeA)
  
  return(full_sequence)
  }

# lsmeansTable ----------------------------------------------------------
#' Extract means, contrasts, or trends from a list of lsmobj
#'
#' Creates a data frame from a list of lsmobj results generated from a looped 
#' call involving lsmeans or lstrends.
#' @return A dataframe with the first column containing a factor comprised of
#' the names of the list object.
#' @param lsList A list of objects of class lsmobj
#' @param idName The name for the grouping factor created from the names of the 
#' list supplied as a string. Defaults to "ID"
#' @param table a string specifying "contrasts" or "lsmeans" which specifies 
#' whether the estimates of the means or the contrasts will be returned by 
#' lsmeansTable()
#' @export
#' @rdname lsmeansTable
lsmeansTable <- 
  function(lsList, idName = "ID", table = "contrasts") {
    temp <- do.call(
      rbind, 
      lapply(
        seq_along(lsList), 
        function(x){
          fullList <- lsList
          cbind(names(fullList)[[x]],
                summary(fullList[[x]][[table]]))}))
    names(temp)[1] <- idName
    temp}

#' @export
#' @rdname lsmeansTable
lstrendsTable <- function(lsList, idName = "ID"){
  temp <- 
    do.call(
      rbind,
      lapply(
        seq_along(lsList),
        function(x){
          fullList <- lsList
          cbind(ID = names(fullList)[[x]],
                cld(fullList[[x]]))})
    ) %>% 
    mutate(Age = as.numeric(as.character(Age)),
           .group = as.numeric(.group)) %>% 
    rename(Significance_Group = .group)
  names(temp)[1] <- idName
  temp
}

# ggpanel ------------------------------------------------------------
#' Create a horizontal or vertical panel of plots with a shared legend
#'
#' Combines multiple plots generated by ggplot2 into a 1 column (vertical) or 1 
#' row (horizontal) panel with a shared legend.
#' @return A gtable object
#' @param plots A list of ggplot2 plots
#' @param orientation A character of "horizontal" or "vertical", defaults to 
#' 'horizontal'
#' @param legend.position A character vector of "top", "bottom", "left", or
#'   "right", defaults to 'bottom'; to remove legend use "none"
#' @export
#' @rdname ggpanel
#' @examples
#' # Create datasets for plotting
#' data1 <- 
#'   data.frame(x = c(1:5, 1:5, 1:5, 1:5),
#'              treatment = rep(c(letters[1:2]), 
#'                              each = 5, 
#'                              times = 2),
#'              year = rep(c("2015", "2016"), 
#'                         each = 10),
#'              power = c(rep(2, times = 5), 
#'                        rep(2.1, times = 5), 
#'                        rep(2.5, times = 5), 
#'                        rep(3, times = 5))) %>% 
#'   mutate(y = rnorm(10, mean = 0, sd = 2) + x ^ power)
#' 
#' data2 <-
#'   data.frame(x = c(1:5, 1:5, 1:5, 1:5),
#'              treatment = rep(c(letters[1:2]), 
#'                              each = 5, 
#'                              times = 2),
#'              year = rep(c("2015", "2016"), 
#'                         each = 10),
#'              slope = c(rep(3, times = 5), 
#'                        rep(4, times = 5), 
#'                        rep(3, times = 5), 
#'                        rep(7, times = 5))) %>% 
#'   mutate(y = rnorm(20, mean = 0, sd = 2) + x * slope)
#' 
#' # Create two plots
#' plot1 <- 
#'   ggplot(data1, 
#'          aes(x, y, color = treatment)) + 
#'   geom_point() + 
#'   geom_smooth(span = 1, se = F) + 
#'   facet_grid(.~year)
#' 
#' plot2 <- 
#'   ggplot(data2, 
#'          aes(x, y, color = treatment)) + 
#'   geom_point() + 
#'   geom_smooth(method = "lm", span = 1, se = F) + 
#'   facet_grid(.~year)
#' 
#' # Generate a Panel
#' ggpanel(list(plot1, plot2), 
#'         orientation = "vertical", 
#'         legend.position = "right")

ggpanel <- function(plots, orientation = "horizontal", legend.position = "bottom") {
  
  if(!all(sapply(plots, is.ggplot))){
    stop("Input plots must be a list containing only ggplot objects")
  }
  
  if(!(legend.position %in% c("top", "bottom", "left", "right", "none"))){
    stop("Legend must be one of 'top', 'bottom', 'left', 'right', 'none'.")
  }
  
  ncol <- ifelse(orientation == "horizontal", 
                 length(plots),
                 1)
  
  legendOrientation <- ifelse(legend.position %in% c("top", "bottom"),
                              "horizontal",
                              "vertical")
  
  legendGrob <- ggplot2::ggplotGrob(plots[[1]] + 
                             ggplot2::theme(legend.direction = legendOrientation))$grobs
  
  bindFunction <- ifelse(orientation == "horizontal",
                         quote(gridExtra::gtable_cbind),
                         quote(gridExtra::gtable_rbind))
  
  haveLegends <- 
    all(
      sapply(
        lapply(plots, function(x) {ggplot2::ggplotGrob(x)$grobs}),
        function(x){
          length(which(sapply(x, function(y) y$name) == "guide-box")) > 0}))
  
  plotGrobs <- 
    lapply(plots, 
           function(x) {ggplot2::ggplotGrob(x + ggplot2::theme(legend.position = "none"))})
  
  plotsPanel <- 
    if(orientation == "horizontal"){
      gridExtra::arrangeGrob(do.call(eval(bindFunction), 
                          plotGrobs))
    } else {
      if(length(unique(sapply(plotGrobs, length))) == 1){
        gridExtra::arrangeGrob(
          do.call(
            eval(bindFunction), 
            plotGrobs))
      } else {
        do.call(
          gridExtra::arrangeGrob,
          list(
            grobs = plotGrobs,
            ncol = ncol))
      }
    }
  
  if(haveLegends){
    legend <- 
      legendGrob[[which(
        sapply(legendGrob, 
               function(x) x$name) == "guide-box")]]
    
    legendWidth <- sum(legend$width)
    legendHeight <- sum(legend$height)
    
    
    if(legend.position == "top"){
      return(
        gridExtra::grid.arrange(
          legend,
          plotsPanel,
          ncol = 1,
          heights = grid::unit.c(legendHeight, grid::unit(1,"npc") - legendHeight)))
    } 
    
    if(legend.position == "bottom"){
      return(
        gridExtra::grid.arrange(
          plotsPanel,
          legend,
          ncol = 1,
          heights = grid::unit.c(grid::unit(1,"npc") - legendHeight, legendHeight)))
    }
    
    if(legend.position == "left"){
      return(
        gridExtra::grid.arrange(
          legend,
          plotsPanel,
          ncol = 2,
          widths = grid::unit.c(legendWidth, grid::unit(1,"npc") - legendWidth)))
    }
    
    if(legend.position == "right"){
      return(
        gridExtra::grid.arrange(
          plotsPanel,
          legend,
          ncol = 2,
          widths = grid::unit.c(grid::unit(1,"npc") - legendWidth, legendWidth)))
    }
    
    if(legend.position == "none"){
      return(
        gridExtra::grid.arrange(
          plotsPanel)
      )
    }
    
  } else {
    message("One or all of your plots did not include legends.")
    return(
      gridExtra::grid.arrange(
        plotsPanel))
  }
}

# Time Sequence ----------------------------------------------------------
#' Create time sequence with custom intervals
#'
#' Creates a POSIXt vector from the start time to the end time with N number of
#' steps, based on the interval length choosen.
#' @return A POSIXt vector
#' @param start a start date or time as a character string ("yyyy-mm-dd", "yyyy-mm-dd HH:MM", "yyyy-mm-dd HH:MM:SS)
#' @param end a start date or time as a character string ("yyyy-mm-dd", "yyyy-mm-dd HH:MM", "yyyy-mm-dd HH:MM:SS)
#' @param step a number representing the length of time in units between each step
#' @param units the units of step: "seconds", "minutes", "days", "months", "years"
#' @export
#' @examples
#' time_seq("2016-11-01", "2016-11-03", step = 15, units = "minutes")

time_seq <- function(start, end, step, units = "days"){
  require(lubridate)
  timeStep <- do.call(units, list(step))
  startTime <- lubridate::parse_date_time(start, orders = c('Ymd HMS', 'Ymd HM', 'Ymd'))
  endTime <- lubridate::parse_date_time(end, orders = c('Ymd HMS', 'Ymd HM', 'Ymd'))
  nSteps <- (endTime - startTime)/lubridate::as.duration(timeStep)
  
  if(!all.equal(nSteps, round(nSteps, digits = 0))){
    stop("Choosen time step does not fit evenly between start and end times.")
  }
  
  startTime + timeStep*0:nSteps
}

# scientific_10x ----------------------------------------
#' Format numbers to scientific notation (10^#)
#' 
#' Formats numbers to scientific notation using the form #.# x 10^# for display
#' on axes. Leading zeros and '+' signs are removed from the output and spaces
#' are inserted to match all exponents to uniform length for uniform display.
#' @param values A numeric vector
#' @param digits A single integer value specifying the number of digits to
#'   display after the decimal, trailing zeroes will be preserved
#' @return An expression
#' @export
#'
#' @examples
#' x <- 1:3
#' y <- c(0.1, 100, 1000)
#' 
#' # Base Plotting
#' originalMargins <- par()$mar
#' plot(y ~ x, 
#'      axes = F, 
#'      par(mar = c(5, 5, 4, 2) + 0.1), ylab = NA)
#' axis(1)
#' axis(2, 
#'      at = y, 
#'      labels = scientific_10x(y), 
#'      las = 2)
#' par(mar = originalMargins)
#' 
#' # ggplot2
#' ggplot2::qplot(x, y) + 
#'   ggplot2::scale_y_continuous(labels = scientific_10x)
#' ggplot2::qplot(x, y) + 
#'   ggplot2::scale_y_continuous(breaks = y, 
#'                               labels = scientific_10x(y, digits = 2))
#' 

scientific_10x <- function(values, digits = 1) {
  if(!is.numeric(values)){
    stop("values must be numbers")
  }
  if(grepl("^\\d{2}$", digits)){
    stop("digits must a one or two digit whole number")
  }
  
  x <- sprintf(paste0("%.", digits, "e"), values)
  
  x <- gsub("^(.*)e", "'\\1'e", x)

  longestExponent <- max(sapply(gregexpr("\\d{1,}$", x), attr, 'match.length'))
  zeroTrimmed <- ifelse(longestExponent > 2,
                        paste0("\\1", paste(rep("~", times = longestExponent-1), collapse = "")),
                        "\\1")
  x <- gsub("(e[+|-])[0]", zeroTrimmed, x)

  x <- gsub("e", "~x~10^", x)

  if(any(grepl("\\^\\-", x))){
    x <- gsub("\\^\\+", "\\^~~", x)
  } else {
    x <- gsub("\\^\\+", "\\^", x)
  }
  # return this as an expression
  parse(text=x)
} 

#' Sort and display a table
#'
#' Sort a table by a column, replace row names as 1:n, and return the table via \code{\link[pander]{pander}} for clean display. This is necessary after sorting because pander will display row names if they are not 1:n or NULL.
#' 
#' @param data A dataframe or object that can be coerced into a data frame (will be done via \code{\link[base]{as.data.frame}})
#' @param x The column name to sort by, quoted or unquoted
#' @param ... Additional named parameters to be passed to pander()
#'
#' @return From \code{\link[pander]{pander}}: By default this function outputs (see: cat) the result. If you would want to catch the result instead, then call the function ending in .return.
#' @export
#' @rdname pander_sort
#' @examples
#' x <- data.frame(fruit = c("banana", "apple", "kiwi"),
#'                 weight = c(4.5, 3.6, 1.2))
#' 
#' ## Sorting manually:
#' pander::pander(x[order(x$fruit),])
#' 
#' ## Sorting and fixing row names:
#' pander_sort(x, fruit)
                
pander_sort <- function(data, x, ...){
  
  dataName <- deparse(substitute(data))
  
  if(!is.data.frame(data)){
    data <- as.data.frame(data, stringsAsFactors = F)
    message(paste0(dataName, " was coerced to a dataframe for sorting using as.data.frame"))}
  
  if(!is.logical(try(exists(x), silent = TRUE))) {x <- deparse(substitute(x))}
  
  if(!x %in% names(data)){stop(paste0(x, " is not a column in the input ", dataName))}
  
  data <- data[order(data[[x]]),]
  row.names(data) <- NULL
  pander::pander(data, ...)
}
