#' Ocean Health Index scores.
#'
#' A dataset containing the calculated scores for Ocean Health Indices.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{goal}{OHI goal code}
#'   \item{score}{OHI score for this goal}
#'   \item{order}{relative order of the petals}
#'   \item{weight}{relative weight of the petal, from 0 to 1}
#'   \item{category}{name of the parent category for grouped petals}
#'   \item{label}{name for the label to be displayed on each petal}
#'   ...
#' }
#' @source \url{http://ohi-science.org/}
"ohi"
