# get_max_shade_distance
#
# Function to calculate the maximum distance to a location that can still increase the 
# current minimum altitude 
# (a more distant obstacle must have a certain height to be able to increase the 
# minimum altitude resulting from a closer obstacle)
#
#
# Arguments
# - transect: matrix of heights for locations
# - min_altitude: the current minimum altitude (in degrees)
# - d_min_altitude: the distance to location that yielded the current minimum altitude
#
# Result
# - max_shade_distance
#
#
max_shade_distance <- function(transect, min_altitude, d_min_altitude) {
  # TODO
  # 1. calculate max elevation of transect
  # 2. calculate max distance for max elevation given min altitude
  return (max_d)
}
