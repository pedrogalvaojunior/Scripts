/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

/*
  Exemplo problema com leitura na ordem do �ndice
*/

-- Conex�o 1
SET NOCOUNT ON
IF OBJECT_ID('Funcionarios') IS NOT NULL
  DROP TABLE Funcionarios
GO
CREATE TABLE Funcionarios(ID           Int IDENTITY(1,1) PRIMARY KEY,
                          ContactName  Char(7000),
                          Salario      Numeric(18,2));
GO
-- Inserir 4 registros para alocar 4 p�ginas
INSERT INTO Funcionarios(ContactName, Salario)
VALUES('Fabiano', 1000),('Ivan',2000),('Gilberto', 3000),('Luciano', 4000)
GO
CREATE NONCLUSTERED INDEX ix_Salario ON Funcionarios(Salario) INCLUDE(ContactName)
GO

/*
  Fica mudando a p�gina do Fabiano para primeira p�gina e �ltima
  
  Na primeira execu��o do update o Fabiano vai da primeira p�gina 
  para a �ltima. 
  Ele ganha 1000, ou seja, 6000 - 1000 = 5000,
  No update o SQL precisa manter o �ndice ix_Salario atualizado
  na ordem correta, ou seja, o Fabiano vai para o final (maior sal�rio)
  
  Na segunda execu��o do update o Fabiano vai da �ltima p�gina
  para a primeira
  Ele ganha 5000, ou seja, 6000 - 5000 = 1000
  No update o SQL precisa manter o �ndice ix_Salario atualizado
  na ordem correta, ou seja, o Fabiano vai para o come�o (menor sal�rio)
  
  Nota: executar o update duas vezes, e mostrar os valores mudando
*/
-- Deixar rodando o update na Conex�o 1
WHILE 1 = 1
  UPDATE Funcionarios
     SET Salario = 6000 - Salario
   WHERE ContactName = 'Fabiano';


-- Conex�o 2:
SET NOCOUNT ON;
-- Pular linha
WHILE 1 = 1
BEGIN
  IF OBJECT_ID('tempdb.dbo.#TMPFuncionarios', 'U') IS NOT NULL
    DROP TABLE #TMPFuncionarios;

  SELECT * 
    INTO #TMPFuncionarios 
    FROM Funcionarios WITH(index=ix_Salario)
  IF @@ROWCOUNT < 4
    BREAK
END
SELECT * FROM #TMPFuncionarios
GO
-- Ler linha em duplicidade
WHILE 1 = 1
BEGIN
  IF OBJECT_ID('tempdb.dbo.#TMPFuncionarios', 'U') IS NOT NULL
    DROP TABLE #TMPFuncionarios;

  SELECT * 
    INTO #TMPFuncionarios 
    FROM Funcionarios WITH(index=ix_Salario)
  IF @@ROWCOUNT > 4
    BREAK
END
SELECT * FROM #TMPFuncionarios



-- E com SnapShotIsolation Level como fica?

-- Habilitando SnapShot Isolation
ALTER DATABASE Northwind SET ALLOW_SNAPSHOT_ISOLATION ON
ALTER DATABASE Northwind SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE
GO

-- Testar novamente

-- Voltar ao normal
ALTER DATABASE Northwind SET ALLOW_SNAPSHOT_ISOLATION OFF
ALTER DATABASE Northwind SET READ_COMMITTED_SNAPSHOT OFF WITH ROLLBACK IMMEDIATE