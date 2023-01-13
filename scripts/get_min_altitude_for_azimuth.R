# get_min_altitude_for_azimuth
#
# Function for calculating the minimum solar altitude (in degrees) for a given DEM for a 
# specific location and possible direction of the sun (azimuth)
#
#
# Arguments
# - lat
# - lon
# - azimuth: direction of sun (in degrees)
# - dem: Digital Elevation Model, raster layer (includes information on grid spacing, etc)
# - resolution: distance between locations in m
#
#
# Result
# - altitude (in degrees)
#
# Dependencies
# - get_transect
# - get_max_shade_distance

source("scripts/get_transect.R")
source("scripts/rad2deg.R")

get_min_altitude_for_azimuth <- function(lon, lat, azimuth, dem, resolution) {
  
  
  ll = data.frame(x=lon, y=lat)
  coordinates(ll) <- c("x", "y")
  proj4string(ll) <- CRS("+proj=longlat")
  spt <- spTransform(ll, CRS(projection(dem)))
  # extract elevation
  elevation = extract(dem, spt)
  
  min_altitude = 0
  
  transect = get_transect(lon, lat, azimuth, dem, resolution)
  # plot(transect$elev)
  
  elev_max_dem = maxValue(dem)
  d_vert_max = elev_max_dem - elevation
  
  for (i in 1:nrow(transect)) {
    elev_i = transect[i,]$elev
    if (!is.na(elev_i)) {
      d_vert = elev_i - elevation
      if (d_vert > 0) {
        d_horiz = (i - 1) * resolution
        altitude_i = rad2deg(atan(d_vert/d_horiz))
        if (altitude_i > min_altitude) {
          min_altitude <- altitude_i
        } else {
          # exit loop if higher altitude is globally no longer achievable
          altitude_max = rad2deg(atan(d_vert_max/d_horiz))
          if (altitude_max < min_altitude) {
            break
          }
        }
      }
    }

  }
  return (min_altitude)
}