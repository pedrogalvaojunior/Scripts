/* ****************************************** */ 
DROP DATABASE IMPACTA
/* ****************************************** */
CREATE DATABASE IMPACTA
ON
(
   name='Impacta_Dados1',
   filename= 'C:\Bancos\Impacta_Dados1.mdf',
   size= 10MB,
   maxsize= 100MB,
   filegrowth= 10MB
),
(
   name='Impacta_Dados2',
   filename= 'd:\Bancos\Impacta_Dados2.ndf',
   size= 10MB,
   maxsize= 100MB,
   filegrowth= 10MB
)
LOG ON
(
   name='Impacta_Log',
   filename= 'C:\Bancos\Impacta_Log.ldf',
   size= 1MB,
   maxsize= 10MB,
   filegrowth= 1MB
)
/* ****************************************** */
Use Impacta
/* ****************************************** */
CREATE TABLE Curso
(
   Cod_Curso     int,
   Nome_Curso char(30)
)

INSERT Curso VALUES(1,'SQL Server')
INSERT Curso VALUES(2,'Oracle')
INSERT Curso VALUES(3,'PostgreSQL')

/* ***************************************** */
SELECT * FROM Curso
/* ***************************************** */
