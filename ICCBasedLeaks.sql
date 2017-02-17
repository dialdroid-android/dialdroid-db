 -- SQL query to compute ICC based dataleaks from computed Sensitive ICC Channels
 
 select DISTINCT source.app as sourceapp, source.id as source_id, idl.method as source_method, 
	idl.leak_path as source_app_path, sink.id as sink_id, sink.app as sinkapp,
	fid.leak_path as sink_app_path,  fid.sink_method, icc_type
 from SensitiveChannels 
	inner join Applications source on 
		SensitiveChannels.fromapp=source.id
	inner join Applications sink on 
		SensitiveChannels.toapp=sink.id
 inner join EntryPoints ep on ep.class_id=entryclass
 inner join ICCEntryLeaks fid on fid.entry_point_id=ep.id
 INNER JOIN ICCExitLeaks idl on idl.exit_point_id=SensitiveChannels.exitpoint and idl.disabled=0 
 LEFT JOIN IntentExtras on IntentExtras.intent_id=SensitiveChannels.intent_id
 WHERE (fid.leak_path is null) or (IntentExtras.id is null) or  (fid.leak_path like CONCAT('%',IntentExtras.extra,'%'))
order by sourceapp;
