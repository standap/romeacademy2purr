library(tidyverse)
library(WikidataQueryServiceR)
library(WikidataR)

awardees <- query_wikidata('select distinct ?item ?itemLabel ?itemDescription ?sitelinks where {
    ?item wdt:P31 wd:Q5;  # Any instance of a human.
    wdt:P166 wd:Q576434;  #  Who received ward - Prix de Rome.
    wikibase:sitelinks ?sitelinks.
    
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
} order by desc(?id )')

awardees


#Retrieve an item 
item <- get_item(id = "Q1451049")
str(item)


