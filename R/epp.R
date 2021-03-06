#' @rdname      epp
#' @exportClass epp
setClass("epp", representation(
  breedingDat     = "SpatialPointsBreeding", 
  polygonsDat     = "SpatialPolygonsDataFrame", 
  eppDat          = "eppMatrix", 
  maxlag          = "numeric", 
  EPP             = "data.frame"
  ),
  
  validity = function(object) {
     # TODO
    return(TRUE)
    }
 )



#' Building data-set for realized and unrealized EPP-pairs
#' 
#' \code{epp} combines a \code{SpatialPointsBreeding}, a
#' \code{SpatialPolygons*} as obtained from \code{DirichletPolygons} and a
#' \code{eppMatrix} to create the spatial context for every potential and
#' realized extra-pair male-female combination.
#' 
#' 'plot' plots the territories, the identity of males ('m...') and females
#' ('f...') at breeding sites (numbers), and the extra-pair events (dashed red
#' arrows). Individuals that had extra-pair offspring are marked red. The
#' parameter 'zoom' can be used to make a detailed visual check of a specific
#' location (nestbox) and its surroundings. \cr \cr 'barplot' displays the
#' distribution of extra-pair events over different breeding distances between
#' the partners (in the number of territories) as vertical bars. Note that the
#' distribution of all potential extra-pair partners is displayed as a dashed
#' line only if the argument 'relativeValues' is TRUE.
#' 
#' @aliases epp epp-class as.data.frame as.data.frame,epp-method
#' plot,epp,missing-method plot.epp barplot barplot,epp-method
#' @param breedingDat A SpatialPointsBreeding object, created by the
#' \code{SpatialPointsBreeding} function
#' @param polygonsDat A SpatialPolygons* object as obtained by calling
#' \code{DirichletPolygons} function
#' @param eppDat An object of class \code{eppMatrix}
#' @param maxlag A numeric value indicating the maximum breeding distance for
#' which male-female combinations should be calculated. When plotting it
#' defines the outermost row of neighbors plotted around a focal id set by
#' zoom
#' @param x,height an \code{epp} object
#' @param zoom a \code{SpatialPointsBreeding} id which is used for subsetting
#' prior to plot
#' @param zoom.col background color of the id (and hence the polygon) set by
#' \code{zoom}
#' @param relativeValues Defines the unit of the y-axis. TRUE plots
#' proportions, FALSE absolute numbers.
#' @param ... further arguments to pass to \code{plot.SpatialPointsBreeding}
#' and \code{plot.SpatialPolygons*}
#' @return Returns an S4-class epp-object with 5 slots:
#' 
#' \item{breedingDat}{ Input breeding data-set.} \item{polygonsDat}{ Either
#' polygons are estimated automatically using Thiessen Polygons, or input
#' breeding polygons.} \item{eppDat}{ Input data.frame with all male-female
#' combinations that had EPP together.} \item{maxlag}{ Input rank. Defaults to
#' 3.} \item{EPP}{ \code{data.frame} containing columns for the focal male and
#' female ("male", "female"), their breeding distance ("rank"), and the
#' parameters associated either with the male (column with prefix "_MALE") or
#' the female (column with prefix "_FEMALE") territory.}
#' @seealso vignette(expp)
#' @keywords spatial
#' @export
#' @examples
#' 
#'   ### Simple example with three breeding pairs
#'   require(expp)
#'   # create raw data
#'   set.seed(1310)
#'   b = data.frame(id = as.integer(10:12), x = rnorm(3), y = rnorm(3), 
#'   male = paste0("m",1:3), female =  paste0("f",1:3), xx = rnorm(3), stringsAsFactors=FALSE  )  
#'   eppPairs = data.frame(male = c("m1", "m2", "m1"), female=c("f3", "f1", "f2") )
#'   
#'   # prepare data
#'   breedingDat = SpatialPointsBreeding(b, id = 'id', coords = ~ x + y, breeding = ~ male + female)
#'   polygonsDat = DirichletPolygons(breedingDat)
#'   eppDat   = eppMatrix(eppPairs, pairs = ~ male + female)
#' 
#'   plot(breedingDat, eppDat)
#'   
#'   # convert to epp class     
#'   x = epp(breedingDat, polygonsDat, eppDat, maxlag = 3)
#'   as.data.frame(x)
#'   
#'   
#'   #plot 
#'   plot(x) 
#'   
#'   ### Example on a random data set with n breeding pairs and  n/2 extra-pair paternity rate
#'   # create raw data
#'   set.seed(123)
#'   n = 20
#'   b = data.frame(id = 1:n, x = rnorm(n), y = rnorm(n), 
#'   male = paste0("m",1:n), female =  paste0("f",1:n), xx = rnorm(n), stringsAsFactors=FALSE  )  
#'   eppPairs = data.frame(male = sample(b$male, round(n/2) ), female = sample(b$female, round(n/2) ) )
#'   
#'   # prepare data
#'   breedingDat = SpatialPointsBreeding(b, id = 'id', coords = ~ x + y, breeding = ~ male + female)
#'   polygonsDat = DirichletPolygons(breedingDat)
#'   eppDat   = eppMatrix(eppPairs, pairs = ~ male + female)
#'   
#'   # convert to epp class
#'   x = epp(breedingDat, polygonsDat, eppDat, maxlag = 10)
#'   
#'   # plot 
#'   plot(x)
#'   barplot(x) 
#'   barplot(x, relativeValues = TRUE) 
#'   
#' 
#' \donttest{   
#'   ### Real data example
#'   # Raw datasets 
#'   data(bluetit_breeding)
#'   data(bluetit_epp)
#'   # select one year 
#'   year = 2010
#'   b = bluetit_breeding[bluetit_breeding$year_ == year, ]
#'   eppPairs = bluetit_epp[bluetit_epp$year_ == year, ]
#'   
#'   # prepare data
#'   breedingDat  = SpatialPointsBreeding(b, id = 'id', coords = ~ x + y, breeding = ~ male + female)
#'   polygonsDat = DirichletPolygons(breedingDat)
#'   eppDat = eppMatrix(eppPairs, pairs = ~ male + female)
#'   
#'   # convert to epp class
#'   x = epp(breedingDat, polygonsDat, eppDat, maxlag = 2)
#'   
#'   # plot
#'   plot(x)
#'   barplot(x) 
#'   # plot zoom
#'   plot(x, zoom = 120, maxlag = 3) 
#'   
#'   # run model on epp probability     
#'   dat = as.data.frame(x)
#'   nrow(dat[dat$epp == 1, c('male', 'female')] )
#'   nrow(unique(eppPairs))
#'   
#'   if(require(lme4))
#'    (summary(glmer(epp ~ rank + male_age_MALE + (1|male) + (1|female), 
#'     data = dat, family = binomial)))
#' 
#' }
#'   
#' 
epp <- function(breedingDat, polygonsDat, eppDat, maxlag = 3) { 

	# bricks
	epd = data.frame(z = paste(eppDat@male, eppDat@female), epp = 1, stringsAsFactors = FALSE)
  	if( missing(polygonsDat) )   polygonsDat = DirichletPolygons(breedingDat)
	
  	nb  = poly2nb(polygonsDat, row.names = polygonsDat$ID, queen = TRUE) 
  	hnb = higherNeighborsDataFrame(nb, maxlag = maxlag)
  	b   = data.frame(breedingDat@data, id = breedingDat@id, male = breedingDat@male, female = breedingDat@female, stringsAsFactors = FALSE)
	b$k = NULL
		
	# pre new() validity
	if( length(setdiff(polygonsDat@data[, 1], breedingDat@id ) ) > 0  )
      stop( "the 1st column of ", dQuote("polygonsDat"), " should be identical with ",  dQuote("breedingDat"), " id." )
            
    if( length(intersect(breedingDat@male, eppDat@male ) ) < 1 )
      stop("no extra-pair males found in breedingDat.")
    
	noepp = intersect(epd$z, paste(breedingDat@male, breedingDat@female) )
	if( length( noepp) > 0 ){ 
       warning("extra-pair partners cannot be social partners. The following pairs in eppDat are disregarded:\n", paste( sQuote(noepp), collapse = ",") ) }
    
    # build up epp set
    d = merge(hnb, b, by = "id") 
    d = merge(d, b, by.x = 'id_neigh', by.y = 'id',  all.x = TRUE, suffixes= c("_MALE","_FEMALE") )
    d$z = paste(d$male_MALE, d$female_FEMALE)    
    d = merge(d, epd, by = "z", all.x = TRUE)
	d[is.na(d$epp), "epp"] = 0
    d$z = NULL
    
    # fix names
    names(d) [which(names(d) == "male_MALE")] = "male"
    names(d) [which(names(d) == "female_FEMALE")] = "female"
    d$male_FEMALE = NULL; d$female_MALE = NULL    
	
	names(d) [which(names(d) == "id")] = "id_MALE"
	names(d) [which(names(d) == "id_neigh")] = "id_FEMALE"
	
    d = d[, union(c("id_FEMALE", "id_MALE", "rank", "male", "female", "epp"), names(d)) ]
    
	
	# post-merge validity
	eppInSet = apply(unique((d[d$epp == 1, c('male', 'female')] )), 1, paste, collapse = " ")
	lostEpPairs = setdiff(eppInSet,  epd$z)	
	
	if( length(lostEpPairs) > 0  ) {
	warning("something wicked happened merging datasets; some extra-pair partners are not in the final dataset:\n", paste( sQuote(lostEpPairs), collapse = ",") )
    }
	
	
	
    # new
	new("epp", breedingDat = breedingDat, polygonsDat = polygonsDat, eppDat = eppDat, maxlag = maxlag, EPP = d)
	
	
	
	
	}

if (!isGeneric("plot"))
  setGeneric("plot", function(x, y, ...) standardGeneric("plot"))


#' @export
#' @rdname  epp
setMethod("plot", signature(x = "epp", y = "missing"), 
    function(x, zoom, maxlag = 3, zoom.col = 'grey', ...) {
			
    p = x@polygonsDat
    b = x@breedingDat
    emat = x@eppDat
    e = x@EPP	
    	
    if( !missing(zoom)) { 
    	set = unique( c(zoom, 
    		e[e$id_FEMALE%in%zoom & e$rank <= maxlag, 'id_MALE'], 
    		e[e$id_MALE%in%zoom   & e$rank <= maxlag, 'id_FEMALE']) 
    		)
    	
    	p = p[p$ID%in%set, ]	
    	
    	bset = which(b@id%in%set)
    	b = b[bset, ]
    	b@male = b@male[bset]
    	b@female = b@female[bset]
    	b@id = b@id[bset]

    emat = e[ (e$id_FEMALE%in%set | e$id_MALE%in%set) & e$epp == 1, c("male", "female")]
    	emat = eppMatrix(emat)

    }
    	
    sp::plot(p, ...)
    if(!missing(zoom) )
    	sp::plot(p[p$ID == zoom, ], col = zoom.col, add = TRUE)
    sp::plot(b, emat, add = TRUE, ...)

    })


if (!isGeneric("barplot")) {
    setGeneric("barplot", function(height,...)
      standardGeneric("barplot"))
   }  
    
#' @export
#' @rdname  epp 
setMethod("barplot", signature(height = "epp"),
          function(height, relativeValues = FALSE, ...) {

          p = table(height@EPP[,c('rank', 'epp')])

          if(relativeValues == FALSE) {
              p = p[,2]
              plot(p, type = 'h', axes = FALSE, ylab ='No. of EPP events', xlab = 'Distance', ...)
              axis(1, at = 1:max(height@EPP$rank), labels = 1:max(height@EPP$rank))
              axis(2, at = 0:(max(p)), labels = 0:(max(p)))
            }

          if(relativeValues == TRUE) {
              p[,1] = p[,1]+p[,2]
              p = apply(p, MARGIN = 2, FUN = function(x) x/sum(x))
              plot(p[,2], type = 'h', axes = FALSE, ylab ='', xlab = '', ...)
              par(new = TRUE)
              plot(p[,1], type = 'l', axes = FALSE, ylab ='Proportion of EPP events', xlab = 'Distance', lty = 2, ...)
              axis(1, at = 1:max(height@EPP$rank), labels = 1:max(height@EPP$rank))
              axis(2, labels = (0:10)/10, at = (0:10)/10)  
          }
                  
          })

if (!isGeneric("as.data.frame")) {
  setGeneric("as.data.frame", function(x)
    standardGeneric("as.data.frame"))
  }	

#' @export
#' @rdname  epp
setMethod('as.data.frame', signature(x='epp'), 
          function(x) {
            return(x@EPP)
          } )



	
	
	
	
	
	
	




















