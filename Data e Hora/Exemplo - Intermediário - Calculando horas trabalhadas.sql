CREATE TABLE RESP1
(
	ID INT,
	DATA DATE,
	HORA TIME
)

-------------------------------------------------------------------------
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate(),'08:01:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate(),'12:08:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate(),'13:16:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate(),'17:02:00')

INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate()+1,'08:00:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate()+1,'12:00:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate()+1,'13:00:00')
INSERT INTO [RESP1] ([ID],[DATA],[HORA]) VALUES(145,Getdate()+1,'17:00:00')




;WITH LANCA AS (
SELECT ID,DATA,HORA,
ROW_NUMBER() OVER (
PARTITION BY DATA,ID ORDER BY DATA,ID) AS POS
FROM RESP1
),
LANCAORG AS(
SELECT  L1.ID,L1.DATA, L1.HORA AS ENTRADA, L2.HORA AS SAIDA
FROM LANCA AS L1
INNER JOIN LANCA AS L2 ON
L1.ID = L2.ID AND L1.DATA = L2.DATA AND L1.POS = L2.POS - 1 AND L1.POS %2=1)

SELECT ID, DATA,
    RIGHT('0' + CAST(SUM(DateDiff(Mi,Entrada,Saida)) / 60 As VARCHAR(2)),2) + ':' +
    RIGHT('0' + CAST(SUM(DateDiff(Mi,Entrada,Saida)) % 60 As VARCHAR(2)),2)
As CargaHoraria
FROM LANCAORG GROUP BY ID, Data