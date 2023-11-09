If exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[V_ReorganizarNumTeste]') and OBJECTPROPERTY(id, N'IsView') = 1)
 Drop View [dbo].[V_ReorganizarNumTeste]

Create View V_ReorganizarNumTeste
As
 Select * From CTBaloes
  Where DatePart(Month,DataTeste)=Month(GetDate())
  And    DatePart(Year,DataTeste)=Year(GetDate())
/********************************************************/
Alter Procedure dbo.ReorganizarNumTeste
As
  Declare @NumTeste Int, @Contador Int
  Set @NumTeste=1

  Select @Contador=Count(NumTeste) From CTBaloes
   Where DatePart(Month,DataTeste)=Month(GetDate())
   And    DatePart(Year,DataTeste)=Year(GetDate())

  While @NumTeste <= @Contador
   Begin
    Set @NumTeste=@NumTeste+1

    Begin Transaction
     Update CTBaloes
     Set NumTeste=@NumTeste
     Where DatePart(Month,DataTeste)=Month(GetDate())
     
     If @@ERROR <> 0
      Begin       
       ROLLBACK  TRANSACTION
       Break
       RETURN
      End
  End

Commit Transaction

/********************************************************/
Exec reorganizarnumteste
/********************************************************/
Select * From CTBaloes
 Where    DatePart(Year,DataTeste)=Year(GetDate())
 ORDER BY NUMTESTE

Declare @NumTeste Int, @Contador Int
 Set @NumTeste=1

 Select @Contador=Count(NumTeste) From CTBaloes
 Where DatePart(Month,DataTeste)=Month(GetDate())
 And    DatePart(Year,DataTeste)=Year(GetDate())
 PRINT @Contador
/********************************************************/

Create View V_Teste
As
 Select * From CTBaloes CT
  Where DatePart(Month,CT.DataTeste)=Month(GetDate())
  And    DatePart(Year,CT.DataTeste)=Year(GetDate())

Select * From CTBaloes CT Inner Join V_Teste VT On CT.CodProduto = VT.CodProduto
 Where DatePart(Month,CT.DataTeste)=Month(GetDate())
 And    DatePart(Year,CT.DataTeste)=Year(GetDate())
 And    CT.DataTeste=VT.DataTeste
 And    CT.Maquina=VT.Maquina
/********************************************************/
Drop View V_Teste
/********************************************************/

SELECT * FROM V_REORGANIZARNUMTESTE