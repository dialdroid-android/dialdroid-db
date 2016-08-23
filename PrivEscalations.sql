-- SQL query to compute privilege escalations from computed Sensitive ICC channels

select DISTINCT SensitiveChannels.fromapp,SensitiveChannels.toapp,idl.id as data_leak_id, pl.PermissionID
 from SensitiveChannels 
 INNER JOIN ICCExitLeaks idl on idl.exit_point_id=SensitiveChannels.exitpoint 
 	and idl.disabled=0 and SensitiveChannels.fromapp!=SensitiveChannels.toapp
 INNER JOIN PermissionLeaks pl on pl.ICCLeakID=idl.id
 
 LEFT JOIN UsesPermissions up on up.app_id=SensitiveChannels.toapp and up.uses_permission=pl.PermissionID
 WHERE  up.id is null;