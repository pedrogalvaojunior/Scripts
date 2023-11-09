select name As 'FK Name', 
       Object_Name(parent_object_id) As 'Table', 
       object_name(referenced_object_id) As 'Column' 
from sys.foreign_keys

select * from sys.foreign_key_columns

Select so.name As 'Source Table',
           object_name(rkeyid) 'Reference Table',
           object_name(constid) As 'FK Name',
           object_name(sfk.parent_object_id) As 'Column' 
 from sys.objects so Inner join sysforeignkeys sf
                      On so.object_id = sf.fkeyid
                     Inner Join sys.foreign_keys sfk
                      On so.object_id = sfk.referenced_object_id
Order By So.Name


     Select distinct sfk.name, 
            OBJECT_NAME(sfk.parent_object_id) As 'Source Table',
            OBJECT_NAME(sfk.referenced_object_id) As 'Foreign Table',
            (Select sc.name from sys.columns sc inner join sysconstraints sct
                                                                                                on sc.object_id = sct.id
                                                                                                and sc.column_id = sct.colid
                                                                                              Inner Join sys.foreign_keys sfk
                                                                                               On sct.id = sfk.referenced_object_id)  As 'Relationship Column'
from sys.foreign_keys sfk Inner Join sys.columns sc
                                           On sfk.referenced_object_id = sc.object_id
                                          Inner Join sysconstraints sct
                                           On sct.id = sc.object_id
where  OBJECT_NAME(sfk.parent_object_id)='Tabela2'
