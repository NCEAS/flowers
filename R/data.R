#' Ocean Health Index scores.
#'
#' A dataset containing the calculated scores for Ocean Health Indices.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{goal}{price, in US dollars}
#'   \item{score}{OHI score for this goal}
#'   \item{order}{relative order of the goals}
#'   \item{weight}{relative weight of the goal, from 0 to 1}
#'   \item{name_supra}{name of the parent category for the goal}
#'   \item{name_flower}{name for the goal to be displayed on the flower plot}
#'   ...
#' }
#' @source \url{http://ohi-science.org/}
"ohi"
