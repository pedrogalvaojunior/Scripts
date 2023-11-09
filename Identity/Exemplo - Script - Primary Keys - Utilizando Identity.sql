Select * from sys.index_columns

Select * from sys.indexes


Select * from sys.identity_columns

Select * from sys.objects

Select O.Object_Id, 
         O.Name, 
         Case IC.is_identity
          When 0 Then 'Identity desabilitado'
          When 1 Then 'Identity habilitado'
         End As 'Identity'
From sys.objects O Inner Join sys.identity_columns IC
                            On O.object_id = IC.object_id
Where IC.is_identity=1 