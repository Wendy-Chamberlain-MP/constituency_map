### Set-up script

dir.create("./R")
dir.create("./data")

# install packages
install.packages(c("tidyverse", "janitor","renv",
                   "sf", "leaflet", "mapview",
                   "sgapi", "htmlwidgets"
))

# snapshot packages
renv::snapshot(confirm = FALSE)
