--Criando a Table para armazenar o CNPJ em VarChar--
Create Table TB_VarChar_CNPJ
 (Codigo Int Identity(1,1),
   CNPJ Varchar(14) Not Null)

--Criando a Table para armazenar o CNPJ em BigInt--   
Create Table TB_BigInt_CNPJ
 (Codigo Int Identity(1,1),
   CNPJ BigInt Not Null)

--Inserindo os dados--
Insert Into TB_VarChar_CNPJ Values('12345678912345')
Go 10

Insert Into TB_BigInt_CNPJ Values(12345678912345)
Go 10

--Verificando os dados armazenados em ambas as tables--
Select * from TB_VarChar_CNPJ
Select * from TB_BigInt_CNPJ

--Verificando o espaço ocupado por cada table--
sp_spaceused 'TB_VarChar_CNPJ'

sp_spaceused 'TB_BigInt_CNPJ'

--Obtendo informações estatísticas sobre a Table TB_VarChar_CNPJ--
Dbcc ShowContig ("TB_VarChar_CNPJ")

--Obtendo informações estatísticas sobre a Table TB_BigInt_CNPJ--
Dbcc ShowContig ("TB_BigInt_CNPJ")
