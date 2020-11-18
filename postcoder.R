# Process the Postcode and Census data for mini-IID project
rm(list=ls())

library(sf)
library(tidyverse) # needed to aggregate up
library(smoothr) # For fill holes function
library(mapview) # handy for interactive 

# Get the postcode data
ne <- st_read(dsn = "two_letter_pcodes/ne/ne.shp")
# Need to strip out polygons which begin V as these are a different level in the
# postcode hierarchy (possibly)
ne_prefix_letter <- substr(ne$POSTCODE, 1, 1)
ne <- ne[ne_prefix_letter != "V",]
ne_pc_parts <- unlist(strsplit(ne$POSTCODE, " "))
ne_prefix <- ne_pc_parts[seq(from = 1, to = length(ne_pc_parts), by = 2)]
ne_suffix <- ne_pc_parts[seq(from = 2, to = length(ne_pc_parts), by = 2)]
ne <- cbind(ne, ne_prefix, ne_suffix)
ne <- ne[,"ne_prefix"]
ne <- st_union(ne, by_feature = TRUE)
ne <- ne %>% 
  group_by(ne_prefix) %>% 
  summarise(.groups = "drop") # Note .groups is experimental and suppresses warning

area_thresh <- units::set_units(250, m^2)
ne_clean <- fill_holes(ne, threshold = area_thresh)

# Note: some postcodes are non-contiguous
