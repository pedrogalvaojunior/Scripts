DECLARE @t TABLE 
    (nDex INT IDENTITY(1,1),
	valu VARCHAR(9),
	keey UNIQUEIDENTIFIER)

INSERT @t
VALUES ('a',NEWID()) , ('b',NEWID()),
			 ('c',NEWID()) , ('d',NEWID()),
			 ('e',NEWID()) , ('f',NEWID()),
			 ('g',NEWID()) , ('h',NEWID()),
			 ('i',NEWID()) , ('j',NEWID()),
			 ('k',NEWID()) 

DELETE t
OUTPUT DELETED.*
FROM @t AS t INNER JOIN (SELECT TOP 9 nDex FROM @t ORDER BY NEWID()) AS b
                         ON b.ndex = t.nDex
GO