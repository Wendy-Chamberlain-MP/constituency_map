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

cc_boundary <- st_read("./data/nef_data.gpkg", layer =  "community_councils")


## create map version 1.1

# create base map
map <- leaflet() |>
  addProviderTiles(providers$CartoDB.Voyager)  |> 
  addTiles(attribution = c('Boundary data from <a href="https://geoportal.statistics.gov.uk/search?q=BDY_ELE&sort=Date%20Created%7Ccreated%7Cdesc">ONS </a> & <a href="https://data.spatialhub.scot/dataset/community_council_boundaries-fi">Fife Council </a> under  <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v3.0 </a>')) |> 
  addProviderTiles(providers$CartoDB.Voyager)  
  

# create groups
group <- c("UK Parliament Boundary", "Scottish Parliament Boundary", 
           "Council Wards", "Community Councils")


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
  
  
# add layer control
map <- map |> 
  addLayersControl(
    overlayGroups = group,
    position = "topright") |> 
  hideGroup(group[-1]) |>  
  leaflet.extras::addSearchOSM() 
  

 
# save the map as an HTML widget
saveWidget(map, file = "map.html")
