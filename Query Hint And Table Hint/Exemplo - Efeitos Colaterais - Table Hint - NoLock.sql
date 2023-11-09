-- Criando as Tabelas - T1 e T2 --
Create TABLE t1 (k INT,data INT)
INSERT t1 VALUES(0,0), (1,1)

Create TABLE t2 (pk INT PRIMARY KEY)
INSERT t2 VALUES(0), (1)

-- Realizar Update na Tabela T2 - Mantendo Bloqueio --
Begin Tran
Update T2
Set PK = pk
Where pk = 0

-- Abrir nova Query e executar o Select abaixo --
SELECT * FROM t1 WITH (NOLOCK)
WHERE EXISTS (SELECT * FROM t2 WHERE t1.k = t2.pk)

-- Deixar a Query 2 rodando e voltar para Query 1 e executar o Delete --
DELETE t1 WHERE k = 0
COMMIT TRAN

-- Voltar para Query 2 e ver a mensagem de erro --
Msg 601, Level 12, State 3, Line 1
Could not continue scan with NOLOCK due to data movement.