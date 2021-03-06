% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Helper_Functions.R
\name{lsmeansTable}
\alias{lsmeansTable}
\alias{lstrendsTable}
\title{Extract means, contrasts, or trends from a list of lsmobj}
\usage{
lsmeansTable(lsList, idName = "ID", table = "contrasts")

lstrendsTable(lsList, idName = "ID")
}
\arguments{
\item{lsList}{A list of objects of class lsmobj}

\item{idName}{The name for the grouping factor created from the names of the 
list supplied as a string. Defaults to "ID"}

\item{table}{a string specifying "contrasts" or "lsmeans" which specifies 
whether the estimates of the means or the contrasts will be returned by 
lsmeansTable()}
}
\value{
A dataframe with the first column containing a factor comprised of
the names of the list object.
}
\description{
Creates a data frame from a list of lsmobj results generated from a looped 
call involving lsmeans or lstrends.
}
