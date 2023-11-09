CREATE TABLE CONTROLERETORNO
 (CODRETORNO INT NOT NULL)

Alter Table ControleRetorno
 Add Constraint PK_CODRETORNO Primary Key (CodRetorno)

Alter Table ControleRetorno
  Alter Column RUA VARCHAR(2) NOT Null

Alter Table ControleRetorno
 Alter Column PRATELEIRA VARCHAR(4) Not Null

Alter Table ControleRetorno
 Alter Column NIVEL INT NOT Null

Alter Table ControleRetorno
 Add NumDocumento Int Not Null Default 0

Alter Table ControleRetorno
 Alter Column DATAFAB DATETIME NOT Null

Alter Table ControleRetorno
 Add CODDESTINO CHAR(1) NOT NULL


Alter Table ControleRetorno
 Add Constraint [FK_CODRETORNO] Foreign Key (ControleRetorno) References [Transferencias]([Codigo])

Select * From ControleRetorno
