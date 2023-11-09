Select * from CTEntrada_PQC

--Resentando o valor Identity
DBCC CHECKIDENT ('CTEntrada_PQC', RESEED, 245)

--Exibindo o valor Identity
DBCC CHECKIDENT ('CTEntrada_PQC', NORESEED)

