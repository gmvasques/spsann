# Supress R CMD check note 'no visible binding for global variable ...' ########
# Source: http://stackoverflow.com/a/12429344/3365410
if (getRversion() >= "2.15.1") {
  utils::globalVariables(names = c("covars.type", "sm", "n_pts", "n_cov", 
                                   "n_candi", "wp", "conf0", "pre.distri",
                                   "pop.prop"))
}

# Import functions from default packages other than `base` #####################
# Source: http://stackoverflow.com/a/31314870/3365410
#' @importFrom stats cor quantile runif terms
#' @importFrom graphics axis hist legend lines mtext par plot points text
#' @importFrom utils setTxtProgressBar txtProgressBar head tail

# Import functions from non-default packages ###################################
#' @importFrom sp plot bbox
#' @importFrom pedometrics cramer is.numint cont2cat is.all.factor is.any.factor
#' @importFrom SpatialTools dist2
