% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fast_dice.R
\name{fast_dice_tab}
\alias{fast_dice_tab}
\alias{fast_dice}
\title{Fast Dice Tabulation}
\usage{
fast_dice_tab(x, y)

fast_dice(x, y, verbose = FALSE)
}
\arguments{
\item{x}{A \code{nifti} image, filename, or \code{niftiImage}}

\item{y}{A \code{nifti} image, filename, or \code{niftiImage}}

\item{verbose}{A logical indicating output}
}
\value{
A table object
}
\description{
Fast Dice Tabulation
}
\examples{
library(oro.nifti)
set.seed(20161007)
dims = rep(10, 3)
arr = array(rnorm(10*10*10), dim = dims)
nim = oro.nifti::nifti(arr) > -1
fast_dice_tab(nim, nim)
fast_dice(nim, nim) == 1
}
