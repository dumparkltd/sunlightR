library(raster)

source("scripts/get_all_horizons_raster2.R")

settings <- list(
  resolution_dem_target = 100, # target resolution of dem (in m)
  resolution_azimuths = 10, # horizontal resolution of azimuth (in degrees)
)

# load raster
dem = raster("~/projects/INRAE/data/raster1.tif")

# re-sample original raster
dem_at_res <- aggregate(
  dem,
  fact = ceiling(settings$resolution_dem_target / xres(dem))
)

# get altitude raster layers for each azimuth
print(Sys.time())
horizons_raster = get_all_horizons2(dem_at_res, settings)
print(Sys.time())