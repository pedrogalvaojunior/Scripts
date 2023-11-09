CREATE TABLE test(
empid varchar(6),
empname varchar(100),
dob datetime,
salary decimal(12,2),
Nome Varchar(2000)
)

INSERT INTO test
SELECT 'EMP001','Suresh','19910619',3000,'Pedro Galvão'
UNION ALL
SELECT 'EMP002','Ramesh','19710103',20000,'Teste'
UNION ALL
SELECT 'EMP003','Nilesh','19800722',4760,''
UNION ALL
SELECT 'EMP004','Kumar','19680911',42000,''

Declare @Comando Varchar(500)

Set @Comando='bcp Master..Test out c:\teste.csv -SSAONT016 -c -t, /CACP -T'

Exec xp_cmdshell @Comando

Alter Table Test
 Add Cidade Char(100) Null

Update Test
Set Cidade = 'São Roque'+Char(9)

Select Datalength('                                                                                           ')