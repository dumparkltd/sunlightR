library(sp)
library(raster)
source("scripts/get_min_altitude_for_azimuth.R")

# load raster
dem = raster("~/projects/INRAE/data/raster1.tif")

azimuth = 135

#lon = 0.818621526725745
#lat = 42.841380715123769
lon = 0.803670577449159
lat = 42.867089743756523

d_transect = 100

min_altitude = get_min_altitude_for_azimuth(lon, lat, azimuth, dem, d_transect)
