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

get_transect <- function(lon, lat, azimuth, dem, resolution) {
  point = destPoint(c(lon, lat), b=azimuth, d=0)
  
  lats <- c()
  lons <- c()
  elevations <- c()
  
  while (contains_raster_location(point[1], point[2], dem)) {
    lon_current = point[1]
    lat_current = point[2]
    
    # project
    ll = data.frame(x=point[1], y=point[2])
    coordinates(ll) <- c("x", "y")
    proj4string(ll) <- CRS("+proj=longlat")
    spt <- spTransform(ll, CRS(projection(dem)))
    # extract elevation
    elev_current = extract(dem, spt)
    
    # remember lats/lons
    lons = append(lons, lon_current)
    lats = append(lats, lat_current)
    # remember elevations
    elevations = append(elevations, elev_current)
    
    # calculate new point
    point = destPoint(point, b=azimuth, d=resolution)
  }
  
  return (data.frame(
    lon = lons,
    lat = lats,
    elev = elevations
  ))
}