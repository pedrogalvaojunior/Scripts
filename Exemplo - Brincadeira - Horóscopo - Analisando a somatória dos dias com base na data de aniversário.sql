-- Desativando a Contagem de Linhas --
Set NoCount On
Go

-- Declarando as Variáveis de Controle --
Declare @DataNascimento Char(10) = '28/04/1980', @AnoNascimento SmallInt 

-- Atribuindo o valor do Ano de Nascimento com base na Data --
Set @AnoNascimento = SubString(Right(@DataNascimento,4),1,4)

-- Declarando a Variável do Tipo Tabela --
Declare @Numerologia Table
 (Codigo Int Primary Key Identity(1,1),
  Data Date Null,
  Ano As Convert(SmallInt,SubString(Convert(Varchar(4),Data,112),1,4)),
  Mes As Convert(TinyInt,SubString(Convert(Varchar(6),Data,112),5,2)),
  Dia As Convert(TinyInt,SubString(Convert(Varchar(8),Data,112),7,2)))

-- Declarando o Bloco Condicional, com base, na diferença entre o Ano de Nascimento e o Ano Atual --
While @AnoNascimento <= Year(Current_Date)
Begin
 
 Insert @Numerologia (Data)
 Select Concat(@AnoNascimento,'/',SubString(@DataNascimento,4,2),'/',SubString(@DataNascimento,1,2))
    
 Set @AnoNascimento +=1
End

-- Criando a CTENumerologia --
;With CTENumerologia
As
(
 Select Data As 'Data',
            Ano As 'Ano', 
            Mes As 'Mês', 
            Dia As 'Dia',
            (Ano+Mes+Dia) As 'Soma Numérica Ano + Mês + Dia',
            Convert(TinyInt,SubString(Convert(VarChar(4),Ano),1,1))+Convert(TinyInt,SubString(Convert(VarChar(4),Ano),2,1))+
            Convert(TinyInt,SubString(Convert(VarChar(4),Ano),3,1))+Convert(TinyInt,SubString(Convert(VarChar(4),Ano),4,1)) As 'Soma Numérica Ano',
            Convert(TinyInt,SubString(Convert(VarChar(2),Mes),1,1))+Convert(TinyInt,SubString(Convert(VarChar(2),Mes),2,1)) As 'Soma Numérica Mês',
            Convert(TinyInt,SubString(Convert(VarChar(2),Dia),1,1))+Convert(TinyInt,SubString(Convert(VarChar(2),Dia),2,1)) As 'Soma Numérica Dia'
 From @Numerologia
)
-- Consultando --
Select Data, Ano, Mês, Dia,
           [Soma Numérica Ano + Mês + Dia], 
           [Soma Numérica Ano],
           [Soma Numérica Mês], 
           [Soma Numérica Dia],
           [Soma Numérica Ano]+[Soma Numérica Mês]+[Soma Numérica Dia] As 'Soma Numérica Geral',
           Case Convert(TinyInt,SubString(Convert(Varchar(2),[Soma Numérica Ano]+[Soma Numérica Mês]+[Soma Numérica Dia]),1,1))+
                    Convert(TinyInt,SubString(Convert(Varchar(2),[Soma Numérica Ano]+[Soma Numérica Mês]+[Soma Numérica Dia]),2,1))
             When 12 Then 3
             When 11 Then 2
             When 10 Then 1
            Else
             Convert(TinyInt,SubString(Convert(Varchar(2),[Soma Numérica Ano]+[Soma Numérica Mês]+[Soma Numérica Dia]),1,1))+
             Convert(TinyInt,SubString(Convert(Varchar(2),[Soma Numérica Ano]+[Soma Numérica Mês]+[Soma Numérica Dia]),2,1))
           End As 'Valor Numérico do Ano'
From CTENumerologia
Go