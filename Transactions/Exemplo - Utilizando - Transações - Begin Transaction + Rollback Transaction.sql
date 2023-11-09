CREATE TABLE Material
(
  Cod_Mat smallint       NOT NULL,
  Tip_Mat char(01)       NOT NULL,
  Des_Mat char(10)       NOT NULL,
  Qtd_Mat smallint       NOT NULL,
  Val_Mat decimal(10,2)  NOT NULL,

  CONSTRAINT PK_Mat Primary Key(Cod_Mat)
)

INSERT Material VALUES (1,'A','Caderno',10,1.25)
INSERT Material VALUES (2,'A','Caderno',8,3.25)
INSERT Material VALUES (3,'A','Lapis',1,0.25)
INSERT Material VALUES (4,'A','Lapis',5,2.25)
INSERT Material VALUES (5,'A','Borracha',7,2.00)
INSERT Material VALUES (6,'A','Caneta',3,2.50)
INSERT Material VALUES (7,'A','Caneta',5,0.50)
INSERT Material VALUES (8,'B','Cama',6,100.00)
INSERT Material VALUES (10,'B','Caderno',8,3.25)
INSERT Material VALUES (11,'B','Caderno',3,5.25)
INSERT Material VALUES (12,'B','Cadeira',3,30.00)
INSERT Material VALUES (13,'B','Guarda-Roupa',2,1200.00)
INSERT Material VALUES (14,'B','Geladeira',2,3000.00)
INSERT Material VALUES (15,'B','TV',6,300.00)
INSERT Material VALUES (16,'C','Comida',2,35.00)
INSERT Material VALUES (17,'C','Comida',7,15.00)
INSERT Material VALUES (18,'C','Cama',6,100.00)
INSERT Material VALUES (19,'C','Cama',3,400.00)
INSERT Material VALUES (20,'C','Bebida',2,1.00)
INSERT Material VALUES (21,'C','Bebida',7,7.00)

Begin Transaction

 Update Material
 Set Val_Mat=0.00

ROLLBACK TRANSACTION

Begin Transaction
 Select * from Material With(UpdLock)

Update Material 
Set Val_Mat=10.00

select * from material

Commit