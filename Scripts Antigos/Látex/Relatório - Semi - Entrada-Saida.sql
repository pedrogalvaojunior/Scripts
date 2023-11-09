USE SEMI200

Drop Table #tableSaldos --Table Temporária

Declare @NivelQuebra Char(4),
           @Contador Int,
           @CentroCusto Int

Set @NivelQuebra = ''
Set @Contador=0
Set @CentroCusto=0

Create Table #TableSaldos
                     (NivelQuebra VarChar(5),
                       CentroCusto Char(3),
                       SaldoEntrada Float Null,
                       SaldoSaida Float Null)

Insert Into #TableSaldos
Select   NIVEL_QUEBRA,
           CENTRO_CUSTO,
           SUM(QUANTIDADE) As "Saldos das Entradas",
           '0.00'
FROM MOVSEMI 
WHERE Month(DATA) = 10
And     Nivel_Quebra <> ''
AND TIPO_MOV >='01' And Tipo_Mov <='09' 
GROUP BY NIVEL_QUEBRA, CENTRO_CUSTO
ORDER BY NIVEL_QUEBRA, CENTRO_CUSTO

While @Contador <=(Select Count(*) from #TableSaldos)
 Begin
   Select Top 1 @NivelQuebra = NivelQuebra,
                      @CentroCusto = CentroCusto
    From #TableSaldos Where NivelQuebra > @NivelQuebra

   Update #TableSaldos
    Set SaldoSaida=(Select Sum(Quantidade) from MovSemi 
                           Where Month(Data)=10 
                           And Tipo_Mov BetWeen '51' And '59'
                           And  Nivel_Quebra=@NivelQuebra
                           And  CentroCusto = @CentroCusto)                                                      
    Where NivelQuebra = @NivelQuebra
    And    CentroCusto = @CentroCusto

  Set @Contador = @Contador + 1                        
 End

Set NoCount On

Select *, Round(IsNull(SaldoEntrada - SaldoSaida,'0.00'),3) As Saldos from #TableSaldos
Order By NivelQuebra, CentroCusto


