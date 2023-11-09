/*********************************************/
//Criando a Tabela//
Create Table FICHAINDICE
(
 NumFichaIndice Int Not Null,
 NumItemFichaIndice Int Not Null,
 NumFicha Int Not Null,
 CodProd Varchar(25) Not Null,
 CodRef Varchar(10) Not Null,
 CONSTRAINT [PK_FICHAINDICE] PRIMARY KEY  CLUSTERED 
(
		[NUMFICHAINDICE],
		[NUMITEMFICHAINDICE],
                      [NUMFICHA])
WITH  FILLFACTOR = 95  ON [PRIMARY]) ON [PRIMARY]
/*********************************************/
//Criando/Alterando a Procedure//
Alter Procedure P_MontarFichaIndice
As

Set NoCount On

Declare @Contador Int,
           @Ficha Int,
           @NumFicha Int,
           @CodProd Varchar(25),
           @CodRef Varchar(10),                
           @NumFichaIndice Int,
           @NumItemFichaIndice Int
     
Set @Contador=0
Set @Ficha=538
Set @NumFicha=0 
Set @CodProd=''
Set @CodRef=''
Set @NumFichaIndice=26141
Set @NumItemFichaIndice=1

Truncate Table FichaIndice

While @Ficha <=(Select Max(NumFicha) From Custo)
 Begin

  Select @Contador=Count(ct.CodProd),
           @CodProd=ct.CodProd,
           @NumFicha=ct.NumFicha,
           @CodRef=ctb.CodRef
  From Custo ct Inner Join CustoTab ctb 
                     On ct.codprod=ctb.codprod
  Where ct.numficha=@Ficha
  Group By ct.CodProd, ct.NumFicha, ctb.CodRef

  If @Ficha >= (Select Max(NumFicha) From Custo)
   Break
  Else
   Begin
    If @Contador >=1
     Begin 

      Insert Into FichaIndice 
      Values(@NumFichaIndice, @NumItemFichaIndice, @NumFicha, @CodProd, @CodRef)

      If (@NumItemFichaIndice) >=1 And (@NumItemFichaIndice) < 51
       Begin
        Set @NumItemFichaIndice=@NumItemFichaIndice+1
       End
       Else  If @NumItemFichaIndice = 51
        Begin 
         Set @NumItemFichaIndice=1
         Set @NumFichaIndice=@NumFichaIndice+1
        End
     End

    Set @Ficha=@Ficha+1
   End
 End
/*********************************************/
//Executando a Procedure//
Exec P_MontarFichaIndice
/*********************************************/
Select * From FichaIndice
order by numfichaIndice




