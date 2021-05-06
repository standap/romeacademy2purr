select * from omeka_collections oc; 

select * from omeka_collection_trees oct2;

select * from omeka_exhibits oe; 

select * from omeka_files of2; 

select count(*), oi.owner_id from omeka_items oi
group by owner_id; 
#where oi.collection_id != 1;

select * from omeka_item_types oit ;

select * from omeka_item_types_elements oite;

select * from omeka_element_texts oet; 

select * from omeka_neatline_records onr;


## THIS THE SCRIPT THAT PRODUCES THE DATA FOR OMEKA
select oet.record_id, oet.element_id, oe.id, oe.element_set_id, oe.name, oe.description, oet.text, oe.comment from omeka_element_texts oet
inner join omeka_elements oe on (oe.id = oet.element_id)
where record_id = 1286
;

select * from omeka_element_texts oet
inner join omeka_elements oe on (oe.id = oet.element_id)
where record_id = 14
;

select * from omeka_locations ol
;

select * from omeka_elements oe; 

select * from omeka_element_sets oes; 

select * from omeka_users ou; 
select * from omeka_files of2;

select * from omeka_exhibit_block_attachments oeba; 
