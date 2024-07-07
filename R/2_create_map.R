### Maping 

# load packages
library(sf)
library(leaflet)
library(htmlwidgets)

## load data

# UK data
uk_boundary <- st_read("./data/nef_data.gpkg", layer =  "uk_boundary")

# Scottish data
scottish_boundary <- st_read("./data/nef_data.gpkg", layer =  "scottish_boundary")

# Council data  
council_wards <- st_read("./data/nef_data.gpkg", layer =  "council_wards")

# CC data
cc_boundary <- st_read("./data/nef_data.gpkg", layer =  "community_councils")

# postcode data
postcode <- st_read("./data/nef_data.gpkg", layer =  "postcodes") 


## create map version 1.1

# define custom attributions
attr <- paste('© <a href="https://openstreetmap.org/copyright/%22">OpenStreetMap </a> under <a href="https://opendatacommons.org/licenses/odbl/">ODbL</a>.',
              'Contains ONS & Fife Council data licenced under <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">OGL3</a>.', 
              'Contains OS data © Crown copyright & database right 2024.',
              sep = " ")
              

# create base map
map <- leaflet() |> 
  addTiles(attribution = attr)
  

# create groups
group <- c("UK Parliament", "Scottish Parliament", 
           "Council Wards", "Community Councils", "Postcodes")


# add UK Parliament boundary
map <- map |> 
  addPolygons(data = uk_boundary,
              color = "#006548", 
              opacity = .8,
              fillOpacity = 0,
              group = group[1]) 

# add Scottish Parliament boundary
map <- map |> 
  addPolygons(data = scottish_boundary,
              color = "#500778", 
              opacity = 0.8, 
              fillOpacity = 0,
              group = group[2])

# add council wards 
map <- map |> 
  addPolygons(data = council_wards,
              color = "#004155",
              opacity = 0.8, 
              fillOpacity = 0,
              group = group[3],
              label = ~ward)

# add community council areas
map <- map |> 
  addPolygons(data = cc_boundary,
              color = "#007bff",
              opacity = 0.8,
              fillOpacity = 0,
              group = group[4],
              label = ~cc_name)

map <- map |> 
  addMarkers(data = postcode,
             clusterOptions = markerClusterOptions(),
             group = group[5],
             label = ~pcd)
  
# add layer control
map <- map |> 
  addLayersControl(
    overlayGroups = group,
    position = "topright") |> 
  hideGroup(group[-1]) |>  
  leaflet.extras::addSearchOSM() |> 
  leaflet.extras::addResetMapButton()
  
# save the map as an HTML widget
saveWidget(map, file = "map.html")
