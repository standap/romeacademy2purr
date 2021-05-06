# QA of reconciled data  
# at this point, all artists should have a wikidata q, so this  is just a verification it is so
# plus I I retrieved the artists that have the prix de rome
# listed as part of their record to see if we have a complete set
# or somebody is missing
# I was adding files as I was creating records

library(tidyverse)
library(janitor)
library(lubridate)

records_af <- read_csv("openrefine_files/20210419/artlas_pensionnaires_names-a_through_f_20210419.csv") %>% 
    clean_names() %>% 
    filter(!record_id %in% c(532, 534, 535, 536, 538, 548, 553, 554, 555, 556, 563, 566)) %>% 
    select(1, names_norm:date_of_death, birth_date:genre, -birth_year) %>% 
#    filter(record_id < 532) %>% 
    rename(name_norm = "names_norm")

records_gl <- read_csv("openrefine_files/20210419/artlas_pensionnaires_names_g-through-l_20210419.csv") %>%
    clean_names() %>% 
    filter(record_id !=688) %>% 
    select(1, 3:15, -verification_notes)

records_mz <- read_csv("openrefine_files/20210419/artlas_pensionnaires_names_m-through-z_20210419.csv") %>% 
    clean_names() %>% 
    select(1, 3:15, -wiki_verification_notes)

records_no_match <- read_csv(file = "openrefine_files/20210419/rome_academy_records_no-match_20210419.csv") %>% 
    clean_names() %>% 
    select(-matched, -wiki_verification_notes) %>% 
    filter(!is.na(wikidata_id))

colnames(records_no_match)

new_wiki_ids <- read_csv("openrefine_files/20210419/artlas_create_wiki_id_20210419.csv") %>% 
    clean_names() %>% 
    select(1, 3:7, birth_date:genre) %>% 
    filter(record_id != c(878, 879), !is.na(wikidata_id))

new_wiki_ids_20210420 <- read_csv("openrefine_files/20210419/artlas_create_wiki_id_20210420.csv") %>% 
    clean_names() %>% 
    select(1, 5:9, birth_date:genre, -birth_range, -death_range) 

new_wiki_ids_20210422 <- read_csv("openrefine_files/20210419/artlas_create_wiki_id_20210422.csv") %>% 
    clean_names() %>% 
    select(1, 3:9, birth_date:genre,  -last_name_norm) %>% 
    mutate(birth_date = as.character(birth_date),
           death_date = as.character(death_date))

records_no_match %>% 
    filter(is.na(name_norm))

records_matched <- bind_rows(records_af, records_gl, records_mz) %>% 
# records_no_match, new_wiki_ids) %>% 
    filter(!is.na(wikidata_id)) %>% 
    distinct()

records_matched %>% tail()
#    get_dupes() %>% slice(11:30)
    distinct()


new_wiki_ids %>% 
    filter(is.na(name_norm))


records_no_match %>% 
    filter(record_id == "879")

new_wiki_ids %>% 
    filter(record_id == "879")


records <- bind_rows(records_matched, records_no_match, 
                     new_wiki_ids, new_wiki_ids_20210420,
                     new_wiki_ids_20210422)

records %>% 
    # filter(record_id %in% c(532, 534, 535, 536, 538, 548, 553, 554, 555, 556, 563, 566, 688)) %>% arrange(record_id) %>% 
    # distinct() %>% tail()
    # 
    count(record_id, sort = TRUE) %>% filter(n > 1)
#     filter(is.na(name_norm))
     filter(str_detect(name_norm, "annl"))
#     count(name_norm, sort = TRUE)

draft1 <- read_csv("data/rome_academy_pensionnaires_draft01.csv",
                   na = c("SR", "sr", ""))

#######
###
### FINAL LIST OF RECONCILED VALUES
###
#######
records %>% 
    select(1:6) %>% 
#    add_column(source = "artlas") %>% 
    write_csv("data/artlas_pensionnaires_names_reconciled_values.csv",
              na = "")

###########
###
### THESE ROWS WERE NOT RECONCILED
###
###########

draft1 %>% 
    anti_join(records, by = "record_id") %>%
    select(1:8, discipline) %>% 
    write_csv("data/artlas_pensionnaires_names_NO_reconciled_values.csv",
              na = "")
    #    write_csv("openrefine_files/last_batch_wiki_ids.csv")

records %>% 
    anti_join(draft1, by = "record_id")
#####################
###
### PRIX DE ROME AWARDEES NOT IN THE DATABASE BUT IN WIKIDATA 
###
### code below
###
#####################

wiki_id_file <- wiki_ids %>% 
    anti_join(records, by = "wikidata_id") %>% 
    add_column(record_id = NA) %>% 
    select(record_id, itemLabel, wikidata_id)

wiki_id_file %>% 
    write_csv("data/prix_de_roma_wikidata.csv")


###############################
###
### COMBINED RECORDS of wiki awardees and artlas database
###
###############################
records %>% 
    select(1:3) %>% 
    rename(itemLabel = "name_norm") %>% 
    bind_rows(wiki_id_file) %>% 
    write_csv("data/prix_de_rome_property_all.csv")



### Check this and also script and wiki_ids on line 91
draft1 %>% 
    anti_join(records, by = "record_id") %>%
#    write_csv("openrefine_files/last_batch_wiki_ids.csv")
        select(1:8, discipline) %>% View()
    tail()
#    slice(41:60)
    

records %>% 
    filter(record_id == 763)

##############################
##
## WKIDATA QUERY
##
##############################

library(WikidataQueryServiceR)
library(WikidataR)

awardees <- query_wikidata('select distinct ?item ?itemLabel ?itemDescription ?sitelinks where {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
    wdt:P166 wd:Q576434;  #  Who were awarded Prix de Rome.
    wikibase:sitelinks ?sitelinks.
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}')

wiki_ids <- awardees %>% 
    mutate(wikidata_id = str_remove(item, "http://www.wikidata.org/entity/"))

wiki_ids %>% 
    anti_join(records, by = "wikidata_id") %>% 
#    filter(str_detect(itemLabel, "tt"))
     mutate(last_name = str_extract(itemLabel, " [A-Z].+$")) %>% 
     separate(last_name, into = c("extra", "last_name_02"),
              sep = "(?<=\\w) ", fill = "left", extra = "merge") %>% 
#     select(last_name_02) %>% 
    mutate(last_name_02 = str_trim(last_name_02,"left")) %>% 
    arrange(last_name_02) %>% 
    View()

wiki_last_names <- wiki_ids %>% 
    anti_join(records_clean, by = "wikidata_id") %>% 
    mutate(last_name = str_extract(itemLabel, " [A-Z].+$")) %>%
    separate(last_name, into = c("extra", "last_name"),
             sep = "(?<=\\w) ", fill = "left", extra = "merge") %>%
#    select(last_name) %>%
    mutate(last_name = str_trim(last_name,"left")) %>% 
#    select(last_name) %>% 
    mutate(last_name = str_to_title(last_name)) %>%
    semi_join(wiki_last_names, by = "last_name")
    
    
draft1 %>% 
    anti_join(records_clean, by = "record_id") %>% 
    select(title) %>% View()

draft1 %>% 
    count(record_id, sort = TRUE)

records %>% 
    filter(str_detect(name_norm, "Lef"))


# First pass / first attempt after the initial reconciliation ----------------

# these code block deal with output from the openrefine after reconciliation
# particularly important was the field for verifying records, mainly dates of birth or death
# this script produced the files that were needed for further work with rows that were not reconciled yet... that means authors that needed further inspectiosn or records in data wiki needed to be created  
# in the end, I could have done most of this work in openrefine - I know that now 

records_af <- read_csv("openrefine_files/artlas_pensionnaires_names-a_f.csv") %>% 
    rename(name_norm = "names_norm") %>% 
    filter(str_detect(artist, "^[A-F]"),
           !record_id %in% c(1283, 1288, 1290)) %>% 
    select(1, name_norm, 4:5, 7, 12, 14:19)

records_gl <- read_csv("openrefine_files/artlas_pensionnaires_names_g-through-l-csv.csv") %>% 
    select(1, 3:12) %>%
    rename(wiki_verification_notes = "verification_notes")

records_mz <- read_csv("openrefine_files/artlas_pensionnaires_names_m-through-z-csv.csv") %>% 
    select(1, 3:12)

records <- bind_rows(records_af, records_gl, records_mz)


draft1 <- read_csv("data/rome_academy_pensionnaires_draft01.csv",
                   na = c("SR", "sr", ""))

records %>% 
    filter(is.na(wiki_verification_notes), !is.na(wiki_id)) %>%
    mutate(wiki_link = paste0("https://www.wikidata.org/wiki/", wiki_id)) %>% 
    select(1:3, 12, 5:11)# %>% 
#    write_csv("openrefine_files/rome_academy_records_matched.csv")

records %>% 
    filter(!is.na(wiki_verification_notes)) %>% 
    separate(wiki_verification_notes, into = c("wiki_url", "comment"), sep = " ",
             extra = "merge") #%>% 
#    write_csv("openrefine_files/rome_academy_records_review.csv")

records %>% 
    mutate(matched = case_when(is.na(wiki_verification_notes) & !is.na(wiki_id) ~ "matched",
                               !is.na(wiki_verification_notes) ~ "review")) %>% 
    #    filter(is.na(matched)) %>% 
    #    select(1:4) %>% View()
    #    count(matched)
    filter(is.na(matched)) #%>% 
#    write_csv("openrefine_files/rome_academy_records_no-match.csv")


records %>%
    count(record_id, sort = TRUE)
count(wiki_id, sort = TRUE)
filter(record_id %in% c(1283, 1288, 1290 ))
count(record_id, sort = TRUE)
#    distinct(record_id)
anti_join(draft1, by = "record_id")

