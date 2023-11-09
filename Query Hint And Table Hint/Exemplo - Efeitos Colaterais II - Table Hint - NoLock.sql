-- Preparando o ambiente

IF OBJECT_ID('Tab1') IS NOT NULL

 DROP TABLE Tab1

IF OBJECT_ID('Tab2') IS NOT NULL

 DROP TABLE Tab2

GO

CREATE TABLE Tab1 (ID INT, Col1 Char(500) DEFAULT NEWID())

GO

INSERT Tab1(ID) VALUES(0), (1)

GO

CREATE TABLE Tab2 (ID INT PRIMARY KEY, Col1 Char(500) DEFAULT NEWID())

GO

INSERT Tab2(ID) VALUES(0), (1)

GO

-- Conexão 1

SET NOCOUNT ON

WHILE 1 = 1

BEGIN

 -- Conexão 1

 BEGIN TRAN

 DELETE Tab1 WHERE ID = 0

 COMMIT TRAN

 INSERT INTO Tab1(ID) VALUES(0)

END

-- Conexão 2

SET NOCOUNT ON

WHILE 1=1

BEGIN

 IF OBJECT_ID('tempdb.dbo.#Tab1') IS NOT NULL

   DROP TABLE #Tab1

 SELECT *

   INTO #Tab1 

   FROM Tab1 WITH(NOLOCK)

  WHERE EXISTS (SELECT * 

                  FROM Tab2 WITH(NOLOCK)

                 WHERE Tab1.ID = Tab2.ID)

END
