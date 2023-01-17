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
library(sf)
library(raster) 
library(geosphere)

get_transect2 <- function(lon, lat, azimuth, dem) {
  # print(lon)
  # print(lat)
  lats <- c(lat)
  lons <- c(lon)
  # prepare points
  latlons = data.frame(lon = lons, lat = lats)
  coordinates(latlons) <- c("lon", "lat")
  proj4string(latlons) <- CRS("+proj=longlat")
  point = destPoint(latlons, b=0, d=0)
  dp <- destPoint(latlons, b=azimuth, max(nrow(dem)*res(dem)[1], ncol(dem)*res(dem)[1]))
  line <- Line(cbind(c(point[1], dp[1]), c(point[2], dp[2])))
  sl <- SpatialLines(list(Lines(line, ID="a")))
  crs(sl) <- CRS("+proj=longlat")
  # extract elevations from dem for points
  elevations <- extract(dem, spTransform(sl, CRS(projection(dem))), cellnumbers=TRUE)
  
  return (data.frame(
    cellNo = elevations[[1]][,1],
    elev = elevations[[1]][,2]
  ))
}