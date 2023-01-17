source("scripts/get_horizon.R")

get_all_horizons <- function (dem, settings) {
  # prepare empty result objec, type RasterBrick
  horizons <- brick()
  for (i in 1:360) {
    horizons <- addLayer(
      horizons,
      raster(
        nrows = nrow(dem),
        ncols = ncol(dem),
        ext = extent(dem),
        res = res(dem),
        crs = crs(dem),
        vals = 0
      )
    )
  }
  
  for (x in 1:ncol(dem)) {
    for (y in 1:nrow(dem)) {
      if (!is.na(dem[x,y])) {
        spt <- spTransform(
          xyFromCell(dem,c(x*y),spatial=TRUE),
          CRS("+proj=longlat")
        )
        horizon = get_horizon(
          lon = as.data.frame(spt)$x,
          lat = as.data.frame(spt)$y,
          dem,
          settings
        )
        for (i in 1:nrow(horizon)) {
          values <- horizon[i,]
          if (values$altitudes != 0) {
            horizons[[values$azimuths]][x,y] <- values$altitudes
          }
        }
      }
    }
  }
  return(horizons)
}
