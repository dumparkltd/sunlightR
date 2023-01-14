library(sf)
library(rlang)

# check if a lat/lon point is contained within a polygon

contains_polygon_location <- function(lon, lat, area) {
  # project
  pt = st_sfc(st_point(c(lon, lat)))
  st_crs(pt) <- 4326
  contains = as.logical(st_contains(area, pt)[1])
  if (is.na(contains)) return (FALSE)
  return (contains)
}