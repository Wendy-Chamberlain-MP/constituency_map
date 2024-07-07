### Obtain data 

# load packages
library(sf)
library(dplyr)
library(osdatahub)
library(sgapi)

## Import Westminster data

# import NEF Westminster Constituency boundary 
uk_boundary <- get_boundaries_areaname("Westminster_Parliamentary_Constituencies_July_2024_Boundaries_UK_BFE",
                        col_name_var = "PCON24NM",
                        chosen_constituency_list = c("North East Fife")) 

# clean Westminster data
uk_boundary <- uk_boundary |> 
  janitor::clean_names() |> 
  select(long:geometry) |> 
  mutate(name ="UK Parliament", .before = 1)

# save data to file
st_write(uk_boundary, "./data/nef_data.gpkg", layer = "uk_boundary")


## Import Scottish Parliament data
scottish_boundary <- get_boundaries_areaname("Scottish_Parliamentary_Constituencies_December_2022_Boundaries_SC_BFE",
                        col_name_var = "SPC22NM",
                        chosen_constituency_list = c("North East Fife"))


# clean Scottish Parliament data
scottish_boundary <- scottish_boundary |> 
  janitor::clean_names() |> 
  select(long:geometry) |> 
  mutate(name ="Scottish Parliament", .before = 1) 

# save data to file
st_write(scottish_boundary, "./data/nef_data.gpkg", 
         layer = "scottish_boundary", 
         append = TRUE)


## Import Council Ward data
council_wards <- get_boundaries_areaname("Wards_December_2023_Boundaries_UK_BFE",
                              col_name_var = "WD23CD",
                              chosen_constituency_list = 	c("S13002960", 
                                                            "S13002961",
                                                            "S13002962",
                                                            "S13002963",
                                                            "S13002964",
                                                            "S13002965"))
# clean council data                                                           
council_wards <- council_wards |> 
  janitor::clean_names() |> 
  select(wd23nm,long:geometry) |> 
  rename(ward = wd23nm)
                                
# save data to file
st_write(council_wards, "./data/nef_data.gpkg", 
         layer = "council_wards", 
         append = TRUE)


## Import community council boundaries 
temp <- tempfile()
temp2 <- tempdir()

url <- "https://data.spatialhub.scot/dataset/f2a5d12a-07eb-4cb8-859a-63dbcb29e6cb/resource/4f8d1c3b-d552-4dfa-afbc-917debc6dde1/download/fife_community_councils.zip"

download.file(url, temp)
temp2 <- unzip(temp)

cc_boundary <- st_read(temp2[6]) 

# filter cc data by uk data  
cc_boundary <- cc_boundary |>
  st_transform(crs = 4326) |> 
  st_intersection(uk_boundary) |> 
  janitor::clean_names()
  
# save data to file
st_write(cc_boundary, "./data/nef_data.gpkg", 
         layer = "community_councils", 
         append = TRUE)


## import postcode data 

post_dd <- st_read("./data/raw/ONSPD_MAY_2024_UK_DD.csv", options=c("X_POSSIBLE_NAMES=long","Y_POSSIBLE_NAMES=lat"), crs = 4326)
 
post_ky <- st_read("./data/raw/ONSPD_MAY_2024_UK_KY.csv", options=c("X_POSSIBLE_NAMES=long","Y_POSSIBLE_NAMES=lat"), crs = 4326)

# bind data & filter by uk data  
post_nef <- rbind(post_ky, post_dd) |> 
  st_intersection(uk_boundary) |> 
  select(pcd, lat, long)

# save data to file
st_write(post_nef, "./data/nef_data.gpkg", 
         layer = "postcodes", 
         append = TRUE)
