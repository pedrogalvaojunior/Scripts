Create Table Pontuacao
 (Codigo Int,
  Nome VarChar(20),
  Pontos SmallInt)

INSERT INTO Pontuacao Values (1, 'Junior', 10)
INSERT INTO Pontuacao Values (2, 'Marcio', 25)
INSERT INTO Pontuacao Values (3, 'Eduardo', 100)
INSERT INTO Pontuacao Values (24, 'Eduardo', 35)
INSERT INTO Pontuacao Values (10, 'Junior', 11)

Select ROW_NUMBER() OVER(ORDER BY Pontos DESC) AS 'Posição',
		 Nome, Pontos From Pontuacao
Order By Pontos Desc
