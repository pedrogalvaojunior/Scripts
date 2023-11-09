-- Exemplo 1 -- Utilizando variáveis Char com Select --
--Declarando as variáveis --
Declare @Data Char(8) = '20190212',
        @Hora Char(6) = '194000',
		@DataHora DateTime

-- Apresentando os dados --
Select @Data, @Hora,
       CONCAT(SUBSTRING(@Data,1,4),'-',SubString(@Data,5,2),'-',SubString(@Data,7,2)) DataConvertida,
	   Concat(SubString(@Hora,1,2),':',SubString(@Hora,3,2),':',SubString(@Hora,5,2)) HoraConvertida

-- Concatenando --
Select @DataHora = 
       CONCAT(SUBSTRING(@Data,1,4),'-',SubString(@Data,5,2),'-',SubString(@Data,7,2),' ',
	   Concat(SubString(@Hora,1,2),':',SubString(@Hora,3,2),':',SubString(@Hora,5,2)))

Select @DataHora
Go

-- Exemplo 2 -- Utilizando variáveis VarChar() com CTE --
Declare @Data VarChar(8) = '20190212',
        @Hora VarChar(6) = '194000'

;With CTEDataHora (DataConvertida, HoraConvertida)
As
(
Select 
       CONCAT(SUBSTRING(@Data,1,4),'-',SubString(@Data,5,2),'-',SubString(@Data,7,2)) DataConvertida,
	   Concat(SubString(@Hora,1,2),':',SubString(@Hora,3,2),':',SubString(@Hora,5,2)) HoraConvertida
)
Select Try_Convert(DateTime, Concat(DataConvertida,' ',HoraConvertida),120) As DataHora From CTEDataHora
Go

-- Exemplo 3 -- Utilizando Variável Table --
Declare @DatasVarChar Table
(Codigo TinyInt Primary Key Identity(1,1),
 DataVarchar Varchar(8) Not Null,
 HoraVarchar Varchar(6) Not Null)

Insert Into @DatasVarChar (DataVarchar, HoraVarchar)
Values ('20190212','194402'),
	   ('20190215','204803'),
	   ('20190226','194716'),
	   ('20190227','142428'),
	   ('20190225','103637'),
	   ('20190219','135549')

Select DataVarchar,
	   HoraVarchar,
	   TRY_CONVERT(datetime,Concat(SUBSTRING(DataVarchar,1,4),'-',SUBSTRING(DataVarchar,5,2),'-',SUBSTRING(DataVarchar,7,2),' ',
       Concat(SUBSTRING(HoraVarchar,1,2),':',SUBSTRING(HoraVarchar,3,2),':',SUBSTRING(HoraVarchar,5,2)))) As 'Data Hora'
From @DatasVarChar 
Go

-- Exemplo 4 -- Utilizando Tabela física --
Create Table DatasChar
(Codigo TinyInt Primary Key Identity(1,1),
 DataChar Char(8) Not Null,
 HoraChar Char(6) Not Null)
Go

Insert Into DatasChar (DataChar, HoraChar)
Values ('20190212','194402'),
	   ('20190215','204803'),
	   ('20190226','194716'),
	   ('20190227','142428'),
	   ('20190225','103637'),
	   ('20190219','135549')
Go

Select DataChar,
	   HoraChar,
	   Concat(Left(DataChar,4),'-',SUBSTRING(DataChar,5,2),'-',Right(DataChar,2),' ',
       Concat(Left(HoraChar,2),':',SUBSTRING(HoraChar,3,2),':',Right(HoraChar,2))) as 'Data Hora' 
From DatasChar 
Go

Select DataChar,
	   HoraChar,
	   Try_Convert(DateTime, Concat(Left(DataChar,4),'-',SUBSTRING(DataChar,5,2),'-',Right(DataChar,2),' ',
                   Concat(Left(HoraChar,2),':',SUBSTRING(HoraChar,3,2),':',Right(HoraChar,2))),120) as 'Data Hora' 
From DatasChar 
Go
