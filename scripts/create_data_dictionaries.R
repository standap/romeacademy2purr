library(tidyverse)
# CREATED FILE FOR DATA DICTIONARY -----------------------------------------
# in the end I used different script that also inluded column types
# this one was originally for Beatrice and Catherine
# the main dictionary was created manually in csv file and then converted to 
# markdown

pensionnaires_draft <- read_csv("data/rome_academy_pensionnaires_draft01.csv")
skimr::skim(pensionnaires_draft) 

data_dict <- skimr::skim(pensionnaires_draft)

data_dict %>% 
    select(skim_variable) %>% 
    rename(column_name_fr = 1) %>% 
    add_column(column_name_en = "", description_fr = "", description_en = "") %>% 
    write_csv("rome_academy_data_dictionary.csv")

library(tidyverse)
# CREATED FILE FOR DATA DICTIONARY -----------------------------------------
# in the end I used different script that also inluded column types
# this one was originally for Beatrice and Catherine
# the main dictionary was created manually in csv file and then converted to 
# markdown

pensionnaires_draft <- read_csv("data/rome_academy_pensionnaires_draft01.csv")
skimr::skim(pensionnaires_draft) 

data_dict <- skimr::skim(pensionnaires_draft)

data_dict %>% 
    select(skim_variable) %>% 
    rename(column_name_fr = 1) %>% 
    add_column(column_name_en = "", description_fr = "", description_en = "") %>% 
    write_csv("rome_academy_data_dictionary.csv")


data_dic <- read_csv("rome_academy_data_dictionary.csv")



# Dictionary for data/rome_academy_places_gis.csv---------------------------

places <- read_csv("data/rome_academy_places_gis.csv")

places_dict <- places %>%
    summarise_all(class) %>%
    gather(variable, class) %>%
    add_column(
        description = c(
            "Record ID of the artist.",
            "Name of the artist as it appears in the wikidata database and in the archived dataset.",
            "Type of normalised place, either place of birth or place of death.",
            "Place name as it appears in the original _Residents_ databse.",
            "Normalised form of the French place name, reconciled in the wikidata database against the type 'commune of France' (Q484170).",
            "Identifier of the place in wikidata (q number).",
            "Name of country in which the place is located, extracted from the wikidata item record.",
            "Latitude of the place extracted from the wikidata record.",
            "Longitude of the place extracted from the wikidata record."
        )
    ) 

places_dict %>% 
    write_delim("artlas_archive_places_gis_dictionary.md", delim = "|")



# data dictionary for portraits dataset---------------------------------------

portraits <-
    read_csv("data/rome_academy_pensionnaires_portraits.csv") %>%
    select(-name_norm)
    

portraits_dict <- portraits %>%
    rename(artist = portraited_person,
           measurements = format,
           archive = publisher,
           file_number = source,
           type = subject,
           filesize = size) %>% 
    summarise_all(class) %>%
    gather(variable, class) %>%
    add_column(
        description = c(
            "Record ID of the portrayed artist in the Residents of the French Academy in Rome database.",
            "Name of the  portrayed artists as it appears in the wikidata database (q number).",
            "Identifier of the portrayed artist in wikidata.",
            "Image of the portrait.",
            "Name of the portraitist.",
            "Identifier of the portraitist in wikidata (q number).",
            "Year when the portrait was created.",
            "Physical description of the portrait.",
            "Measurements of the original portrait.",
            "Name of the archive.",
            "Rights associated with the portrait.",
            "File number.",
            "Type of portrait.",
            "Original filename.",
            "Size of the file."
        )
    )

portraits_dict %>%
    write_delim("dictionaries/artlas_archive_portraits_dictionary.csv", delim = "|")

# Dictionary for data/rome_academy_places_gis.csv---------------------------

places <- read_csv("data/rome_academy_places_gis.csv")

places_dict <- places %>%
    summarise_all(class) %>%
    gather(variable, class) %>%
    add_column(
        description = c(
            "Record ID of the artist.",
            "Name of the artist as it appears in the wikidata database and in the archived dataset.",
            "Type of normalised place, either place of birth or place of death.",
            "Place name as it appears in the original _Residents_ databse.",
            "Normalised form of the French place name, reconciled in the wikidata database against the type 'commune of France' (Q484170).",
            "Identifier of the place in wikidata (q number).",
            "Name of country in which the place is located, extracted from the wikidata item record.",
            "Latitude of the place extracted from the wikidata record.",
            "Longitude of the place extracted from the wikidata record."
        )
    ) 

places_dict %>% 
 write_delim("artlas_archive_places_gis_dictionary.md", delim = "|")



# data dictionary for portraits dataset---------------------------------------

portraits <-
    read_csv("data/rome_academy_pensionnaires_portraits.csv")

portraits_dict <- portraits %>%
    summarise_all(class) %>%
    gather(variable, class) %>%
    add_column(
        description = c(
            "Record ID of the artist in the Residents of the French Academy in Rome database.",
            "Name of the  portraited artists as it appear in the wikidata database.",
            "Identifier of the portraited artist in wikidata.",
            "Image of the portrait.",
            "Name of the portraitist.",
            "Identifier of the portraitist in wikidata.",
            "Year when the portrait was created.",
            "Physical description of the portrait.",
            "Measurements of the original portrait.",
            "Name of the archive",
            "Rights associated with the portrait.",
            "File number",
            "Type of portrait",
            "Original filename .",
            "size of the file."
        )
    )

portraits_dict %>%
    write_delim("artlas_archive_portraits_dictionary.csv", delim = "|")