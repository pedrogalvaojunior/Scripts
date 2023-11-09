Declare @Table As Table (SINo Int, Name Varchar(500), Salary Money)
Declare @XMLIntLog As XML
Declare @IDoc Int

Set @XMLIntLog = Null
Insert Into @Table Values(1,'SES',10000)
Insert Into @Table Values(2,'SRS',40000)
Insert Into @Table Values(3,'SS',50000)

Set @XMLIntLog = (Select SINo, Name, Salary from @Table Tab For XML Auto, Root('Root'), elements)

Exec sp_xml_preparedocument @IDoc Output, @XMLIntLog

Select SINo, Name, Salary from OpenXML(@iDoc, '/Root/Tab',7)
With(SINo Int, Name Varchar(500), Salary Money)

Exec sp_xml_removedocument @IDoc