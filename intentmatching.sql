TRUNCATE iccmatches;

-- Explict intra-app ICC matches
SELECT DISTINCT B.app_id as fromapp, F.app_id as toapp, C.id as intent_id, E.id as exitpoint, 
F.id as entryclass, null as filter_id, 1 as explicit
 FROM
IClasses A inner join Classes B
on A.class=B.class
inner join Applications G on B.app_id=G.id
inner join Intents C on A.intent_id=C.id and C.implicit=0
 inner join ExitPoints E on E.id=C.exit_id
 inner join Classes F on E.class_id=F.id
 WHERE B.app_id =F.app_id 
  and E.exit_kind in ('a','s');

 -- Explicit inter-app ICC matches
 
SELECT DISTINCT
K.id as fromapp, G.id as toapp,  C.id as intent_id,  B.id as exitpoint, 
F.id as entryclass, null as filter_id, 1 as explicit
 from  ExitPoints B inner join  Intents C on 
C.exit_id=B.id and C.implicit=0
Inner join IClasses D on D.intent_id=C.id
Inner join IPackages E on E.intent_id=C.id
inner join Classes F on D.class=F.class
Inner join Applications G on G.id=F.app_id and (( E.package=G.app) or (E.package='(.*)'))
Inner join Classes J on J.id=B.class_id
Inner join Applications K on J.app_id=K.id
inner join Components H on H.class_id=F.id
 where K.id!=G.id and H.exported=1;

 
 -- --------------------------------------------------------------------------------
-- Routine categorytest
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

DECLARE filter_cursor CURSOR for  select B.scheme as filter_scheme,B.host as filter_host, B.port as filter_port, B.path as filter_path,
B.`type` as filter_type, B.subtype as filter_subtype,
C.scheme as intent_scheme, C.host as intent_host, C.path as intent_path, 
C.port as intent_port, D.`type` as intent_type, 
D.subtype as intent_subtype, C.orig_uri
 from IData A inner  join IFData B 
on A.intent_id = intent and B.filter_id =filter
left join 
ParsedURI C on A.`data`=C.id left join 
IMimeTypes D on D.intent_id=A.intent_id
where 
  ( C.host like REPLACE(B.host,'(*)','%') 
and C.port like REPLACE(B.port,'(*)','%') 
and C.scheme like REPLACE(B.scheme,'(*)','%') 
 and C.path like 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.path,'*','%'),'/','%'),'(',''),')',''),'.','') ) or (C.scheme in ('file','content'));
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


OPEN filter_cursor;
 
match_data: LOOP
	FETCH filter_cursor INTO filter_scheme,filter_host,filter_port,filter_path,filter_type,filter_subtype,intent_scheme,intent_host,intent_port,intent_path,intent_type,intent_subtype,orig_uri;
	
  	IF finished = 1 THEN 
 		LEAVE match_data;
 	END IF;
	
	BLOCK2: BEGIN
	
	DECLARE mime_match, uri_match, content_match INTEGER DEFAULT 0;
	
	 	
 	IF (filter_type = intent_type) and (filter_subtype=intent_subtype) THEN
 		SET result =1; 		
 	END IF;
 	 
	END BLOCK2;
 	
 	
END LOOP match_data;
 
CLOSE filter_cursor;

return result;

END


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

DECLARE filter_cursor CURSOR for  select B.scheme as filter_scheme,B.host as filter_host, B.port as filter_port, B.path as filter_path,
B.`type` as filter_type, B.subtype as filter_subtype,
C.scheme as intent_scheme, C.host as intent_host, C.path as intent_path, 
C.port as intent_port, D.`type` as intent_type, 
D.subtype as intent_subtype, C.orig_uri
 from IData A inner  join IFData B 
on A.intent_id = intent and B.filter_id =filter
left join 
ParsedURI C on A.`data`=C.id left join 
IMimeTypes D on D.intent_id=A.intent_id
where 
  ( C.host like REPLACE(B.host,'(*)','%') 
and C.port like REPLACE(B.port,'(*)','%') 
and C.scheme like REPLACE(B.scheme,'(*)','%') 
 and C.path like 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.path,'*','%'),'/','%'),'(',''),')',''),'.','') ) or (C.scheme in ('file','content'));
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


OPEN filter_cursor;
 
match_data: LOOP
	FETCH filter_cursor INTO filter_scheme,filter_host,filter_port,filter_path,filter_type,filter_subtype,intent_scheme,intent_host,intent_port,intent_path,intent_type,intent_subtype,orig_uri;
	
  	IF finished = 1 THEN 
 		LEAVE match_data;
 	END IF;
	
	BLOCK2: BEGIN
	
	DECLARE mime_match, uri_match, content_match INTEGER DEFAULT 0;
	
	 	
 	IF (filter_type = intent_type) and (filter_subtype=intent_subtype) THEN
 		SET result =1; 		
 	END IF;
 	 
	END BLOCK2;
 	
 	
END LOOP match_data;
 
CLOSE filter_cursor;

return result;

END
 
 -- URI parsing
 
 CREATE TABLE ParsedURI SELECT id,scheme, path, IF( LOCATE(':',host_port)>0, SUBSTRING(host_port,1,LOCATE(':',host_port)-1 ), host_port)  as host, 
IF( LOCATE(':',host_port)>0, SUBSTRING(host_port,LOCATE(':',host_port)+1), null)  as port, orig_uri 

 from (
select id,CASE WHEN uri='(.*)' THEN uri ELSE  substring_index(uri,'://',1) END  as scheme,
 CASE WHEN uri='(.*)' THEN uri ELSE substring_index( SUBSTRING(uri, LOCATE('://', uri) + 3),'/',1) END AS host_port, 
IF (LOCATE('/',SUBSTRING(uri, LOCATE('://', uri) + 3))>0, SUBSTRING(SUBSTRING(uri, LOCATE('://', uri) + 3) ,LOCATE('/',SUBSTRING(uri, LOCATE('://', uri) + 3))+1),null )as path,
uri as orig_uri
from UriData ) uriparse;
 

 -- find out data leaking apps
 
  select DISTINCT I.app_id as fromapp,  G.app_id as toapp, A.id as intent_id,
 E.id as exitpoint, 	G.id as entryclass, iflt.id as filter_id	 
	  from 
	Intents A inner join IActions B
	on A.id=B.intent_id and A.implicit=1
	inner join ExitPoints E on E.id=A.exit_id
inner join ICCDataLeaks idl on idl.exit_point_id = E.id
	inner join Classes I on E.class_id=I.id and I.app_id<1000
	inner join IFActions C on C.`action`=B.`action`
	inner join IntentFilters iflt on C.filter_id=iflt.id
	inner join Components F on F.id=iflt.component_id
	inner join Classes G on G.id=F.class_id
	inner join EntryPoints ept on ept.class_id=G.id
	inner join FromICCEntryDataLeaks fied on fied.entry_point_id=ept.id
 	inner join IFCategories H on iflt.id=H.filter_id	
 	left join ICategories K on A.id = K.intent_id
	
 where ((H.category=K.category) or (K.category is null and H.category=3))
and F.exported=1 
 and ( 
 	( not exists (select id from IData ida where ida.intent_id=A.id) and 
	not exists (select id from IFData ifd where ifd.filter_id=iflt.id)  
	 and not exists (select id from IMimeTypes imt where imt.intent_id=A.id) )   or datatest(A.id,iflt.id)=1 
 ) 
and categorytest(A.id,iflt.id)=1 