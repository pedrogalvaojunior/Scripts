CREATE TABLE Pessoas(Id INT PRIMARY KEY IDENTITY, Nome NVARCHAR(100) NOT NULL)
GO

CREATE TABLE PessoasHistorico(Id INT NOT NULL,Nome VARCHAR(50) NOT NULL,Data SMALLDATETIME NOT NULL DEFAULT GETDATE(),Situacao VARCHAR(12) NOT NULL)
go

INSERT INTO Pessoas (Nome) VALUES('Marcela Leal')
INSERT INTO Pessoas (Nome) VALUES('Tiago Péricles Guimarães')
INSERT INTO Pessoas (Nome) VALUES('Rodrigo Costa')
INSERT INTO Pessoas (Nome) VALUES('Fernanda Lima')
INSERT INTO Pessoas (Nome) VALUES('Helena Silva')
INSERT INTO Pessoas (Nome) VALUES('Raimundo Nonato')
INSERT INTO Pessoas (Nome) VALUES('Virgínia Costa dos Santos')
INSERT INTO Pessoas (Nome) VALUES('Mário Souza Andrade')
GO


ALTER TABLE Pessoas ADD Data SMALLDATETIME NOT NULL DEFAULT GETDATE()
go

MERGE PessoasHistorico AS PH
USING Pessoas AS P ON P.Id = PH.Id
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [Nome], [Data], [Situacao])
VALUES (Id, Nome, Data, 'Inserido')
WHEN NOT MATCHED BY SOURCE THEN
UPDATE SET PH.Situacao = 'Apagado', PH.Data = GETDATE();
go

select * from Pessoas
select * from PessoasHistorico



--------------------------------------------------------------------------------
