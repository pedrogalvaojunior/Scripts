Set Nocount On
Go
  
Create Table FileList 
(id int identity(1,1) primary key clustered,  
 FileName varchar(max))
Go
  
Create Table #TempTable
(id int identity(1,1) primary key clustered,  
 FileName varchar(max),  
 FileDepth int,  
 FileID int)  
Go
 
Create Table  dbo.TestBlob
(tbId   int  IDENTITY(1,1) NOT NULL,  
 tbName   varchar (50) NULL,  
 tbDesc   varchar (100) NULL,  
 tbBin   varbinary (max) NULL)
Go

Insert Into #TempTable
EXEC master.sys.xp_dirtree 'E:\ExcelOutput',0,1;  
Go

Select * from #TempTable

Declare @I int=0, @FileName varchar(max), @Count int  
  
Select * into #TempFileList from  FileList  
Set @Count=(Select count(*) from #TempFileList)  
  
Declare @SQLText nvarchar(max)  
While (@i<@Count)  
begin  
    Set @FileName=(select top 1 FileName from #TempFileList)  
    Set @SQLText='Insert TestBlob(tbName, tbDesc, tbBin) Select '''+@FileName+''',''Files'', 
	BulkColumn from Openrowset( Bulk '''+@FileName+''', Single_Blob) as tb'  
    
    Print @SQLText  
    Delete from #TempFileList where FileName=@FileName  
    Set @I=@I+1  
End   
 
Select tbID as ID,
       tbName as 'File Name', 
       tbBin as 'Converted file'  
       from TestBlob
Go

Drop Table #TempFileList
Go