-- Criando a Table com Datatype SQL_Variant --
CREATE   TABLE tableA(colA sql_variant, colB int)

-- Inserindo Dados --
INSERT INTO tableA values ( cast (46279.1 as decimal(8,2)), 1689)
INSERT INTO tableA values ( 'Teste', 5844)
INSERT INTO tableA values ( 'Oi este é um teste', 4545844)
INSERT INTO tableA values ( 'VAmos em frente', 5844754)
INSERT INTO tableA values ( 'hahahahaha', 125844)

-- Utilizando a função SQL_Variant_property com tabelas --
SELECT   SQL_VARIANT_PROPERTY(colA,'BaseType') AS 'Base Type',
               SQL_VARIANT_PROPERTY(colA,'Precision') AS 'Precision',
               SQL_VARIANT_PROPERTY(colA,'Scale') AS 'Scale'
FROM      tableA
WHERE      colB = 1689
 

-- Utilizando a função Col_Length --
Select Col_length('TableA','ColA') 

-- Utilizando a função SQL_Variant_property com variáveis --
DECLARE @X varchar(10), @X1 Int
Set @X = 0
Set @X1=1

select sql_variant_property(@X ,'MaxLength') as TamanhoVarchar,
           sql_variant_property(@X1 ,'MaxLength') as TamanhoInt


-- Utilizando a Função Len --
SELECT  Len(Convert(VarChar(10),ColA)) As TamanhoColunaA,
              Len(Convert(VarChar(10),ColB)) As TamanhoColunaB
FROM      tableA
WHERE      colB = 1689