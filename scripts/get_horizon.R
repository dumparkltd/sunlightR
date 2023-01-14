# get_horizon
#
# Function to calculate the minimum "sunny" altitudes for the entire horizon of 
# a location in a given DEM
#
# Arguments
# - lat
# - lon
# - dem: Digital Elevation Model, raster layer (includes information on grid spacing, etc)
# - res_azimuths: horizontal resolution of solar direction angles
#
# Result
# - horizon: vector of minimum altitudes
#
# Dependencies
# - get_min_altitude_for_azimuth
#
library(suncalc)
source("scripts/get_min_altitude_for_azimuth.R")
source("scripts/rad2deg.R")

get_horizon <- function (lon, lat, dem, res_azimuths, d_transect) {
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
  slp_sunrise = getSunlightPosition(
    date= sltimes$sunrise,
    lat = lat,
    lon = lon,
    keep = c( "azimuth")
  )
  slp_sunset = getSunlightPosition(
    date= sltimes$sunset,
    lat = lat,
    lon = lon,
    keep = c( "azimuth")
  )
  # convert to degrees, North to East, round up/down
  # WARNING should only work on N hemisphere
  azimuth_min = floor(rad2deg(slp_sunrise$azimuth)+180)
  azimuth_max = ceiling(rad2deg(slp_sunset$azimuth)+180)
  # get all minimum azimuths (from 0 to 360)
  altitudes <- c()
  azimuths <- c()
  for (i in seq(azimuth_min, azimuth_max, by = res_azimuths)) {
    altitudes = append(altitudes, get_min_altitude_for_azimuth(lon, lat, i, dem, d_transect))
    azimuths = append(azimuths, i)
  }
  return (data.frame(
    azimuths = azimuths,
    altitudes = altitudes
  ))
}