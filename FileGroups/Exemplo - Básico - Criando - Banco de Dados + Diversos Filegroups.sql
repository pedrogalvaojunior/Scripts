/* ****************************************** */ 
Use Master
/* ****************************************** */ 
DROP DATABASE IMPACTA
/* ****************************************** */
CREATE DATABASE IMPACTA
ON PRIMARY
(
   name='Impacta_Dados1',
   filename= 'C:\Bancos\Impacta_Dados1.mdf',
   size= 10MB,
   maxsize= 100MB,
   filegrowth= 10MB
),
FILEGROUP SEGUNDO
(
   name='Impacta_Dados2',
   filename= 'd:\Bancos\Impacta_Dados2.ndf',
   size= 10MB,
   maxsize= 100MB,
   filegrowth= 10MB
),
FILEGROUP TERCEIRO
(
   name='Impacta_Dados3',
   filename= 'd:\Bancos\Impacta_Dados3.ndf',
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

CREATE TABLE Aluno
(
  Cod_Aluno int,
  Nome_Aluno char(20)
)ON SEGUNDO

CREATE TABLE Professor
(
   Cod_Prof  int,
   Nome_Prof  char(20)
)ON TERCEIRO

/* **************************************** */
INSERT Curso VALUES(1,'SQL Server')
INSERT Curso VALUES(2,'Oracle')
INSERT Curso VALUES(3,'PostgreSQL')

INSERT Aluno VALUES(1,'Ana')
INSERT Aluno VALUES(2,'Rosana')

INSERT Professor VALUES(1,'Paulo')
INSERT Professor VALUES(2,'Paula')

/* ***************************************** */
SELECT * FROM Curso
SELECT * FROM Aluno
SELECT * FROM Professor
/* ***************************************** */

Exec SP_HelpFile

Exec SP_HelpFileGroup

Exec SP_Help Curso
Exec SP_Help Aluno
Exec SP_Help Professor
/* ***************************************** */