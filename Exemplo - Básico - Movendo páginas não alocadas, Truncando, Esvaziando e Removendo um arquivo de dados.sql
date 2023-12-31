USE [ProjetoDWQueimadas]
GO

/* Move páginas alocadas do final de um arquivo de dados para páginas 
não alocadas no início de um arquivo */
DBCC SHRINKFILE (N'ProjetoDWQueimadas_Data1' , 1024, NoTruncate)
GO

/* Truncando o Arquivo de dados sem gerar fragmentação, 
Libera todo o espaço livre no final do arquivo para o sistema operacional */
DBCC SHRINKFILE (N'ProjetoDWQueimadas_Data1' , 1024, TRUNCATEONLY)
GO

-- Esvaziando o arquivo de dados --
DBCC SHRINKFILE (N'ProjetoDWQueimadas_Data1' , EMPTYFILE)
GO

-- Removendo fisicamente o arquivo --
Alter Database ProjetoDWQueimadas
Remove File ProjetoDWQueimadas_Data1
Go