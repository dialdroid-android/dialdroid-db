
-- --------------------------------------------------------------------------------
-- Routine datatest
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `datatest`(`intent` INT, `filter` INT) RETURNS tinyint(4)
    NO SQL
BEGIN

DECLARE filter_scheme,filter_host,filter_port,filter_path,filter_type,filter_subtype VARCHAR(200);
DECLARE intent_scheme,intent_host,intent_port,intent_path,intent_type,intent_subtype VARCHAR(200);
DECLARE orig_uri VARCHAR(512);
DECLARE finished INTEGER DEFAULT 0;
DECLARE result INTEGER DEFAULT 0;

DECLARE filter_cursor CURSOR for   select DISTINCT F.scheme as filter_scheme,F.host as filter_host, F.port as filter_port, F.path as filter_path,
F.`type` as filter_type, F.subtype as filter_subtype,
C.scheme as intent_scheme, C.host as intent_host, C.path as intent_path, 
C.port as intent_port, M.`type` as intent_type, 
M.subtype as intent_subtype, C.orig_uri
 from
 (SELECT id from Intents WHERE id=intent) I left join IntentData intent_data on I.id=intent_data.intent_id 
 left join IntentMimeTypes M on M.intent_id= I.id
left join 
  ParsedURI C on intent_data.`data`=C.id 
 inner  join IFilterData F on F.filter_id =filter 
  -- MIME type and subtypes must match if non-null 
 and (M.`type`<=> F.`type` and M.subtype <=> F.subtype) and C.orig_uri!='(.*)'
 where 
( 
-- Both URIs are null
(intent_data.id is null and F.scheme is null and F.host is null) OR
-- If a filter specifies only a scheme, all URIs with that scheme match the filter.
(F.scheme is not null and  F.host is null and F.path is null and C.scheme=F.scheme) OR
-- If a filter specifies a scheme and an authority but no path, all URIs with the same scheme and authority pass the filter, regardless of their paths.
(F.path is null and F.scheme = C.scheme and  F.host = C.host  and F.port <=> C.port) OR
-- If a filter specifies a scheme, an authority, and a path, only URIs with the same scheme, authority, and path pass the filter.
(C.path like REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(F.path,'*','%'),'/','%'),'(',''),')',''),'.','') 
and F.scheme = C.scheme and  F.host = C.host  and F.port <=> C.port) OR
-- Intent passes the URI part of the test either if its URI matches a URI in the filter or if it has a content: or file:
-- and the filter does not specify a URI
(C.scheme in ('file','content') and F.scheme is null and F.host is null and F.`type` is not null) ) ;

 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


OPEN filter_cursor;
 
match_data: LOOP
	FETCH filter_cursor INTO filter_scheme,filter_host,filter_port,filter_path,filter_type,filter_subtype,intent_scheme,intent_host,intent_port,intent_path,intent_type,intent_subtype,orig_uri;
	
  	IF finished = 1 THEN 
 		LEAVE match_data;
 	END IF;
	
	SET result =1; 		
 	 	
END LOOP match_data;
 
CLOSE filter_cursor;

return result;

END$$

DELIMITER ;
