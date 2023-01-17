library(suncalc)

is_shade <- function(altitude, dem) {
  shades <- c()
  for (i in 1:ncell(dem)) {
    if (altitude < dem[i]) {
      shades <- append(shades, 1)
    } else {
      shades <- append(shades, 0)
    }
  }
  return(raster(
    nrows = nrow(dem),
    ncols = ncol(dem),
    ext = extent(dem),
    res = res(dem),
    crs = crs(dem),
    vals = shades
  ))
}