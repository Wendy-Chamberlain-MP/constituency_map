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

## create map version 1

# create base map
map_v1 <- leaflet() |>
  addTiles() 
  
# add UK Parliament boundary
map_v1 <- map_v1 |> 
  addPolygons(data = uk_boundary,
              color = "#006548", opacity = .8,
               fillOpacity = 0,
               group = "UK Parliament Boundary",
              label = ~name) 

# add Scottish Parliament boundary
map_v1 <- map_v1 |> 
  addPolygons(data = scottish_boundary,
               color = "#500778", opacity = .8, 
              fillOpacity = 0,
               group = "Scottish Parliament Boundary",
              label = ~name) 

# add council wards 
map_v1 <- map_v1 |> 
  addPolygons(data = council_wards,
              color = "#004155",opacity = .8, 
              fillOpacity = 0,
              group = "Council Wards",
              label = ~ward)
  
  
# add layer control
map_v1 <- map_v1 |> 
  addLayersControl(
    overlayGroups = c("UK Parliament Boundary", "Scottish Parliament Boundary", "Council Wards"),
    position = "topright") |> 
  hideGroup(c("Scottish Parliament Boundary", "Council Wards"))
  
 
# save the map as an HTML widget
saveWidget(map_v1, file = "map_v1.html")
