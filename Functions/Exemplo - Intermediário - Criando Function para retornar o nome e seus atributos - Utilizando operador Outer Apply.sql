CREATE FUNCTION AttributesOfTable (@tableToSearch nvarchar(500))
returns table    
return SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
         from information_schema.columns
         where TABLE_NAME = @tableToSearch;
go


declare @tableToSearch table (nome_tabela varchar(50));
INSERT into @tableToSearch values ('Customer'), ('Order'), ('Papagaio');

SELECT T1.nome_tabela as [nome da tabela],
       T2.TABLE_SCHEMA as [nome do esquema],
       T2.COLUMN_NAME as [nome da coluna]
  from @tableToSearch as T1
       outer apply dbo.AttributesOfTable(T1.nome_tabela) as T2;