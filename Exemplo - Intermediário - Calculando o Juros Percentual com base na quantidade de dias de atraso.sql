-- Criando a Tabela INPCDiasDeAtraso --
Create Table INPCDiasDeAtraso
 (CodigoINPC Int Identity(1,1) Primary Key,
  DataINPC As (DateAdd(Day,CodigoINPC,GetDate())),
  Ano As (Year(GetDate()+CodigoINPC)),
  Mes As (Month(GetDate()+CodigoINPC)),
  ValorINPC As (0.01*CodigoINPC))
Go

-- Inserindo uma massa de dados --
Insert Into INPCDiasDeAtraso (DataINPC) Default Values
Go 1000

-- Consultando --
Select Top 100 CodigoINPC, 
                         Convert(Date,DataINPC) As DataINPC,
						 Ano, 
		                 Mes, 
		                 ValorINPC
From INPCDiasDeAtraso
Order By ValorINPC Asc
Go

-- Criando a Tabela de Pagamentos --
Create Table Pagamentos
 (CodigoPagamento Int Identity(1,1) Primary Key,
  DataVencimento As (DateAdd(Day,CodigoPagamento,GetDate())),
  DataPagamento As (DateAdd(Day,CodigoPagamento,GetDate()+CodigoPagamento)),
  ValorParcela As (Rand()*CodigoPagamento+100))
Go

-- Inserindo uma massa de dados --
Insert Into Pagamentos Default Values
Go 1000

-- Consultando --
Select Top 200 P.CodigoPagamento, 
                        Cast(P.DataVencimento As Date) As DataVencimento,
                        Cast(P.DataPagamento As Date) As DataPagamento, 
                        Cast(P.ValorParcela As Decimal(10,2)) As ValorParcela
From Pagamentos P 
Order By DataVencimento Desc
Go

-- Simulando o cálculo de Juros com base na diferença entre a Data de Pagamento e Data de Vencimento --
Select P.CodigoPagamento, 
          Cast(P.DataVencimento As Date) As DataVencimento,
          Cast(P.DataPagamento As Date) As DataPagamento, 
          Cast(P.ValorParcela As Decimal(10,2)) As ValorParcela,
		  DATEDIFF(Day, P.DataVencimento, P.DataPagamento) As 'Dias de Atraso',
		  Concat(IsNull(I.ValorINPC,0),'%') As ValorINPC,
		  Cast(P.ValorParcela+(P.ValorParcela*I.ValorINPC) As Decimal(10,2)) As NovaParcela
From Pagamentos P Outer Apply (Select ValorINPC From INPCDiasDeAtraso
                                                       Where CodigoINPC = DATEDIFF(Day, P.DataVencimento, P.DataPagamento)) As I
Where DATEDIFF(Day, P.DataVencimento, P.DataPagamento) <= 50
Go

