### Obtain data 

# load packages
library(sf)
library(tidyverse)
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

                       