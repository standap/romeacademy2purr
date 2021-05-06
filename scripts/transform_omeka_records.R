#############################################################################
##
## this is a script to convert data from artlas omeka database
## to a csv tables that could be further processed, analysed, and archived
## in PURR - artlas_pensionnaires_rome_academy.csv
##
## the process is relatively straightforward
## unfortunately record_id == 1286 has two values in the field
## `Date du Prix de Rome` and that caused some issues with transformation
## but after I combined the values I was able to transpose the table easily
## 
## record_id == 1 - contains collection level metadata and was removed
##
#############################################################################


# this is the mysq script that was used to collect the main data from Omeka
# selected only record_id, name of the field and th correspondign value 
#```
# select oet.record_id, oet.element_id, oe.id, oe.element_set_id, oe.name,
# oe.description, #oet.text, oe.comment from omeka_element_texts oet
# inner join omeka_elements oe on (oe.id = oet.element_id)
#
#```

library(tidyverse)
library(janitor)
library(lubridate)
library(tidytext)


# file preparation - pre-processing ---------------------------------------
# this is the original output of the OMEKA mysql script artlas_create_table.sql
rome_academy_records <- read_csv("data_source/artlas_rome_academy20210210.csv")

rome_academy_records %>% 
#    filter(record_id == 1286, name == "Date du Prix de Rome")
    select(record_id, name, text)

# simplified the double entry for record record_id == 1286
# to get even number of fields for each record
# and removig the collection-level records record_id < 6
rome_academy_records_corrected <- rome_academy_records %>% 
    mutate(text = if_else(record_id == 1286 & name == "Date du Prix de Rome",
                          true = "sans prix|sans réponse",
                          false = text)) %>% 
    distinct() %>% 
    filter(record_id != 1)
# verify corections
rome_academy_records_corrected %>% 
    filter(record_id == 1286 & name == "Date du Prix de Rome")

# load locations
rome_academy_locations <- read_csv("data_source/artlas_omeka_locations_20210210.csv")

#again found a double entry so I removed it 
rome_academy_locations %>% 
    count(item_id, sort = TRUE)
# corrected location file
rome_academy_locations_corrected <- rome_academy_locations %>% 
    filter(!(item_id == 1283 & address == "Cherbourg"))

# load names of images    
rome_academy_files <- read_csv("data_source/artlas_omeka_files_20210211.csv")
    
rome_academy_files %>% 
    count(item_id, sort = TRUE)


rome_academy_table <- rome_academy_records_corrected %>% 
    #    count(name)
    #    count(record_id, sort = TRUE)
    #    filter(record_id > 1280) %>% 
    #    group_by(record_id) %>% 
    pivot_wider(names_from = name,
                values_from = text) %>% 
    janitor::clean_names()

skimr::skim(rome_academy_table)

## NOT USED AN ATTEMPT when I tried to use unnest the lists 
# but this path was not necessary once I fixed the the record 1286 issue
roma_academy_tbl <- academy_list %>% 
    unnest(cols = c(birth_date, birthplace, death_date, bibliography, contributor, 
                    coverage, creator, date, description, format, language,
                    publisher, rights, source, subject, title, type, deathplace,
                    last_name, first_name, genre, pere, mere, famille, discipline,
                    lieu_detudes, maitre, sujet_du_prix, date_du_prix_de_rome,
                    date_darrivee_a_rome, sejour_a_rome, envoi, 
                    date_de_depart_de_rome, carriere, enseignement, distinctions,
                    notes, siecle, gouvernement_de_lepoque, autorites_de_tutelle,
                    secretaire_de_l_academie_des_beaux_arts, 
                    directeur_de_l_academie_de_france_a_rome, 
                    salons_expositions, oeuvres_representatives))

rome_academy <- rome_academy_table %>% 
    left_join(rome_academy_locations_corrected, by = c("record_id" = "item_id")) %>% 
    left_join(rome_academy_files, by = c("record_id" = "item_id"))

## the final table is created
# rome_academy %>% 
#      write_csv("data/artlas_pensionnaires_rome_academy.csv", na = "")

#    write_csv("data/artlas_pensionnaires_names.csv")
#    select(1:4)    # record number and birth data  
#    select(5:16)  # columns 5 through 16 are a subset related to images + bibliography
#    select(21:23) # family information
#    select(24:26) # artictic education 
#    select(27:32) # stay at the academy
#    select(33:36) # career
#    select(37:43) # artictic and historical context
#    select(44:49) # locations  (id.x - possibly entity_id)
#    select(50:62) # images - technical metadata and links 


read_csv("data_source/artlas_rome_academy20210210.csv") %>% 
    filter(record_id == 14)


