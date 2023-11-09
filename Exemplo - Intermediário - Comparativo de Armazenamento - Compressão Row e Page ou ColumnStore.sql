Use TempDB
Go

Create Table dbo.MassaDeDadosCompressaoPorRow
 (Record Bigint Identity(1,1),
  Number BigInt
  Index IND_MassaDeDadosCompressaoPorRow Clustered (Number)) 
  WITH (DATA_COMPRESSION = ROW)
Go

Create Table  dbo.MassaDeDadosCompressaoPorPage
 (Record Bigint Identity(1,1),
  Number BigInt
  Index IND_MassaDeDadosCompressaoPorPage Clustered (Number)) 
  WITH (DATA_COMPRESSION = PAGE) 
Go

Create Table dbo.MassaDeDadosCompressaoPorColumnStore 
 (Record Bigint Identity(1,1),
  Number BigInt, INDEX IND_MassaDeDadosCompressaoPorColumnStore Clustered ColumnStore)
Go

SP_spaceused 'dbo.MassaDeDadosCompressaoPorRow'
Go

SP_spaceused 'dbo.MassaDeDadosCompressaoPorPage'
Go

SP_spaceused 'dbo.MassaDeDadosCompressaoPorColumnStore'
Go

Select s.Name As SchemaName, 
       t.Name As TableName, 
       p.rows As RowCounts,
       Cast(Round((Sum(a.used_pages) / 128.00), 2) As Numeric(36,2)) As Used_MB,
       Cast(Round((Sum(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) As Numeric(36, 2)) As Unused_MB,
       Cast(Round((Sum(a.total_pages) / 128.00), 2) As Numeric(36, 2)) As Total_MB
From sys.tables t Inner Join sys.indexes i 
                   On t.OBJECT_ID = i.object_id
                  Inner Join sys.partitions p 
				   On i.object_id = p.OBJECT_ID And i.index_id = p.index_id
                  Inner Join sys.allocation_units a 
				   On p.partition_id = a.container_id
                  Inner Join sys.schemas s 
				   On t.schema_id = s.schema_id
Where t.object_id >1
Group By t.Name, s.Name, p.Rows
Order By s.Name, Used_MB Desc
Go

Truncate Table dbo.MassaDeDadosCompressaoPorRow
Truncate Table dbo.MassaDeDadosCompressaoPorPage
Truncate Table dbo.MassaDeDadosCompressaoPorColumnStore
Go

Declare @Contador Int = 1

While @Contador <=1000000
Begin
 Insert Into dbo.MassaDeDadosCompressaoPorRow (Number) 
 Values (Rand()*1000000000000)

 Set @Contador +=1
End
Go

Declare @Contador Int = 1

While @Contador <=1000000
Begin
 Insert Into dbo.MassaDeDadosCompressaoPorPage (Number) 
 Values (Rand()*1000000000000)

 Set @Contador +=1
End
Go

Declare @Contador Int = 1

While @Contador <=1000000
Begin
 Insert Into dbo.MassaDeDadosCompressaoPorColumnStore (Number) 
 Values (Rand()*1000000000000)

 Set @Contador +=1
End
Go

Set Statistics Time On
Set Statistics IO On
Go

Select Max(Number) From dbo.MassaDeDadosCompressaoPorRow
Go

Select Max(Number) From dbo.MassaDeDadosCompressaoPorPage
Go

Select Max(Number) from dbo.MassaDeDadosCompressaoPorColumnStore
Go

Set Statistics IO Off
Set Statistics Time Off
Go

Set Statistics Time On
Set Statistics IO On
Go

Select * from dbo.MassaDeDadosCompressaoPorRow
Where Record Between 525000 And 789000
Go

Select * from dbo.MassaDeDadosCompressaoPorPage
Where Record Between 525000 And 789000
Go

Select * from dbo.MassaDeDadosCompressaoPorColumnStore
Where Record Between 525000 And 789000
Go

Set Statistics IO Off
Set Statistics Time Off
Go

Select * from sys.column_store_segments

SELECT i.name, p.object_Id, p.index_Id, i.type_desc, 
    COUNT(*) AS number_of_segments
FROM sys.column_store_segments AS s 
INNER JOIN sys.partitions AS p 
    ON s.hobt_Id = p.hobt_Id 
INNER JOIN sys.indexes AS i 
    ON p.object_Id = i.object_Id
GROUP BY i.name, p.object_Id, p.index_Id, i.type_desc ;
GO

select * from sys.column_store_dictionaries