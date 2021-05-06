variable | class | description
-------- | ----- | -----------
record_id | numeric | Record ID of the artist.
name | character | Name of artist as it appear in the wikidata database and in the archived dataset.
place_type | character | Type of normalised place, either the place of birth or the place of death.
place | character | Place name as it appears in the _Residents of the French Academy in Rome_ database.
place_normalised | character | Normalised form of the French place name, reconciled in the wikidata database against the type 'commune of France' (Q484170).
wikidata_id | character | Identifier of the place in wikidata (q number).
country | character | Name of country in which the place is located, extracted from the wikidata record.
latitude | numeric | Latitude of the place extracted from the wikidata record.
longitude | numeric | Longitude of the place, extracted from the wikidata record.
