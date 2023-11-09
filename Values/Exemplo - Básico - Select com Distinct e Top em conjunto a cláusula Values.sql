SELECT DISTINCT TOP 5 Id FROM (VALUES (1), (1), (1), (1), (1),
			              (2), (2), (2), (2), (2),
			              (3), (3), (3), (3), (3),
			              (4), (4), (4), (4), (4),
			              (5), (5), (5), (5), (5)
       			      ) Valores(Id)
Order By Id
Go