# get_altitude_min_for_azimuth
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


get_min_altitude_for_azimuth <- function(cellNo, azimuth, dem) {
  library(geosphere)
  
  source("scripts/get_transect2.R")
  source("scripts/rad2deg.R")
  
    # set minimum solar altitude
  altitude_min = 0
  # extract elevation of origin cell
  elevation_origin = dem[cellNo]
  
  if (!is.na(elevation_origin)) {
    # get lan/lon from origin cell
    xy_origin <- xyFromCell(dem, c(cellNo))

    # calculate transect
    # returns data frame with 2 columns, cellNo and elevations
    transect <- get_transect2(
      xy_origin,
      azimuth,
      dem
    )
    
    # calculate maximum possible difference in elevation
    elev_max_dem = maxValue(dem)
    d_vert_max = elev_max_dem - elevation_origin
    
    # figure out minimum solar altitude (in degrees) from vertical and horizontal distance
    for (i in 1:nrow(transect)) {
      
      # the target elevation
      elevation_target = transect[i,]$elev
      
      if (!is.na(elevation_target)) {
        
        # the vertical distance
        d_vert = elevation_target - elevation_origin
        
        if (d_vert > 0) {
          
          # get lan/lon from target cell
          xy_target <- xyFromCell(dem, c(transect[i,]$cellNo))
          # ll_target <- as.data.frame(spTransform(xy_target, CRS("+proj=longlat")))
          # calculate horizontal distance (in m) between origin cell and target cell
          # poor performance!
          # https://rdrr.io/cran/geosphere/man/distm.html
          # d_horiz = distm (
          #   c(ll_origin$x, ll_origin$y),
          #   c(ll_target$x, ll_target$y),
          #   fun = distHaversine
          # )
          # WARNING assumes units of m
          dx = abs(xy_origin[1] - xy_target[1])
          dy = abs(xy_origin[2] - xy_target[2])
          d_horiz = sqrt(dx^2 + dy^2)
          
          # calculate angle
          altitude_target = rad2deg(atan(d_vert/d_horiz))
          
          # remember angle if greater than previous
          if (altitude_target > altitude_min) {
            altitude_min <- altitude_target
          } else {
            # exit loop if highest possible elevation would no longer increase altitude
            altitude_max = rad2deg(atan(d_vert_max/d_horiz))
            if (altitude_max < altitude_min) {
              break
            }
          }
        }
      }
    }
  }
  return (altitude_min)
}