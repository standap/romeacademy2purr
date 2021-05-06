variable | class | original_french_headers | description of the variable
-------- | ----- | ----------------------- | ---------------------------
record_id | numeric | record_id | Record ID of the artist.
name | character | Title | Name of the artist as it appears in the wikidata database.
wikidata_id | character |  | Identifier of the artist in wikidata (q number). If an identifier was not available, an item record in wikidata was created.
birth_year | numeric |  | Year of birth extracted from the birth_date_fr column.
birth_date_en | character |  | Date of birth translated from the French original in birth_date_fr column.
birth_date_fr | character | Date de naissance | Date of birth in French. Often with an explanatory note. On occasion, other dates were used as a proxy for the date of birth, such as the date of baptism. Multiple dates exist and alternative dates are identified in the note column.
birth_place | character | Lieu de naissance | Place of birth of the artist. Normalised English forms of place names together with their identifiers in wikidata and GIS coordinates can be found in the accompanying file rome_academy_places_gis.csv
death_year | numeric |  | Year of death extracted from the death_date_fr.
death_date_en | character |  | Date of death translated from the French original in death_date_fr column.
death_date_fr | character | Date de décès | Date of death in French. Often with an explanatory note. Multiple dates exist in records and alternative dates are identified in the note column.
death_place | character |  | Place of death of the artist. Normalised English forms of place names together with their identifiers in wikidata and GIS coordinates can be found in the accompanying file rome_academy_places_gis.csv.
last_name | character | Nom de famille | Family name.
first_name | character | first_name | Given name, often in a fuller form.
gender | character | Genre | Gender of the artist.
father | character | Père | Socio-economic and professional background of the father.
mother | character | Mère | Socio-economic and professional background of the mother.
family_details | character | Famille | Family background and origin.
discipline | character | Discipline | Discipline in which the award was awarded.
education | character | Lieu d'études | Institutions of education, studies, and training.
student_of | character | Maître | Master or mentors of the artist.
prize_year | numeric |  | Year when the Prix de Rome was awarded.
prize_details | character | Date du Prix de Rome | Further details regarding the award of the Prix de Rome.
subject_of_prize | character | Sujet du Prix | Subject or a theme for which the Prix de Rome was awarded.
arrival_year | numeric |  | Extracted year of arrival from the rome_arrival_details column.
rome_arrival_details | character | Date d'arrivée à Rome | Details regarding arrival of the artist at the academy in Rome.
rome_stay_details | character | Séjour à Rome | Details regarding the stay of the artist at the academy in Rome.
departure_year | numeric |  | Extracted year of departure from the rome_departure_details column.
rome_departure_details | character | Date de départ de Rome | Details regarding arrival of the artist from the academy in Rome.
envoi | character | Envoi | List of works that the artist (pensionnaire) was obligated to send to France each year.
career | character | Carrière | Career details over the whole life-span of the artists, especially after their stay in Rome.
appointments | character | Enseignement | Commissions and teaching appointments.
awards | character | Distinctions | Awards, honours, and acknowledgements other than the Prix de Rome.
notes | character | Notes | Clarifying notes of Annie Verger.
century | character | Siècle | Century in which the artist was primarily active.
regime | character | Gouvernement de l'époque | Head of the state and regime in France at the time of award.
supervision | character | Autorités de tutelle | Supervisory authorities, political and administrative tutors.
secretary_beaux_arts | character | Secrétaire de l'Académie des Beaux-arts | Name of the secrétaire perpétuel at the Académie des Beaux-Arts.
director_academy | character | Directeur de l'Académie de France à Rome | Name of the director of the Académie de France in Rome at the date that the prize was awarded.
salons_expositions | character | Salons, expositions | Salons and exhibitions in which the artist participated.
representative_works | character | Oeuvres représentatives | The most significant or representative works of the artist.
bibliography | character |  | List of works that mention the artists and their work.
