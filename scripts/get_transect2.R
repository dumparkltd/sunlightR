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

library(sf)
library(sp)
library(raster) 
library(geosphere)

get_transect2 <- function(xy_origin, azimuth, dem) {
  # get target point, outside of dem
  point_origin <- st_point(c(xy_origin[1], xy_origin[2]))
  sfc = st_sfc(point_origin, crs = crs(dem, asText=TRUE))
  ll_origin <- st_transform(sfc, crs = "+proj=longlat")

  dem_length <- max(nrow(dem)*res(dem)[1], ncol(dem)*res(dem)[1])
  ll_target <- destPoint(c(ll_origin[[1]]), b=azimuth, dem_length)
  ll_target_point <- st_point(c(ll_target[1], ll_target[2]))
  xy_target <- st_transform(
    st_sfc(ll_target_point, crs = "+proj=longlat"),
    crs = crs(dem, asText=TRUE)
  )
  # sp::Line, sp::Lines, sp:: SpatialLines, sp::crs
  line <- Line(cbind(c(point_origin[1], xy_target[[1]][1]), c(point_origin[2], xy_target[[1]][2])))
  sl <- SpatialLines(list(Lines(line, ID="a")))
  crs(sl) <- crs(dem)
  
  # extract elevations from dem for points
  # raster::extract
  elevations <- extract(dem, sl, cellnumbers=TRUE)
  
  return (data.frame(
    cellNo = elevations[[1]][,1],
    elev = elevations[[1]][,2]
  ))
} 