---
Title : "Readme file for the Archived data of the Biographical Dictionary of the Residents of the French Academy in Rome (3710)"
Abstract: "This dataset contains information converted from a book of Annie and Gabriel Verger’s Biographical Dictionary of the Residents of the French Academy in Romem (2011) converted into a tabular form. The electronic version of these data is available at https://acad-artlas.huma-num.fr/ stored in MySQL database in the Omeka platform."
Created by: "Stanislav Pejša"
Date: "2021-05-05"
---

# romeacademy2purr
this repository contains code and files for transforming the artl@s Rome academy data as stored in Omeka to archiveable data in PURR, dataset Archived data of the Biographical Dictionary of the Residents of the French Academy in Rome (3710)

The data were remedied and their structure transformed in order to facilitate easier quantitative analysis and visualisation. Key dates were extracted into separate columns, personal and topographic names were normalised and reconciled with wikidata database. The wikidata identifiers for the individual artists and places were insertd into the tables. The data from Omeka were downloaded on 10 February 2021.

The headers in data were translated into English, but the original headers are preserved in the dictionaries files, names of the persons and place names were edited into forms more common in English based on the wikidata records.

## DATA
The dataset contains two datafiles:  

 * rome_academy_pensionnaires_data.csv - contains mainly the biographical and prosopographic data of the individual artists.  
 * rome_academy_places_gis.csv - contains the place names from the biographic datasets reconciled against type 'commune of France' (Q484170) in wikidata. Subsequently, corresponding GIS coordinates were extracted from the wikidata records and the country in which the place is located.

The step needed before the dataset can be archived: 

- [x] Prepare files for wiki data  
- [x] Identify q-identifiers in wikidata for all persons.
- [x] Identify q-identifiers in wikidata for the places of birth and death.    
- [x] If they are not available, create wikidata item records.  
- [x] Remove HTML tags from columns in the table.  
- [x] Normalise content of the columns wherever possible in open refine.  
- [x] Create data dictionaries for data.

## Resources
Here is the website of the Envois : <https://inhaparis.github.io/Les-envois-de-Rome_v1/>


## DOCUMENTATION

artlas_archive_dictionary.md  
artlas_archive_places_gis_dictionary.md  
readme.txt  
wikidata_schema.json  

The dataset includes data dictionaries for each data file. A readme.md file with description of each file and a wikidata schema that was used for creating the wikidata item records in openrefine.

## VISUALISATION
map_birth_death.png

An image with places of birth and death of the individual awardees from rome_academy_places_gis.csv. 
