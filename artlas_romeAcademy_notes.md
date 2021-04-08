# Artl@s archiving

## What is needed:

* data dictionary, some field are obvious but other less so.

* convert dates into a normalised iso 1861 format 

    select(1, title, 2:4, 17:20) #personal data
#   select(5:16)  # columns 5 through 16 are a subset related to images + bibliography
#    select(21:23) # family information
#    select(24:26) # artistic education 
#    select(27:32) # stay at the academy
#    select(33:36) # career
#    select(37:43) # artistic and historical context
#    select(44:49) # locations  (id.x - possibly entity_id)
#    select(50:62) # images - technical metadata and links 


* remove html tags from texts 
* normalise fields: genre, dates, disciline

* drop siecle


 type               n
* <chr>          <int>
1 Huile sur bois     1


Portraits of the receipients 


'http://vocabsservices.getty.edu/ULANService.asmx/ULANGetSubject?subjectId='+value


Annie and Gabriel Verger’s Biographical Dictionary of the Residents of the French Academy in Rome gathers information on all the practitioners sent to Italy by the French State from 1666, when the government of Louis XIV established the Prix de Rome competition, until its abolition in 1968. The profiles of individual resident provide biographical and professional information, such as places of birth and death, studies, shipments from Rome, occupations, awards and honors. There is also links with institutions holding primary documents on the artists, including the Archives of the Ecole nationale supérieure des Beaux-Arts; portraits of residents of the Académie de France in Rome; Shipments from Rome collected by members of the French National Institute of Art History INHA. This online version is intended to allow readers to report omissions, errors or provide further details to enrich the whole. As of today, the Dictionary is in French language.

For more information, see Annie Verger, “Rome vaut bien un prix. An Artistic Elite in the Service of the State: the Pensionnaires of the Académie de France in Rome, 1666-1968.” Artl@s Bulletin 8, 2 (Summer 2019) - see https://docs.lib.purdue.edu/artlas/.

