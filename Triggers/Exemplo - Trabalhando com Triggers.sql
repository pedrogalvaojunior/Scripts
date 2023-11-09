CREATE TRIGGER T_UpdNumTeste
ON CTBALOES
FOR UPDATE
AS
  Declare @NUMTESTE Int

  UPDATE NumTeste
  SET NumTeste = Inserted.NumTeste
  FROM CTBaloes inner join Inserted
  ON CTBaloes.NumTeste = Inserted.NumTeste
  Where DatePart(Month,CTBaloes.DataTeste)=Month(GetDate())
/********************************************************/

ALTER TRIGGER T_UpdNumTeste
ON CTBALOES
FOR UPDATE
AS

  UPDATE NumTeste
  SET NumTeste = Inserted.NumTeste+1
  From CTBaloes Inner Join Inserted 
  On CTBaloes.CodProduto = Inserted.CodProduto
  Where Datepart(Month,CTBaloes.DataTeste)=Month(GetDate())
  And    DatePart(Year,CTBaloes.DataTeste)=Year(GetDate())
  And    CTBaloes.NumTeste=Inserted.NumTeste
  And    CTBaloes.DataTeste=Inserted.DataTeste
  And    CTBaloes.Maquina=Inserted.Maquina

ALTER TRIGGER T_IncNumTeste
ON CTBALOES
FOR INSERT
AS

  Update NumTeste
  Set NumTeste=Inserted.NumTeste+1
  From CTBaloes Inner Join Inserted 
  On CTBaloes.CodProduto = Inserted.CodProduto
  Where Datepart(Month,CTBaloes.DataTeste)=Month(GetDate())
  And    DatePart(Year,CTBaloes.DataTeste)=Year(GetDate())
  And    CTBaloes.NumTeste=Inserted.NumTeste
  And    CTBaloes.DataTeste=Inserted.DataTeste
  And    CTBaloes.Maquina=Inserted.Maquina
  
/********************************************************/

select * from ctbaloes
where datepart(month,datateste)=Month(GetDate())
And    datepart(year,datateste)=Year(GetDate())
order by numteste

select * from ctbaloes
where datepart(month,datateste)=02
And    datepart(year,datateste)=2004
order by numteste

select * from numteste

update NumTeste
Set NumTeste=239
/********************************************************/