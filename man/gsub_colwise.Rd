% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/csv_to_html.R
\name{gsub_colwise}
\alias{gsub_colwise}
\title{Apply gsub on string/factor columns of dataframe}
\usage{
gsub_colwise(df, pattern, replacement)
}
\arguments{
\item{df}{Dataframe with string columns, used as input}

\item{pattern}{regex to apply}

\item{replacement}{replacement for pattern}
}
\value{
A dataframe like df1, with pattern replaced by replacement in columns
}
\description{
Apply gsub on string/factor columns of dataframe
}
\examples{
tibble::tibble(x=c('hello','world'),y=c('a', 'o'))  \%>\% gsub_colwise('o','u')
}
