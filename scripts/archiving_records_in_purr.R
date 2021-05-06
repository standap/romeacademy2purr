#########################################################
##
## This set of scripts serves to create
##  * 1/ the table that will be archived in PURR
##  * 2/ data_dictionary - moved to a seperate file create_data_dictionaries.R
##  * 3/ GIS visialisation/verification 
##
## The data are normalised and enriched in normalisation_remediation.R
## 
##
#########################################################

library(tidyverse)
library(janitor)
library(lubridate)
library(tidytext)
library(leaflet)


# FINAL FILE

data <- read_csv("data/rome_academy_pensionnaires_draft_final_20210429.csv") %>% 
    rename(supervision = oversight,
           appointments = assignment)

data %>% 
    write_csv("data/rome_academy_pensionnaires_data.csv", na = "")

# this file was created by joining omeka tables (transform_omeka_records.R)
pensionnaires <- read_csv("data/artlas_pensionnaires_rome_academy.csv",
                          na = c("SR", "sr", ""))
skimr::skim(pensionnaires) 

    
#    select(1:4)    # record number and birth data  
#    select(5:16)  # columns 5 through 16 are a subset related to images + bibliography
#    select(21:23) # family information
#    select(24:26) # artictic education 
#    select(27:32) # stay at the academy
#    select(33:36) # career
#    select(37:43) # artictic and historical context
#    select(44:49) # locations  (id.x - possibly entity_id)
#    select(50:62) # images - technical metadata and links 


pensionnaires %>% 
    filter(str_detect(title, "ALIZARD")) %>% 
    select(contains("rome"))

# I tested what forms take the names of months
pensionnaires %>% 
    unnest_tokens(word, birth_date)  %>% 
    filter(str_detect(word, "\\d+", negate = TRUE)) %>% 
    count(word, sort = TRUE) %>% View()

#    write_csv("data/artlas_pensionnaires_names.csv")

pensionnaires %>% 
    select(1, title, 2:5, 50, 52, 57:58)  
# filter(!is.na(id.y)) %>%
# select(metadata) %>% write_tsv("exif_matadata.txt")

pensionnaires %>%
    select(1, title, 2:4, discipline, maitre) %>% 
    mutate(title = str_to_lower(title)) %>% 
    filter(str_detect(title, "chardin", )) 

pensionnaires %>% 
    select(record_id, ends_with("name"), contains("rome")) %>% 
    mutate(rome_departure = str_extract(date_de_depart_de_rome, "\\d{4}"),
           rome_arrival = str_extract(date_darrivee_a_rome, "\\d{4}"),
           rome_arrival = year(make_date(rome_arrival))) %>% 
    filter(rome_arrival > 1647, rome_arrival < 6666) %>% 
    #    arrange(-rome_arrival)
    ggplot(aes(rome_arrival)) +
    geom_bar()

# GIS points verification -------------------------------------------------


colnames(pensionnaires)
birth_places <- pensionnaires %>% 
    #    filter(!is.na(birthplace) | !is.na(longitude)) %>% 
    select(1, ends_with("place"), latitude, longitude, address)

birth_places %>% 
    pivot_longer(cols = ends_with("place"),
                 names_to = "places_types",
                 values_to = "places") %>% 
    write_csv("openrefine_files/places_gis_normalisation.csv")

    leaflet(birth_places) %>% 
    addTiles() %>% 
    addMarkers(lng = ~longitude, lat = ~latitude, label = ~address)

places <- read_csv("data/rome_academy_places_gis_reconciled.csv") %>% 
    clean_names()

data <- read_csv("data/rome_academy_pensionnaires_data.csv")
names <- data %>% 
    select(1:2)

gis <- places %>% 
#    filter(!is.na(coordinate_location)) %>% 
    select(record_id, places_types:coordinate_location) %>% 
    separate(coordinate_location, c("latitude", "longitude"), sep = ",") %>% 
    rename(place = "places",
           place_type = "places_types") %>% 
    mutate(longitude = as.numeric(longitude),
           latitude = as.numeric(latitude)) %>% 
    inner_join(names, by = "record_id") %>% 
    select(record_id, name, place_type:longitude)
View(gis)


gis %>% 
    write_csv("data/rome_academy_places_gis.csv", na = "")

pal <- colorFactor(c("navy", "red"), domain = c("birthplace", "deathplace"))

leaflet(gis) %>% 
    addTiles() %>% 
    addCircleMarkers(lng = ~longitude, lat = ~latitude, label = ~name, color= ~pal(place_type),
                     stroke = FALSE, fillOpacity = 0.5,
                     radius = 4) %>% 
    addLegend("topleft", pal = pal,
              values = ~place_type,
              title = "Places of birth and death for the Prix de Rome awardees")

               