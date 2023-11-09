CREATE TABLE TbTeste (id int, nome varchar(10));

GO

 

CREATE TRIGGER dbo.trg_insert

ON TbTeste

INSTEAD OF INSERT

AS

IF EXISTS (SELECT a.id FROM inserted AS a INNER JOIN tbTeste AS b ON a.id = b.id)

BEGIN 

--RAISERROR(50010, 16, 1, 'Registro já existe!')

PRINT 'REGISTRO JÁ EXISTE!'

ROLLBACK

END

ELSE

INSERT tbTeste (id, nome) SELECT * FROM inserted

GO

 

INSERT TbTeste

VALUES (1, 'João')

INSERT TbTeste

VALUES (2, 'Maria')

--Teste da Trigger

INSERT TbTeste

VALUES (1, 'João')

 

SELECT * FROM tbTeste

 

--Apagando os objetos

DROP TABLE TbTeste
