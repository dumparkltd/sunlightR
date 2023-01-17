library(raster)
library(doParallel)
library(foreach)

source("scripts/get_min_altitude_for_azimuth.R")

get_altitudes_for_azimuth_doP <- function (filename, azimuth) {
  
  # load raster
  dem = raster::raster(filename)
  
  cores = detectCores() - 1
  cl <- makeCluster(cores) 
  registerDoParallel(cl)
  
  # prepare empty result raster
  r <- raster(
    nrows = nrow(dem),
    ncols = ncol(dem),
    ext = extent(dem),
    res = res(dem),
    crs = crs(dem),
    vals = 0
  )
  
  # Create class which holds multiple results for each loop iteration.
  # Each loop iteration populates two properties: $result1 and $result2.
  # For a great tutorial on S3 classes, see: 
  # http://www.cyclismo.org/tutorial/R/s3Classes.html#creating-an-s3-class
  multiResultClass <- function(result1=NULL,result2=NULL)
  {
    me <- list(
      result1 = result1,
      result2 = result2
    )
    
    ## Set the name for the class
    class(me) <- append(class(me),"multiResultClass")
    return(me)
  }
  
  
  print(dem)
  
  oper <- foreach (i=1:ncell(dem)) %dopar% {
    library(raster)
    library(geosphere)
    
    source("scripts/get_transect2.R")
    source("scripts/rad2deg.R")
    source("scripts/get_min_altitude_for_azimuth.R")  
    demi = raster::raster("~/git/inrae/sunlightR/dem-250m.tif")
    
    result <- multiResultClass()
    result$result1 <- i+1
    result$result2 <- i+2
    return(result)
  
    # print(paste(Sys.time(), ' - ', 'calculating altitude for azimuth ', azimuth, ' and cell: ', i, ' of ', ncell(dem), sep=""))
    if (!is.na(demi[i])) {
      r[i] <- get_min_altitude_for_azimuth(
        cellNo = i,
        azimuth = azimuth,
        dem = demi
      )
    }
  }
  #end cluster
  stopCluster(cl)
  return(r)
}
 


