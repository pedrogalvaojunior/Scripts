select * from information_schema.tables

sp_depends 'Project'

select * from sysdepends

select * from sys.sysobjects
where name = 'Project'
 
select object_name(sd.id), so.name, 
           Type=(Select Type from sysobjects where name = object_name(sd.depid)) 
 from sysdepends sd Inner Join sysobjects so
                                   on sd.depid = so.id                                                       
 where depid=674101442


select Distinct OBJECT_NAME(sd.object_id) ObjAnalisado, 
           OBJECT_NAME(sd.referenced_major_id) ObjReferenciado 
from sys.sql_dependencies sd
where sd.referenced_major_id = 
          (Select Id from Sysobjects where name = object_name(sd.referenced_major_id))
and SubString(OBJECT_NAME(sd.object_id),1,3) <> 'SP_'
Order By (OBJECT_NAME(sd.object_id))

select * from sys.sql_dependencies

select so.name As 'Source Table',
           object_name(rkeyid) 'Reference Table',
           object_name(constid) As 'FK Name'
 from sys.objects so inner join sysforeignkeys sf
                                                                         on so.object_id = sf.fkeyid
Order By So.Name
