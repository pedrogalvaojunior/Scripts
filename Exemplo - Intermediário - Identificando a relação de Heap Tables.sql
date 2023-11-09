SELECT SCH.name + '.' + TBL.name as TableName 
  from sys.indexes as IDX 
       inner join sys.tables as TBL on TBL.object_id = IDX.object_id
       inner join  sys.schemas as SCH on TBL.schema_id = SCH.schema_id 
  where IDX.type = 0 --> Heap 
  order by TableName;