-- --------------------------------------------------------------------------------
-- Routine calculatAllICCLinks
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`bosu`@`%` PROCEDURE `calculatedataleak`()
BEGIN

declare default_category INT DEFAULT 2;
DECLARE finished INTEGER DEFAULT 0;

DECLARE category_cursor CURSOR for SELECT id from CategoryStrings  where st='android.intent.category.DEFAULT';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN category_cursor;
		
FETCH category_cursor INTO default_category;


-- URI parsing
TRUNCATE ParsedURI;
 insert into ParsedURI SELECT id,scheme, path, IF( LOCATE(':',host_port)>0, SUBSTRING(host_port,1,LOCATE(':',host_port)-1 ), host_port)  as host, 
IF( LOCATE(':',host_port)>0, SUBSTRING(host_port,LOCATE(':',host_port)+1), null)  as port, orig_uri 

 from (
select id,CASE WHEN uri='(.*)' THEN uri ELSE  substring_index(uri,'://',1) END  as scheme,
 CASE WHEN uri='(.*)' THEN uri ELSE substring_index( SUBSTRING(uri, LOCATE('://', uri) + 3),'/',1) END AS host_port, 
IF (LOCATE('/',SUBSTRING(uri, LOCATE('://', uri) + 3))>0, SUBSTRING(SUBSTRING(uri, LOCATE('://', uri) + 3) ,LOCATE('/',SUBSTRING(uri, LOCATE('://', uri) + 3))+1),null )as path,
uri as orig_uri
from UriData ) uriparse;

UPDATE ParsedURI set scheme='tel' where orig_uri like 'tel:%';
UPDATE ParsedURI set scheme='file' where orig_uri like 'file:%';
UPDATE ParsedURI set scheme='vnd.youtube' where orig_uri like 'vnd.youtube:%';
UPDATE ParsedURI set scheme='sms' where orig_uri like 'smsto:%';
UPDATE ParsedURI set scheme='mailto' where orig_uri like 'mailto:%';
UPDATE ParsedURI set scheme='geo' where orig_uri like 'geo:%';
UPDATE ParsedURI set scheme='package' where orig_uri like 'package:%';
UPDATE ParsedURI set scheme='google.navigation' where orig_uri like 'google.navigation:%';
UPDATE ParsedURI set scheme='skype' where orig_uri like 'skype:%';
UPDATE ParsedURI set scheme='ticker' where orig_uri like 'ticker:%';
UPDATE ParsedURI set scheme='sip' where orig_uri like 'sip:%';
UPDATE ParsedURI set scheme='market' where orig_uri like 'market:%';
UPDATE ParsedURI set scheme='facebook' where orig_uri like 'facebook:%';
UPDATE ParsedURI set scheme='exe' where orig_uri like 'exe:%';

 -- find out data leaking apps
 TRUNCATE SensitiveChannels;
 
 
  -- Broadcast receiver leaks
  insert into SensitiveChannels
 select DISTINCT I.app_id as fromapp,  G.app_id as toapp, A.id as intent_id,
 E.id as exitpoint, 	G.id as entryclass, iflt.id as filter_id, 'R' as icc_type	 
	  from 
	Intents A  
	inner join ExitPoints E on E.id=A.exit_id and A.implicit=1 and E.exit_kind ='r'
   inner join ICCExitLeaks idl on idl.exit_point_id = E.id and idl.disabled=0
	inner join IntentActions act on A.id=act.intent_id
	inner join IFilterActions ifac on ifac.`action`=act.`action`
	inner join IntentFilters iflt on ifac.filter_id=iflt.id
	inner join Components F on F.id=iflt.component_id and F.kind='r'
	inner join Classes G on G.id=F.class_id 
		inner join Classes I on E.class_id=I.id;

-- Provider leaks
  insert into SensitiveChannels		
SELECT DISTINCT  cs.app_id as fromapp,  Classes.app_id as toapp, Uris.id as intent_id,
 Uris.exit_id as exitpoint, 	Classes.id as entryclass, 
  ProviderAuthorities.provider_id as filter_id, 'P' as icc_type	  
 FROM  `Uris` inner join `ParsedURI` 
 on Uris.data=ParsedURI.id
INNER JOIN ProviderAuthorities on ProviderAuthorities.authority=ParsedURI.host
and ParsedURI.scheme='content'
INNER JOIN Providers on Providers.id=ProviderAuthorities.provider_id
INNER JOIN Components on Components.id=Providers.component_id
INNER JOIN ICCExitLeaks on ICCExitLeaks.exit_point_id=Uris.exit_id
INNER JOIN Classes on Classes.id=Components.class_id
INNER JOIN ExitPoints on ExitPoints.id=ICCExitLeaks.exit_point_id
and ExitPoints.exit_kind='p'
INNER JOIN Classes cs on cs.id=ExitPoints.class_id;


-- Explicit intra-app ICC Leaks 
  insert into SensitiveChannels
SELECT DISTINCT F.app_id as fromapp,  B.app_id as toapp, C.id as intent_id,
 E.id as exitpoint, 	B.id as entryclass, null as filter_id, 'X' as icc_type	
 FROM
IntentClasses A inner join Classes B
on A.class=B.class
inner join Intents C on A.intent_id=C.id and C.implicit=0 
Inner join IntentPackages P on P.intent_id=C.id
inner join ExitPoints E on E.id=C.exit_id
inner join Classes F on E.class_id=F.id
inner join ICCExitLeaks H on H.exit_point_id=C.exit_id and H.disabled=0
Inner join Applications G on G.id=B.app_id
WHERE B.app_id =F.app_id and (( P.package=G.app) or (P.package='(.*)'));

-- Explicit inter-app ICC leaks

insert into SensitiveChannels
SELECT DISTINCT F.app_id as fromapp,  B.app_id as toapp, C.id as intent_id,
 E.id as exitpoint, 	F.id as entryclass, null as filter_id, 'X' as icc_type	
 FROM
IntentClasses A inner join Classes B
on A.class=B.class
inner join Intents C on A.intent_id=C.id and C.implicit=0 
 INNER JOIN Components T on T.class_id=B.id and T.exported=1
Inner join IntentPackages P on P.intent_id=C.id
inner join ExitPoints E on E.id=C.exit_id
inner join Classes F on E.class_id=F.id
inner join ICCExitLeaks H on H.exit_point_id=C.exit_id
Inner join Applications G on G.id=B.app_id
WHERE B.app_id !=F.app_id 
 and (( P.package=G.app) or (P.package='(.*)'));
 
   
 -- Explicit inter-app ICC leaks with returned results
 insert into SensitiveChannels 
  SELECT DISTINCT F.app_id as fromapp,  B.app_id as toapp, C.id as intent_id,
 rp.id as exitpoint, F.id as entryclass, NULL as filter_id, 'X' as icc_type	
 FROM
IntentClasses A inner join Classes B on A.class=B.class
inner join Intents C on A.intent_id=C.id and C.implicit=0 
Inner join IntentPackages P on P.intent_id=C.id
inner join ExitPoints E on E.id=C.exit_id and E.statement like '%startActivityForResult%'
inner join Classes F on E.class_id=F.id
inner join ExitPoints rp on rp.class_id=B.id
inner join ICCExitLeaks H on H.exit_point_id=rp.id and H.disabled=0 and H.leak_sink like '%setResult%'
Inner join Applications G on G.id=B.app_id
WHERE B.app_id =F.app_id and (( P.package=G.app) or (P.package='(.*)'));


   
 -- Implicit ICC channels
 insert into SensitiveChannels
 select  
DISTINCT fromapp,  entryCls.app_id as toapp, intent_id,
  exitpoint, 	entryCls.id as entryclass, filter_id, 'I' as icc_type	 
  FROM
( select intent.id as intent_id,ep.id as exitpoint,iac.`action`,icat.category,
idt.id as data_id,imt.id as mime_id,cls.app_id as fromapp
	  from 
	  ICCExitLeaks idl inner join ExitPoints ep on idl.exit_point_id =ep.id and 
	  ep.exit_kind in ('a','s') and idl.disabled=0
	  INNER join Classes cls on ep.class_id=cls.id
	  inner join Intents intent  on intent.exit_id=ep.id and intent.implicit=1
	left join IntentActions iac on intent.id =iac.intent_id 
	left join IntentCategories icat on intent.id=icat.intent_id
    left join IntentData idt on intent.id=idt.intent_id
    left join IntentMimeTypes imt on intent.id=imt.intent_id ) vulIntents
 inner join 
   (
	select iflt.id as filter_id,ifa.`action`,ifc.category,ifdt.id as filter_data,iflt.component_id
	  from 
	IntentFilters iflt  
	left join IFilterActions ifa on iflt.id =ifa.filter_id
	left join IFilterCategories ifc on iflt.id=ifc.filter_id
    left join IFilterData ifdt on iflt.id=ifdt.filter_id
	) allFilters
	on (vulIntents.`action` <=> allFilters.`action` ) and
	((vulIntents.category=allFilters.category) or (vulIntents.category is NULL and allFilters.category=default_category))
	and (categorytest(vulIntents.intent_id,allFilters.filter_id)=1)
	inner join Components comp on comp.id= component_id
	inner join Classes entryCls on entryCls.id=comp.class_id	
	WHERE 
	 ((vulIntents.data_id is NULL and vulIntents.mime_id is null and allFilters.filter_data is null) 
	or (datatest(vulIntents.intent_id,allFilters.filter_id)=1))
		order by intent_id ;


END