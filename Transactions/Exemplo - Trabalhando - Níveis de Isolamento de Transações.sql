set transaction isolation level read uncommitted 

SELECT * FROM PRODUTO With(ReadPast)

Update Produto
set Val_UnitProd=110

Insert Produto
Values(111,'B.....',13,90000.00)

set transaction isolation level read committed 

set transaction isolation level serializable