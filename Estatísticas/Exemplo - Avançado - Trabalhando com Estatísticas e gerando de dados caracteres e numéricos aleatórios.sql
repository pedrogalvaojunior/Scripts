--Criando Banco de Dados Estatisticas --
If (DB_ID('Estatisticas') Is Not Null) 
 Drop Database Estatisticas
Else
 Create Database Estatisticas
Go

-- Acessando o Banco de Dados Estatisticas --
USE Estatisticas
Go

-- Criando a Tabela Pedidos --
Create TABLE Pedidos
  (ID int IDENTITY(1,1) NOT NULL Primary Key,
	Cliente int NOT NULL,
	Vendedor varchar(30) NOT NULL,
	Quantidade smallint NOT NULL,
	Valor numeric(18,2) NOT NULL,
	Data date NOT NULL)
Go

-- Inserindo a Massa de Dados na Tabela Pedidos --
Declare @Texto Char(129), 
             @Posicao TinyInt, 
			 @ContadorLinhas SmallInt

Set @Texto = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ' -- Existem 130 caracteres neste texto --

Set @ContadorLinhas = Rand()*50000+1 -- Definir a quantidade de linhas para serem inseridas --

While (@ContadorLinhas >=1)
Begin

 Set @Posicao=Rand()*130

 Insert Into Pedidos (Cliente, Vendedor, Quantidade, Valor, Data)
 Values(@ContadorLinhas, 
            Concat(SubString(@Texto,@Posicao,1),SubString(@Texto,@Posicao+2,1),SubString(@Texto,@Posicao+3,1)),
            Rand()*1000, 
		    Rand()*100+5, 
		    DATEADD(d, 1000*Rand() ,GetDate()))

 Set @ContadorLinhas = @ContadorLinhas - 1
End

-- Contando a quantidade de linhas da Tabela Production.TransactionHistory --
Select Count(*) From Pedidos
Go  

-- Descobrindo o tamanho da Tabela Production.TransactionHistory --
Exec sp_spaceused 'Pedidos'
Go

-- Consultando os Metadados das Estatísticas --
Select OBJECT_NAME(s.object_id) As Tabela, 
            s.name As Estatistica,
			s.auto_created As Tipo,
            c.name As Coluna
from sys.stats_columns sc Inner Join sys.columns c 
                                                       ON sc.object_id = c.object_id 
													   AND sc.column_id = c.column_id  
	                                                 Inner Join sys.stats s 
													  ON sc.object_id = s.object_id 
													  AND sc.stats_id = s.stats_id 
Where OBJECT_NAME(s.object_id) = 'Pedidos'
Go

-- Executando uma simples query --
Select * From Pedidos
Where Year(Data) In (2016, 2017)
Order By Data Desc, Valor Desc
Go

-- Obtendo a data de atualização das Estatísticas existentes na Tabela Pedidos -- View sys.stats --
Select name AS 'Nome da Estatística', STATS_DATE(object_id, stats_id) AS 'Data Atualização' 
From sys.stats   
Where object_id = OBJECT_ID('Pedidos');  
Go  

-- Obtendo a lista de Estatísticas associadas a Tabela Pedidos, em adicional o Status e Last Updated -- Stored Procedure -- SP_AutoStats --
Exec sp_autostats 'Pedidos'
Go

-- Apresentando o Histograma da chave primária --
DBCC SHOW_STATISTICS("Pedidos",[_WA_Sys_00000006_0EA330E9])
Go

-- Criando uma nova Estatísticas para Tabela Pedidos na coluna Quantidade --
CREATE STATISTICS [StatiticsQuantidade] ON [dbo].[Pedidos]([Quantidade])
Go

-- Atualizando as Estatísticas da Tabela Pedidos de forma manual --
Update Statistics Pedidos[StatiticsQuantidade] With FullScan
Go

Update Statistics Pedidos([PK__Pedidos__3214EC27E1D47BE3]) With FullScan
Go

Update Statistics Pedidos([_WA_Sys_00000006_0EA330E9]) With FullScan
Go

Update Statistics Pedidos([_WA_Sys_00000006_04E4BC85]) With FullScan
Go

-- Atualizando todas as Estatísticas da Tabela Pedidos --
Update Statistics Pedidos
Go

-- Atualizando as Estatísticas internas do Banco de Dados e tabelas de usuários --
Exec sp_updatestats
Go

-- **Quando atualizar as Estatísticas não refletirem nas mudanças de Densidade, é necessário Reorganizar ou Reconstruír os índices ** --

-- Executando uma simples query --
Select * From Pedidos
Where Quantidade Between 1 And 255
Order By Quantidade Desc, Data Desc
Go