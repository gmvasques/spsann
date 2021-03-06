% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/optimMKV.R
\name{optimMKV}
\alias{objMKV}
\alias{optimMKV}
\title{Optimization of sample configurations for spatial interpolation}
\usage{
optimMKV(points, candi, iterations = 100, covars, eqn = z ~ 1, vgm,
  krige.stat = "mean", ..., x.max, x.min, y.max, y.min,
  acceptance = list(initial = 0.99, cooling = iterations/10),
  stopping = list(max.count = iterations/10), plotit = FALSE,
  track = FALSE, boundary, progress = TRUE, verbose = FALSE,
  greedy = FALSE, weights = NULL, nadir = NULL, utopia = NULL)

objMKV(points, candi, covars, eqn = z ~ 1, vgm, krige.stat = "mean", ...)
}
\arguments{
\item{points}{Integer value, integer vector, data frame or matrix. If
\code{points} is an integer value, it defines the number of points that
should be randomly sampled from \code{candi} to form the starting system
configuration. If \code{points} is a vector of integer values, it contains
the row indexes of \code{candi} that correspond to the points that form the
starting system configuration. If \code{points} is a data frame or matrix,
it must have three columns in the following order: \code{[, "id"]} the
row indexes of \code{candi} that correspond to each point, \code{[, "x"]}
the projected x-coordinates, and \code{[, "y"]} the projected y-coordinates.
Note that in the later case, \code{points} must be a subset of \code{candi}.}

\item{candi}{Data frame or matrix with the candidate locations for the
perturbed points. \code{candi} must have two columns in the following
order: \code{[, "x"]} the projected x-coordinates, and \code{[, "y"]} the
projected y-coordinates.}

\item{iterations}{Integer. The maximum number of iterations that should be
used for the optimization. Defaults to \code{iterations = 100}.}

\item{covars}{Data frame or matrix with the covariates in the columns.}

\item{eqn}{Formula string that defines the dependent variable \code{z}
as a linear model of the independent variables contained in \code{covars}.
Defaults to \code{eqn = z ~ 1}, that is, ordinary kriging. See the
argument \code{formula} in the function \code{\link[gstat]{krige}} for
more information.}

\item{vgm}{Object of class "variogramModel". See the argument
\code{model} in the function \code{\link[gstat]{krige}} for more
information.}

\item{krige.stat}{Character value defining the statistic that should be used
to summarize the kriging variance. Available options are \code{"mean"} and
\code{"max"} for the mean and maximum kriging variance, respectively.
Defaults to \code{krige.stat = "mean"}.}

\item{...}{further arguments passed to \code{\link[gstat]{krige}}.}

\item{x.max,x.min,y.max,y.min}{Numeric value. The minimum and maximum
quantity of random noise to be added to the projected x- and y-coordinates.
The minimum quantity should be equal to, at least, the minimum distance
between two neighbouring candidate locations. The units are the same as of
the projected x- and y-coordinates. If missing, they are estimated from
\code{candi}.}

\item{acceptance}{List with two named sub-arguments: \code{initial} --
numeric value between 0 and 1 defining the initial acceptance probability,
and \code{cooling} -- a numeric value defining the exponential factor by
witch the acceptance probability decreases at each iteration. Defaults to
\code{acceptance = list(initial = 0.99, cooling = iterations / 10)}.}

\item{stopping}{List with one named sub-argument: \code{max.count} --
integer value defining the maximum allowable number of iterations without
improvement of the objective function value. Defaults to
\code{stopping = list(max.count = iterations / 10)}.}

\item{plotit}{Logical for plotting the optimization results. This includes
a) the progress of the objective function values and acceptance
probabilities, and b) the original points, the perturbed points and the
progress of the maximum perturbation in the x- and y-coordinates. The plots
are updated at each 10 iterations. Defaults to \code{plotit = FALSE}.}

\item{track}{Logical value. Should the evolution of the energy state and
acceptance probability be recorded and returned with the result? If
\code{track = FALSE} (the default), only the starting and ending enery state
values are returned with the result.}

\item{boundary}{SpatialPolygon. The boundary of the spatial domain.
If missing, it is estimated from \code{candi}.}

\item{progress}{Logical for printing a progress bar. Defaults to
\code{progress = TRUE}.}

\item{verbose}{Logical for printing messages about the progress of the
optimization. Defaults to \code{verbose = FALSE}.}

\item{greedy}{Logical value. Should the optimization be done using a greedy
algorithm, that is, accepting only better system configurations? Defaults
to \code{greedy = FALSE}. (experimental)}

\item{weights}{List with named sub-arguments. The weights assigned to each
one of the objective functions that form the multi-objective optimization
problem (MOOP). They must be named after the respective objective function
to which they apply. The weights must be equal to or larger than 0 and sum
to 1. The default option gives equal weights to all objective functions.}

\item{nadir}{List with named sub-arguments. Three options are available:
1) \code{sim} -- the number of simulations that should be used to estimate
the nadir point, and \code{seeds} -- vector defining the random seeds for
each simulation; 2) \code{user} -- a list of user-defined nadir values named
after the respective objective function to which they apply; 3) \code{abs}
-- logical for calculating the nadir point internally (experimental).}

\item{utopia}{List with named sub-arguments. Two options are available: 1)
\code{user} -- a list of user-defined values named after the respective
objective function to which they apply; 2) \code{abs} -- logical for
calculating the utopia point internally (experimental).}
}
\value{
\code{optimMKV} returns a matrix: the optimized sample configuration.

\code{objMKV} returns a numeric value: the energy state of the sample
configuration - the objective function value.
}
\description{
Optimize a sample configuration for spatial interpolation with a known linear
model. A criterion is defined so that the sample configuration minimizes the
mean/maximum kriging variance (\bold{MKV}).
}
\note{
This function is based on the method originally proposed by Heuvelink, Brus
and de Gruijter (2006) and implemented in the R-package
\pkg{intamapInteractive} by Edzer Pebesma and Jon Skoien.
}
\section{Jittering methods}{

There are two ways of jittering the coordinates. They differ on how the
set of candidate locations is defined. The first method uses an
\emph{infinite} set of candidate locations, that is, any point in the spatial
domain can be selected as the new location of a perturbed point. All that
this method needs is a polygon indicating the boundary of the spatial domain.
This method is not implemented in the \pkg{spsann} package (yet) because it
is computationally demanding: every time a point is jittered, it is necessary
to check if it is inside the spatial domain.

The second method consists of using a \emph{finite} set of candidate
locations for the perturbed points. A finite set of candidate locations is
created by discretizing the spatial domain, that is, creating a fine grid of
points that serve as candidate locations for the perturbed points. This is
the only method currently implemented in the \pkg{spsann} package because it
is one of the least computationally demanding.

Using a finite set of candidate locations has one important inconvenience.
When a point is selected to be jittered, it may be that the new location
already is occupied by another point. If this happens, another location is
iteratively sought for as many times as there are points in \code{points}.
Because the more points there are in \code{points}, the more likely it is
that the new location already is occupied by another point. If a solution is
not found, the point selected to be jittered point is kept in its original
location.

A more elegant method can be defined using a finite set of candidate
locations coupled with a form of \emph{two-stage random sampling} as
implemented in \code{\link[spcosa]{spsample}}. Because the candidate
locations are placed on a finite regular grid, they can be seen as being the
centre nodes of a finite set of grid cells (or pixels of a raster image). In
the first stage, one of the \dQuote{grid cells} is selected with replacement,
i.e. independently of already being occupied by another sample point. The new
location for the point chosen to be jittered is selected within that
\dQuote{grid cell} by simple random sampling. This method guarantees that
any location in the spatial domain can be a candidate location. It also
discards the need to check if the new location already is occupied by
another point. This method is not implemented (yet) in the \pkg{spsann}
package.
}

\section{Distance between two points}{

The distance between two points is computed as the Euclidean distance between
them. This computation assumes that the optimization is operating in the
two-dimensional Euclidean space, i.e. the coordinates of the sample points
and candidate locations should not be provided as latitude/longitude. Package
\pkg{spsann} has no mechanism to check if the coordinates are projected, and
the user is responsible for making sure that this requirement is attained.
}

\section{Multi-objective optimization}{

A method of solving a multi-objective optimization problem is to aggregate
the objective functions into a single \emph{utility function}. In the
\pkg{spsann} package, the aggregation is performed using the \emph{weighted
sum method}, which incorporates in the weights the preferences of the user
regarding the relative importance of each objective function.

The weighted sum method is affected by the relative magnitude of the
different function values. The objective functions implemented in the
\pkg{spsann} package have different units and orders of magnitude. The
consequence is that the objective function with the largest values will have
a numerical dominance in the optimization. In other words, the weights will
not express the true preferences of the user, and the meaning of the utility
function becomes unclear.

A solution to avoid the numerical dominance is to transform the objective
functions so that they are constrained to the same approximate range of
values. Several function-transformation methods can be used and the
\pkg{spsann} offers a few of them. The \emph{upper-lower-bound approach}
requires the user to inform the maximum (nadir point) and minimum (utopia
point) absolute function values. The resulting function values will always
range between 0 and 1.

Using the \emph{upper-bound approach} requires the user to inform only the
nadir point, while the utopia point is set to zero. The upper-bound approach
for transformation aims at equalizing only the upper bounds of the objective
functions. The resulting function values will always be smaller than or equal
to 1.

Sometimes, the absolute maximum and minimum values of an objective function
can be calculated exactly. This seems not to be the case of the objective
functions implemented in the \pkg{spsann} package. If the user is
uncomfortable with informing the nadir and utopia points, there is the option
for using \emph{numerical simulations}. It consists in computing the function
value for many random sample configurations. The mean function value is used
to set the nadir point, while the the utopia point is set to zero. This
approach is similar to the upper-bound approach, but the function values will
have the same orders of magnitude only at the starting point of the
optimization. Function values larger than one are likely to occur during the
optimization. We recommend the user to avoid this approach whenever possible
because the effect of the starting point on the optimization as a whole
usually is insignificant or arbitrary.

The \emph{upper-lower-bound approach} with the \emph{Pareto maximum and
minimum values} is the most elegant solution to transform the objective
functions. However, it is the most time consuming. It works as follows:

\enumerate{
  \item Optimize a sample configuration with respect to each objective
  function that composes the MOOP;
  \item Compute the function value of every objective function for every
  optimized sample configuration;
  \item Record the maximum and minimum absolute function values computed for
  each objective function--these are the Pareto maximum and minimum.
}

For example, consider that a MOOP is composed of two objective functions (A
and B). The minimum absolute value for function A is obtained when the sample
configuration is optimized with respect to function A. This is the Pareto
minimum of function A. Consequently, the maximum absolute value for function
A is obtained when the sample configuration is optimized regarding function
B. This is the Pareto maximum of function A. The same logic applies for
function B.
}
\examples{
\dontrun{
# This example takes more than 5 seconds to run!
require(sp)
require(gstat)
data(meuse.grid)
candi <- meuse.grid[, 1:2]
covars <- as.data.frame(meuse.grid)
vgm <- vgm(psill = 10, model = "Exp", range = 500, nugget = 8)
set.seed(2001)
res <- optimMKV(points = 100, candi = candi, covars = covars, maxdist = 500,
                eqn = z ~ dist, vgm = vgm)
objSPSANN(res) # 11.9878
objMKV(points = res, candi = candi, covars = covars, eqn = z ~ dist,
       vgm = vgm, maxdist = 500)
}
}
\author{
Alessandro Samuel-Rosa \email{alessandrosamuelrosa@gmail.com}
}
\references{
Edzer Pebesma, Jon Skoien with contributions from Olivier Baume, A. Chorti,
D.T. Hristopulos, S.J. Melles and G. Spiliopoulos (2013).
\emph{intamapInteractive: procedures for automated interpolation - methods
only to be used interactively, not included in \code{intamap} package.} R
package version 1.1-10.

van Groenigen, J.-W. \emph{Constrained optimization of spatial sampling:
a geostatistical approach.} Wageningen: Wageningen University, p. 148, 1999.

Arora, J. \emph{Introduction to optimum design}. Waltham: Academic Press, p.
896, 2011.

Marler, R. T.; Arora, J. S. Survey of multi-objective optimization methods
for engineering. \emph{Structural and Multidisciplinary Optimization}, v. 26,
p. 369-395, 2004.

Marler, R. T.; Arora, J. S. Function-transformation methods for
multi-objective optimization. \emph{Engineering Optimization}, v. 37, p.
551-570, 2005.

Marler, R. T.; Arora, J. S. The weighted sum method for multi-objective
optimization: new insights. \emph{Structural and Multidisciplinary
Optimization}, v. 41, p. 853-862, 2009.

Brus, D. J. & Heuvelink, G. B. M. Optimization of sample patterns for
universal kriging of environmental variables. \emph{Geoderma}. v. 138,
p. 86-95, 2007.

Heuvelink, G. B. M.; Brus, D. J. & de Gruijter, J. J. Optimization of sample
configurations for digital mapping of soil properties with universal kriging.
In: Lagacherie, P.; McBratney, A. & Voltz, M. (Eds.) \emph{Digital soil
mapping - an introductory perspective}. Elsevier, v. 31, p. 137-151, 2006.
}
\concept{
simulated annealing

spatial interpolation
}
\keyword{iteration}
\keyword{optimize}
\keyword{spatial}

