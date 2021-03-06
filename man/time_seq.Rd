% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Helper_Functions.R
\name{time_seq}
\alias{time_seq}
\title{Create time sequence with custom intervals}
\usage{
time_seq(start, end, step, units = "days")
}
\arguments{
\item{start}{a start date or time as a character string ("yyyy-mm-dd", "yyyy-mm-dd HH:MM", "yyyy-mm-dd HH:MM:SS)}

\item{end}{a start date or time as a character string ("yyyy-mm-dd", "yyyy-mm-dd HH:MM", "yyyy-mm-dd HH:MM:SS)}

\item{step}{a number representing the length of time in units between each step}

\item{units}{the units of step: "seconds", "minutes", "days", "months", "years"}
}
\value{
A POSIXt vector
}
\description{
Creates a POSIXt vector from the start time to the end time with N number of
steps, based on the interval length choosen.
}
\examples{
time_seq("2016-11-01", "2016-11-03", step = 15, units = "minutes")
}
