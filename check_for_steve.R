# Check you can read and display

library(sf)
library(mapview)

ne_postcodes <- readRDS("ne_postcodes.RDS")
mapview(ne_postcodes)