## this scrip contain code for various remadiation and enrichment procedures
## to the original data
## all html tags were removed
##
## CREATING THE FINAL FINAL


# standa@spejsa-precision:~/Desktop/artlas/rome_academy$ grep -Eo '^ ?([A-Z]+) ?([A-Z]+)?\.' gri-ark--13960-t47q2rw95-1617122627.txt | sort | uniq -c | sort -nr

library(tidyverse)
library(janitor)
library(lubridate)

# 1/ normalise generic columns

# remove html tags --------------------------------------------------------

draft1 <- read_csv("data/rome_academy_pensionnaires_draft01.csv",
                   na = c("SR", "sr", ""))


draft_no_html <- draft1 %>% 
    mutate(across(where(is.character), ~ str_remove_all(., "</?p>|</?div>|</?strong>|\n|</?span>")),
           across(where(is.character), ~ str_replace_all(., "(<br />){1,}", " | ")),
           across(where(is.character), ~ str_replace_all(., "</?em>", "")),
           across(where(is.character), ~ str_replace_all(., "<su[pb]>", " (Note ")),
           across(where(is.character), ~ str_replace_all(., "</su[pb]>", "\\)")),
           across(where(is.character), ~ str_replace_all(., "\\(Note\\s+\\)", "")),
           across(where(is.character), ~ str_trim(.)),
           across(where(is.character), ~ str_squish(.)))
    #    select(1,2, bibliography) %>% 
#    write_tsv("~/Desktop/check_lines.txt")


draft_no_html %>% 
    pull(date_du_prix_de_rome)


# normalise discipline ----------------------------------------------------

draft_discipline_normalised <- draft_no_html %>% 
    mutate(discipline = str_remove_all(discipline,
                                       "\\n|\\t|\\r|<.+>|\\(.+\\)|\\."),
           discipline = str_trim(discipline, "both"),
           discipline = str_squish(discipline),
           discipline = str_replace(discipline, "GRAVURE EN MÉDAILLES ET PIERRES FINES", "GRAVURE EN MÉDAILLES ET EN PIERRES FINES"),
           discipline = str_replace(discipline, "GRAVURE EN MÉDAILLESET EN PIERRES FINES", "GRAVURE EN MÉDAILLES ET EN PIERRES FINES"),
           discipline = str_replace(discipline, "GRAVURE EN PIERRES FINES ET EN MÉDAILLES", "GRAVURE EN MÉDAILLES ET EN PIERRES FINES"),
           discipline = str_replace(discipline, "GRAVURE EN TAILLE DOUCE", "GRAVURE EN TAILLE-DOUCE"),
           discipline = str_replace(discipline, "GRAVURE EN TAILLE- DOUCE", "GRAVURE EN TAILLE-DOUCE"),
           discipline = str_replace(discipline, "MUSIQUE", "COMPOSITION MUSICALE"),
           discipline = str_replace(discipline, "PEINTURE - GRAVURE", "PEINTURE-GRAVURE"),
           discipline = str_replace(discipline, "PEINTURE -GRAVURE", "PEINTURE-GRAVURE"),
           discipline = str_replace(discipline, "PEINTURE GRAVURE", "PEINTURE-GRAVURE"),
           discipline = str_remove(discipline, "(Brevet ).+$|( Prem).+$| (, ).+$"),
           discipline = str_replace(discipline, "ARCHITECTURE, «peintre de ruines»", "ARCHITECTURE"),
           discipline = str_to_lower(discipline)) 


draft_discipline_normalised %>% 
    mutate(an_du_prix_de_rome = str_extract(date_du_prix_de_rome, "1[6789]\\d{2}"),
           an_du_prix_de_rome = ifelse(record_id == 76, "1700",
                                       an_du_prix_de_rome),
           an_du_prix_de_rome = as.numeric(an_du_prix_de_rome))


# normalise dates ---------------------------------------------------------

dates <- draft_discipline_normalised %>% 
#    select(record_id, date_darrivee_a_rome, date_de_depart_de_rome) %>% 
    select(1, contains("date")) %>% 
    pivot_longer(2:6, names_to = "rome_date_type", values_to = "rome_date") %>% 
    mutate(rome_date = str_extract(rome_date, "(\\d{1,2} )?([Jj]anvier|[Ff]évrier|[Mm]ars|[Aa]vril|[Mm]ai|[j]uin|[Jj]uillet|[Aa]oût|[Ss]eptembre|[Oo]ctobre|[Nn]ovembre|[Dd]écembre)? ?\\d{4}")) %>% 
    mutate(rome_date = str_to_lower(rome_date),
           rome_date = str_replace(rome_date, "janvier", "January"),
           rome_date = str_replace(rome_date, "février", "February"),
           rome_date = str_replace(rome_date, "mars", "March"),
           rome_date = str_replace(rome_date, "avril", "April"),
           rome_date = str_replace(rome_date, "mai", "May"),
           rome_date = str_replace(rome_date, "juin", "June"),
           rome_date = str_replace(rome_date, "juillet", "July"),
           rome_date = str_replace(rome_date, "août", "August"),
           rome_date = str_replace(rome_date, "septembre", "September"),
           rome_date = str_replace(rome_date, "octobre", "October"),
           rome_date = str_replace(rome_date, "novembre", "November"),
           rome_date = str_replace(rome_date, "décembre", "December"),
           rome_date = str_trim(rome_date, "both"),
           rome_date = str_squish(rome_date)) %>% 
    pivot_wider(names_from = rome_date_type, values_from = rome_date) %>% 
    rename(birth_date_en = "birth_date",
           death_date_en = "death_date",
           date_of_prize = "date_du_prix_de_rome",
           date_of_arrival ="date_darrivee_a_rome",
           date_of_departure = "date_de_depart_de_rome")

dates_years <- dates %>% 
    mutate(birth_year = as.numeric(str_extract(birth_date_en, "\\d{4}")),
           death_year = as.numeric(str_extract(death_date_en, "\\d{4}")),
           prize_year = as.numeric(str_extract(date_of_prize, "\\d{4}")),
           arrival_year = as.numeric(str_extract(date_of_arrival, "\\d{4}")),
           departure_year = as.numeric(str_extract(date_of_departure, "\\d{4}")))

wiki_ids <- read_csv("data/artlas_pensionnaires_names_reconciled_values.csv")


# rename and anglicise columns --------------------------------------------

draft_combined <- draft_discipline_normalised %>% 
    inner_join(dates_years) %>% 
    inner_join(wiki_ids) %>% 
    rename(name = "name_norm",
           birth_date_fr = "birth_date",
           death_date_fr = "death_date",
           birth_place =  "birthplace",
           death_place = "deathplace",
           gender = "genre",
           father = "pere",
           mother = "mere",
           family_details = "famille",
           date_price_details_fr = "date_du_prix_de_rome",
           rome_arrival_details_fr = "date_darrivee_a_rome",
           rome_departure_details_fr = "date_de_depart_de_rome",
           education = "lieu_detudes",
           student_of = "maitre",
           subject_of_prize = "sujet_du_prix",
           prize_details = "date_du_prix_de_rome",
           stay_details = "sejour_a_rome",
           career = "carriere",
           assignment = "enseignement",
           awards = "distinctions",
           century = "siecle",
           regime = "gouvernement_de_lepoque",
           oversight = "autorites_de_tutelle",
           secretary_beaux_arts = "secretaire_de_l_academie_des_beaux_arts",
           director_academy = "directeur_de_l_academie_de_france_a_rome",
           representative_works = "oeuvres_representatives",
           ulan = union_list_of_artist_names_id)



draft_20210427 <- draft_combined %>% 
    select(record_id, name, wikidata_id,
           birth_year, birth_date_en, birth_date_fr, birth_place, #date_of_birth,
           death_year, death_date_en, death_date_fr, death_place, #date_of_death,
           last_name:student_of,
           prize_year, prize_details, subject_of_prize,
           arrival_year, rome_arrival_details_fr,
           departure_year, rome_departure_details_fr,
           envoi, career:bibliography)

draft_20210427 %>% 
    filter(!record_id %in% c(750, 1262)) %>% 
    write_csv("data/rome_academy_pensionnaires_draft20210427.csv",
              na = "")

draft_20210427 %>% 
    select(1:3, ends_with("th_year"), starts_with("date_of"), price_year) %>% 
    mutate(date_of_birth = year(date_of_birth),
           date_of_death = year(date_of_death)) %>% 
    filter(birth_year !=date_of_birth | death_year != date_of_death) %>% 
    slice(111:130)

names(draft1)

# lieu_detudes - not worthy of normalising - too many parts in this column
# but remove the html tags

# extract year of the prix du rome
draft1 %>% 
    filter(!str_detect(date_du_prix_de_rome, "\\d{4}")) %>% 
#    mutate(an_du_prix_de_rome = str_extract(date_du_prix_de_rome, "1[6789]\\d{2}")) %>% 
#               pull(record_id, date_du_prix_de_rome)
#           an_du_prix_de_rome = as.numeric(an_du_prix_de_rome)) %>% 
#    pull(date_du_prix_de_rome)
    count(an_du_prix_de_rome) 

draft1 %>% 
    mutate(an_du_prix_de_rome = str_extract(date_du_prix_de_rome, "1[6789]\\d{2}"),
           an_du_prix_de_rome = ifelse(record_id == 76, "1700",
                                       an_du_prix_de_rome),
           an_du_prix_de_rome = as.numeric(an_du_prix_de_rome)) %>% 
#    filter(record_id == 76) %>% pull(an_du_prix_de_rome)
    count(an_du_prix_de_rome) %>% 
    tail()


draft1 %>% 
    mutate(an_du_prix_de_rome = str_extract_all(date_du_prix_de_rome, "1[6789]\\d{2}")) %>%
    unnest(an_du_prix_de_rome) %>% 
    group_by(record_id) %>% 
    add_count(name = "dates_of_prix") %>%
    filter(dates_of_prix > 1) %>% 
    select(1, date_du_prix_de_rome, notes)
    pull(record_id, date_du_prix_de_rome)

## FINAL EDITS

### I had to redo the english dates, since because some names of month in French were capitalised and my code did not account for that, but I did not want to redo the whole dataset, so just joined the subset
    
data <- read_csv("data/rome_academy_pensionnaires_draft_final_20210429.csv") %>% 
     rename(supervision = oversight,
            appointments = assignment) %>% 
     write_csv("data/rome_academy_pensionnaires_data.csv", na = "")

colnames(data)
dates %>% 
    filter(str_length(date_of_arrival) < 10, str_length(date_of_arrival) > 5) %>% View()

new_dates <- dates %>% 
    select(record_id, ends_with("en"))


add_stay_column <- draft_combined %>% 
    filter(!record_id %in% c(750, 1262)) %>% 
    select(record_id, stay_details) %>% 
#    filter(str_detect(stay_details, "<")) %>% 
    mutate(stay_details = str_remove_all(stay_details, "<.+>"),
           stay_details = str_replace(stay_details, "NA", "")) 
    
data %>% 
    inner_join(add_stay_column) %>% 
#    select(-birth_date_en, -death_date_en) %>% 
#    inner_join(new_dates, by = "record_id") %>% 
    select(record_id:birth_year, birth_date_en,
           birth_date_fr:death_year, death_date_en,
           death_date_fr:bibliography) %>% 
    write_csv("")
    
# this scrip contain code for various remadiation and enrichment procedures
# to the original data
# all html tags were removed


# standa@spejsa-precision:~/Desktop/artlas/rome_academy$ grep -Eo '^ ?([A-Z]+) ?([A-Z]+)?\.' gri-ark--13960-t47q2rw95-1617122627.txt | sort | uniq -c | sort -nr


# standa@spejsa-precision:~$ grep -Eo '\([Nn]ote ..?\)' ./Desktop/artlas/romeacademy2purr/data/rome_academy_pensionnaires_draft_final_20210429.csv | sort | uniq -c

data <- read_csv("data/rome_academy_pensionnaires_data.csv")
colnames(data)