library(sp)
library(raster)

# check if a lat/lon point is contained within a raster layer

contains_raster_location <- function(lon, lat, r) {
  # project
  ll = data.frame(x=lon, y=lat)
  coordinates(ll) <- c("x", "y")
  proj4string(ll) <- CRS("+proj=longlat")
  spt <- spTransform(ll, CRS(projection(r)))
  # check bounds
  if (
    xmin(extent(spt)) <= xmax(extent(r)) &&
    xmin(extent(spt)) >= xmin(extent(r)) &&
    ymin(extent(spt)) <= ymax(extent(r)) &&
    ymin(extent(spt)) >= ymin(extent(r))
  ) {
    return (TRUE)
  } 
  return (FALSE)
}