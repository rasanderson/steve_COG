# Process the Postcode and Census data for mini-IID project

library(sf)

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
ne <- st_union(ne) # This isn't right

dh <- st_read(dsn = "two_letter_pcodes/dh/dh.shp")
