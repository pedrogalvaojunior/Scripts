drop table Numeros
 (id uniqueidentifier rowguidcol)

insert into numeros values (1)

select * from numeros

CREATE TABLE myTable (ColumnA uniqueidentifier DEFAULT NEWSEQUENTIALID()) 

Insert Into MyTable Default Values

Select * from MyTable

Select Cast('Texto as teste' As VarBinary(20))

CREATE TABLE Globally_Unique_Data
(guid uniqueidentifier CONSTRAINT Guid_Default DEFAULT NEWSEQUENTIALID() ROWGUIDCOL,
    Employee_Name varchar(60)
CONSTRAINT Guid_PK PRIMARY KEY (Guid) );

insert into globally_unique_data (employee_name)
 values('teste')

select * from globally_unique_data