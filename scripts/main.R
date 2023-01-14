library(sp)
library(raster)

source("scripts/get_horizon.R")
source("scripts/get_min_altitude_for_azimuth.R")
source("scripts/get_transect.R")

# load raster
dem = raster("~/projects/INRAE/data/raster1.tif")

# test location
lon = 0.818621526725745
lat = 42.841380715123769
# lon = 0.803670577449159
# lat = 42.867089743756523

# the distance between elevation points (in m)
d_transect = 10

# horizontal resolution of azimuth (in degrees)
resolution_azimuths = 2 

horizon = get_horizon(lon, lat, dem, resolution_azimuths, d_transect)

plot(horizon)

# azimuth = 210
# transect = get_transect(lon, lat, azimuth, dem, d_transect)
# 
# get_min_altitude_for_azimuth(lon, lat, azimuth, dem, d_transect)