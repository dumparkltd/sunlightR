# library(sp)
# library(raster)
# 
# source("scripts/is_shade.R")
# # source("scripts/get_min_altitude_for_azimuth.R")
# # source("scripts/get_transect.R")
# 
# # load raster
# dem = raster("~/projects/INRAE/data/raster1.tif")
# 
# # test location
# # lon = 0.818621526725745
# # lat = 42.841380715123769
# # lon = 0.803670577449159
# # lat = 42.867089743756523
# # lon = 0.85830
# # lat = 42.82580
# 
# settings <- list(
#   d_transect = 100, # the distance between elevation points (in m)
#   resolution_azimuths = 1, # horizontal resolution of azimuth (in degrees)
#   resolution_dem_target = 1000 # target resolution of dem (in m)
# )
# 
# 
# # downsample raster
# 
# dem_at_res <- aggregate(
#   dem,
#   fact = ceiling(settings$resolution_dem_target / xres(dem))
# )
# 
# print(Sys.time())
# horizons_raster = get_all_horizons2(dem_at_res, settings)
# print(Sys.time())
# 
# 
# # azimuth = 210
# # transect = get_transect(lon, lat, azimuth, dem, d_transect)
# # 
# # get_min_altitude_for_azimuth(lon, lat, azimuth, dem, d_transect)
# 
# horizons_raster

# settings <- list(
#   resolution_azimuths = 10, # horizontal resolution of azimuth (in degrees)
# )
# time <- '2023-06-21 10:00:00'
# # time <- '2023-12-21 11:00:00'
# datetime <- as.POSIXct(time,  tz = "UTC")
# 
# sun_position <- getSunlightPosition(
#   date= datetime,
#   lat = lat,
#   lon = lon,
#   keep = c( "azimuth", "altitude")
# )
# azimuth = round(rad2deg(sun_position$azimuth)+180)
# altitude = rad2deg(sun_position$altitude)
# 
# azimuth = round(azimuth / settings$resolution_azimuths) * settings$resolution_azimuths
# 
# file = paste('azimuth-',azimuth,'.tif', sep="")
# dem <- raster(file)
# 
# if (altitude > maxValue(dem)) {
#   shades <- raster(
#     nrows = nrow(dem),
#     ncols = ncol(dem),
#     ext = extent(dem),
#     res = res(dem),
#     crs = crs(dem),
#     vals = 0
#   )
# } else {
#   shades <- is_shade(altitude, dem)
# }
# 
# plot(shades)

source("scripts/get_altitudes_for_azimuth_doP.R")
filename <- paste("~/git/inrae/sunlightR/dem-100m.tif")
Sys.time()
alt_90_100m <- get_altitudes_for_azimuth_doP(filename, 90)
Sys.time()
plot(alt_90_250m)