library(raster)

source("scripts/get_min_altitude_for_azimuth.R")

get_altitudes_for_azimuth <- function (dem, azimuth) {
  # prepare empty result raster
  r <- raster(
    nrows = nrow(dem),
    ncols = ncol(dem),
    ext = extent(dem),
    res = res(dem),
    crs = crs(dem),
    vals = 0
  )
  
  for (i in 1:ncell(dem)) {
    # print(paste(Sys.time(), ' - ', 'calculating altitude for azimuth ', azimuth, ' and cell: ', i, ' of ', ncell(dem), sep=""))
    if (!is.na(dem[i])) {
      r[i] <- get_min_altitude_for_azimuth(
        cellNo = i,
        azimuth = azimuth,
        dem = dem
      )
    }
  }
  return(r)
}
 


