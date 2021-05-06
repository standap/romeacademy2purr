#########################################################
##
## This set of scripts serves to create the table for the portrait database
## that will be archived in PURR 
##
## The data nelibrary(exifr)ed to be normalised and enriched. The data will be derived 
## from the main table 
##
#########################################################

library(tidyverse)
library(janitor)
library(lubridate)
library(tidytext)
library(exifr)


# final draft of the pensionnaires potrait database -----------------------

portraits <-  read_csv("data/rome_academy_pensionnaires_portraits_or.csv") %>% 
    left_join(original_data, by = "record_id")

# mmaking sure that all images have extension *.jpg
portraits %>% 
    separate(filename, c("base", "extension"), sep = "\\.") %>% 
    mutate(filename = paste0(base,".jpg")) %>% 
    select(record_id:wikidata_id, filename, creator:size) #%>% 
#    write_csv("data/rome_academy_pensionnaires_portraits_draft_20210503.csv")


# I compared the filesizes in the omeka database with those created by exif
# they were the same so I went with the omeka filesizes
sizes %>% 
    anti_join(portraits, by = "filename")

portraits %>% 
    separate(filename, c("base", "extension"), sep = "\\.") %>% 
    mutate(filename = paste0(base,".jpg")) %>% 
    select(filename, extension) %>% 
    filter(extension != "jpg")

portraits %>% 
    filter(file_size != size)

# I missed the original filenames in the datatafile and had to add them back.
original_data <- title %>% 
    select(record_id, original_filename, size)


# creating the draft of the portraits datafile ----------------------------


# this file created by joining omeka tables (transform_omeka_records.R)
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


## "DATABASE" data - portraits
pensionnaires %>% 
    #    select(1, title, 2:4, 17:4 3, bibliography) %>% 
    #    write_csv("data/academy_pensionnaires_draft01.csv")
    #    select(1, 44:49) # the locations table can be stored as it is
    #    select(1, title, 2:5, 17:26, 50, 52, 57:52)  
    select(1, title, 4:5, 57, 58, 7:15, type, 6, 52) %>% 
    filter(!is.na(filename)) %>% 
    count(rights)
#write_csv("data/rome_academy_pensionnaires_portraits.csv")


names <- read_csv("data/rome_academy_pensionnaires_draft_final_20210429.csv") %>% 
    select(1:3, birth_year, death_year)

title <- pensionnaires %>% 
    select(1, title, 4:5, 57, 58, 7:15, type, 6, 52) %>% 
    filter(!is.na(filename)) %>% 
    inner_join(names)

title %>% 
    mutate(portraited_person = paste0(name, " (", birth_year, "-", death_year, ")")) %>% 
    select(record_id, portraited_person, wikidata_id, filename, creator, date, description:type) %>%
    write_csv("data/rome_academy_pensionnaires_portraits_draft.csv")
    
# technical metadata for the images ---------------------------------------

image_files <- list.files(path = "images", full.names = TRUE, pattern = "*.[jJ]*")
sizes <- read_exif(image_files, tags = c("filename", "imagesize", "FileSize")) %>% clean_names() %>% 
    rename(filename = "file_name")
