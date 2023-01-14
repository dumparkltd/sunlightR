# get_transect
# 
# Function for calculating the height profile for a given DEM from a specific location towards 
# the possible direction of the sun (azimuth)
# 
#
# Arguments
# - lat
# - lon
# - azimuth: direction of sun
# - dem: Digital Elevation Model, raster layer (includes information on grid spacing, etc)
# - resolution: distance between locations in m
#
#
# Result
# - transect (matrix of heights for locations)

library(sp)
library(raster)
library(geosphere)

source("scripts/contains_raster_location.R")

get_transect_2 <- function(lon, lat, azimuth, dem, resolution) {
  point = destPoint(c(lon, lat), b=azimuth, d=0)
  
  lats <- c()
  lons <- c()
  
  # determine points along azimuth
  while (contains_raster_location(point[1], point[2], dem)) {
    lon_current = point[1]
    lat_current = point[2]
    
    # remember lats/lons
    lons = append(lons, lon_current)
    lats = append(lats, lat_current)
    
    # calculate new point
    # https://rspatial.org/raster/sphere/3-direction.html#point-at-distance-and-bearing
    point = destPoint(point, b=azimuth, d=resolution)
  }
  
  # prepare points
  latlons = data.frame(lon = lons, lat = lats)
  coordinates(latlons) <- c("lon", "lat")
  proj4string(latlons) <- CRS("+proj=longlat")
  
  # re-project points to projection of dem
  latlons_reproj <- spTransform(latlons, CRS(projection(dem)))
  
  # extract elevations from dem for points
  elevations = extract(dem, latlons_reproj)
  
  return (data.frame(
    lon = lons,
    lat = lats,
    elev = elevations
  ))
}