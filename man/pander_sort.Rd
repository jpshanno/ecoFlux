% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Helper_Functions.R
\name{pander_sort}
\alias{pander_sort}
\title{Sort and display a table}
\usage{
pander_sort(data, x, ...)
}
\arguments{
\item{data}{A dataframe or object that can be coerced into a data frame (will be done via \code{\link[base]{as.data.frame}})}

\item{x}{The column name to sort by, quoted or unquoted}

\item{...}{Additional named parameters to be passed to pander()}
}
\value{
From \code{\link[pander]{pander}}: By default this function outputs (see: cat) the result. If you would want to catch the result instead, then call the function ending in .return.
}
\description{
Sort a table by a column, replace row names as 1:n, and return the table via \code{\link[pander]{pander}} for clean display. This is necessary after sorting because pander will display row names if they are not 1:n or NULL.
}
\examples{
x <- data.frame(fruit = c("banana", "apple", "kiwi"),
                weight = c(4.5, 3.6, 1.2))

## Sorting manually:
pander::pander(x[order(x$fruit),])

## Sorting and fixing row names:
pander_sort(x, fruit)
}
