# Process the Postcode and Census data for mini-COG project
rm(list=ls())

library(sf)
library(tidyverse) # needed to aggregate up
library(smoothr) # For fill holes function
library(mapview) # handy for interactive 

# # Get the postcode data
# ne <- st_read(dsn = "two_letter_pcodes/ne/ne.shp")
# # Need to strip out polygons which begin V as these are a different level in the
# # postcode hierarchy (possibly)
# ne_prefix_letter <- substr(ne$POSTCODE, 1, 1)
# ne <- ne[ne_prefix_letter != "V",]
# ne_pc_parts <- unlist(strsplit(ne$POSTCODE, " "))
# ne_prefix <- ne_pc_parts[seq(from = 1, to = length(ne_pc_parts), by = 2)]
# ne_suffix <- ne_pc_parts[seq(from = 2, to = length(ne_pc_parts), by = 2)]
# ne <- cbind(ne, ne_prefix, ne_suffix)
# ne <- ne[,"ne_prefix"]
# ne <- st_union(ne, by_feature = TRUE)
# ne <- ne %>% 
#   group_by(ne_prefix) %>% 
#   summarise(.groups = "drop") # Note .groups is experimental and suppresses warning
# 
# area_thresh <- units::set_units(250, m^2)
# ne_clean <- fill_holes(ne, threshold = area_thresh)

# Note: some postcodes are non-contiguous
ts <- st_read(dsn = "two_letter_pcodes/ts/ts.shp")
# Need to strip out polygons which begin V as these are a different level in the
# postcode hierarchy (possibly)
pc_prefix_letter <- substr(ts$POSTCODE, 1, 1)
ts <- ts[pc_prefix_letter != "V",]
pc_parts <- unlist(strsplit(ts$POSTCODE, " "))
pc_prefix <- pc_parts[seq(from = 1, to = length(pc_parts), by = 2)]
pc_suffix <- pc_parts[seq(from = 2, to = length(pc_parts), by = 2)]
ts <- cbind(ts, pc_prefix, pc_suffix)
ts <- ts[,"pc_prefix"]
ts <- st_union(ts, by_feature = TRUE)
ts <- ts %>% 
  group_by(pc_prefix) %>% 
  summarise(.groups = "drop") # Note .groups is experimental and suppresses warning

area_thresh <- units::set_units(250, m^2)
ts_clean <- fill_holes(ts, threshold = area_thresh)
saveRDS(ts_clean, "ts_postcodes.RDS")

dl <- st_read(dsn = "two_letter_pcodes/dl/dl.shp")
# Need to strip out polygons which begin V as these are a different level in the
# postcode hierarchy (possibly)
pc_prefix_letter <- substr(dl$POSTCODE, 1, 1)
dl <- dl[pc_prefix_letter != "V",]
pc_parts <- unlist(strsplit(dl$POSTCODE, " "))
pc_prefix <- pc_parts[seq(from = 1, to = length(pc_parts), by = 2)]
pc_suffix <- pc_parts[seq(from = 2, to = length(pc_parts), by = 2)]
dl <- cbind(dl, pc_prefix, pc_suffix)
dl <- dl[,"pc_prefix"]
dl <- st_union(dl, by_feature = TRUE)
dl <- dl %>% 
  group_by(pc_prefix) %>% 
  summarise(.groups = "drop") # Note .groups is experimental and suppresses warning

area_thresh <- units::set_units(250, m^2)
dl_clean <- fill_holes(dl, threshold = area_thresh)
saveRDS(dl_clean, "dl_postcodes.RDS")

tsdl <- rbind(dl_clean, ts_clean)
saveRDS(tsdl, "tsdl_postcodes.RDS")
st_write(tsdl, "shp/tsdl.shp")
