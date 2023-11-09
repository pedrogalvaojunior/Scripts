Create Database MsTechDay
Go


-- Criando uma nova Tabela --
CREATE TABLE Familia
(Nomes varchar(15))
Go

INSERT INTO Familia values
('Pedro'), ('Fernanda'), ('Eduardo'), ('João Pedro'), ('Maria Luíza')

-- Criando uma nova Sequência de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avança de um em um
 MINVALUE 1 -- Valor mínimo 1
 MAXVALUE 10 -- Valor máximo 10000
 CACHE 10 -- Mantém 10 posições em cache
 NO CYCLE -- Não irá reciclar

  -- Utilizando a Sequência de Valores --
SELECT Next VALUE FOR Seq AS ID, Nomes FROM Familia;

-- Reinicializando a valor da Sequência --
ALTER Sequence Seq
 RESTART WITH 1 ;

   -- Utilizando a Sequência de Valores + Rank Function --
SELECT Next VALUE FOR Seq OVER (ORDER BY NOMES Desc) AS ID, Nomes FROM Familia

-- Excluíndo a Sequência --
Drop Sequence Seq