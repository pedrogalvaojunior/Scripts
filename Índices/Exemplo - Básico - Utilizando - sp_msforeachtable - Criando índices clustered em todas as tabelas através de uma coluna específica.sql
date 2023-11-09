-- Exemplo 1 --
Create Database Teste
Go

Use Teste
Go

Create Table T1
 (ID Int,
  ValorT1 Int)
Go

Create Table T2
 (ID Int,
  ValorT2 Int)
Go

-- Utilizando sp_msforeachtable --
EXEC sp_msforeachtable 'Create Clustered Index Ind_PK_ID ON ? (ID)'

-- Identify Tables and Indexes --
SELECT t.name, 
             i.name, 
			 i.type_desc, 
			 c.name
FROM sys.tables t INNER JOIN sys.indexes i
				               ON t.object_id = i.object_id 
							   AND i.index_id = 1
			                  INNER JOIN sys.index_columns ic
							   ON i.object_id = ic.object_id 
							   AND i.index_id = ic.index_id
			                  INNER JOIN sys.columns c
				               ON ic.object_id = c.object_id 
							   AND ic.column_id = c.column_id
Go

-- Exemplo 2 --
Create Procedure AlteraColuna @EsquemaTabela sysname
As
Begin

 Declare @NomeTabela sysname;

 -- Retira esquema --
 Set @NomeTabela= Substring(@EsquemaTabela, Charindex('.', @EsquemaTabela) +1, 128);

 -- Retira [] e substitui espaço (se existir) por sublinhado --
 Set @NomeTabela= Replace(Replace(Replace(@NomeTabela,'[', ''),']', ''),' ', '_');
					       
 Declare @ComandoSQL NVarchar(2000);
 Set @ComandoSQL = Space(0);
 Set @ComandoSQL += N'ALTER TABLE ' + @EsquemaTabela + N' DROP CONSTRAINT [PK_' + @NomeTabela + N'] '
 Set @ComandoSQL += N'ALTER TABLE ' + @EsquemaTabela + N' DROP COLUMN ID '
 Set @ComandoSQL += N'ALTER TABLE ' + @EsquemaTabela + N' ADD ID [int] IDENTITY (1, 1) NOT NULL '
 Set @ComandoSQL += N'ALTER TABLE ' + @EsquemaTabela + N' ADD CONSTRAINT [PK_' + @NomeTabela + N'] PRIMARY KEY (ID)'

 --Execute (@ComandoSQL) --
 Print @ComandoSQL;
End
Go

-- Executando a Stored Procedure em conjunto com sp_MSforeachtable --
Use bancodedados
Execute sp_MSforeachtable "EXECUTE AlteraColuna '?'"
Go

-- Executando de forma gradativa e removendo restrições--
Use bancodedados
Go

-- Desativa todas as restrições --
Execute sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'
Go

-- Executa a Stored Procedure -- 
Execute sp_MSforeachtable "EXECUTE AlteraColuna '?'"
Go

-- retiva todas as restrições --
Execute sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'
Go