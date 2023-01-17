library(sp)
library(raster)
library(suncalc)

source("scripts/get_altitudes_for_azimuth.R")
source("scripts/rad2deg.R")

get_all_horizons2 <- function (dem, settings) {
  
  # figure out min/max azimuth
  latlon <- as.data.frame(
    spTransform(
      xyFromCell(dem,c(1),spatial=TRUE),
      CRS("+proj=longlat")
    )
  )
  lon = latlon$x
  lat = latlon$y
  
  date_longest_N = as.Date("2023-06-21")
  date_longest_S = as.Date("2023-12-21")
  # get azimuth boundaries
  if (lat > 0) {
    sltimes <- getSunlightTimes(
      date = date_longest_N,
      lat = lat,
      lon = lon,
      keep = c("sunrise", "sunset"),
      tz = "UTC"
    )
  } else {
    sltimes <- getSunlightTimes(
      date = date_longest_S,
      lat = lat,
      lon = lon,
      keep = c("sunrise", "sunset"),
      tz = "UTC"
    )
  }
  # in radians 
  # "sun azimuth in radians (direction along the horizon, measured 
  # from south to west), e.g. 0 is south and Math.PI * 3/4 is northwest"
  slp_sunrise <- getSunlightPosition(
    date= sltimes$sunrise,
    lat = lat,
    lon = lon,
    keep = c( "azimuth")
  )
  slp_sunset <- getSunlightPosition(
    date= sltimes$sunset,
    lat = lat,
    lon = lon,
    keep = c( "azimuth")
  )
  # convert to degrees, North to East, round up/down
  # WARNING should only work on N hemisphere
  azimuth_min <- floor(rad2deg(slp_sunrise$azimuth)+180)
  azimuth_max <- ceiling(rad2deg(slp_sunset$azimuth)+180)
  
  # round azimuths
  res_azimuths = settings$resolution_azimuths
  azimuth_min <- ceiling(azimuth_min / res_azimuths) * res_azimuths
  azimuth_max <- floor(azimuth_max / res_azimuths) * res_azimuths
  print(paste(Sys.time(), ' - ', 'calculating altitudes for azimuths: ', azimuth_min, ':', azimuth_max, sep=""))
  
  azimuths <- c()
  altitudes <- c()
  for (i in seq(azimuth_min, azimuth_max, by = res_azimuths)) {
    print(paste(Sys.time(), ' - ', 'calculating altitudes for azimuth: ', i, sep=""))
    writeRaster(
      get_altitudes_for_azimuth(dem, i, settings),
      filename=paste("azimuth-", i, ".tif", sep=""),
      format="GTiff",
      overwrite=TRUE
    )
    # altitudes = append(altitudes, get_altitudes_for_azimuth(dem, i, settings))
    azimuths = append(azimuths, i)
  }
  

  return(list(
    azimuths = azimuths,
    altitudes = altitudes
  ))
  
}