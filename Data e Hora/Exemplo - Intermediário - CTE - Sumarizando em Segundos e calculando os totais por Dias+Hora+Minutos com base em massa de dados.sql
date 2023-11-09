---CRIAÇÃO DA TABELA APENAS PARA QUESTÕES DE ESTUDOS.
CREATE TABLE [dbo].[TRANSPORTESGERAIS](
	[TrasportegeralID] [bigint] NOT NULL,
	[EquipamentoID] [int] NOT NULL,
	[Tag] [varchar](6) NOT NULL,
	[NomeOperador] [varchar](100) NULL,
	[SetorOperador] [varchar](50) NULL,
	[FrenteTrabalho] [varchar](50) NULL,
	[CodigoFrenteTrabalho] [varchar](10) NULL,
	[DataRegistro] [datetime] NOT NULL,
	[Ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TrasportegeralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

---DECLARAÇÃO DE VARIAVEIS PARA GERAR DADOS.
declare @TrasportegeralID bigint 
declare @EquipamentoID int --- No maximo 4 caracteres
declare @Tag varchar(6) 
declare @NomeOperador varchar(100)
declare @SetorOperador varchar(50)
declare @FrenteTrabalho varchar(50)
declare @CodigoFrenteTrabalho varchar(10)
declare @DataRegistro datetime
declare @Ativo bit
declare @N int
declare @Qtde int

---DEFINIÇÕES DE DADOS PODEM SER ALTERADAS.
set @DataRegistro = '2020-01-01 00:00:00'
set @EquipamentoID = 25
set @tag = 'CAR-25'
set @NomeOperador = 'Jason Feliz'
set @SetorOperador = 'Motorista BW'
set @FrenteTrabalho = 'Viagens Inter-Estadual'
set @CodigoFrenteTrabalho = 'MBW-IE-12'
set @Ativo = 1
set @N = 0
set @Qtde = 8640 * 5

----FUNCÇÃO RESPONSAVEL POR GERAR OS DADOS.
while @N < @Qtde
begin

set @TrasportegeralID = Concat(convert(varchar, @dataregistro, 112), 
	replace(convert(varchar, @dataregistro, 108),':',''), 
	replace(str(@EquipamentoID,5), space(1), '0'))

set @DataRegistro = DATEADD(second, 10, @DataRegistro)

INSERT INTO [dbo].[TRANSPORTESGERAIS] ([TrasportegeralID],[EquipamentoID],[Tag],[NomeOperador],[SetorOperador],[FrenteTrabalho],[CodigoFrenteTrabalho],[DataRegistro],[Ativo])
     VALUES (@TrasportegeralID,@EquipamentoID,@Tag,@NomeOperador,@SetorOperador,@FrenteTrabalho,@CodigoFrenteTrabalho,@DataRegistro,@Ativo)


if  @n % 50 = 0
begin
	if @Ativo = 1
		begin
			set @Ativo = 0
		end
	Else
		begin
			set @Ativo = 1
		end
end


set @N = @N + 1

end

---VERIFICAÇÃO SE A TABELA DE DADOS TEMPORARIA EXISTE
IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp

----ADICIONANDO A NOVA DATA DE RESISTRO APENAS PARA EFEITO DE CALCULOS E TEMPO TOTAL DE CADA VARIAÇÃO
;With CTECalculo
As
(select Top 1000
	TrasportegeralID, 
	EquipamentoID, 
	Tag, 
	NomeOperador, 
	SetorOperador, 
	FrenteTrabalho, 
	CodigoFrenteTrabalho, 
	DataRegistro,
	LEAD(DataRegistro,1,DataRegistro) over (partition by EquipamentoID order by DataRegistro) as DataRegistroProxima,
	DATEDIFF(SECOND, DataRegistro, LEAD(DataRegistro,1,DataRegistro) over (partition by EquipamentoID order by DataRegistro)) as TempoSegundos,
	Ativo
	--into #Temp
from TRANSPORTESGERAIS),
CTECalculoAtivoUm
As
(Select Sum(TempoSegundos) / 3600 / 24 AS 'Dia(s)',
       Sum(TempoSegundos) / 3600 % 24 AS 'Hora(s)',
       Sum(TempoSegundos) / 60 % 60 AS 'Minutos',
       Ativo = 1      
From CTECalculo
Where Ativo=1)
,CTECalculoAtivoZero
As
(Select Sum(TempoSegundos) / 60 / 60 / 24 AS 'Dia(s)',
       Sum(TempoSegundos) / 60 / 60 % 24 AS 'Hora(s)',
       Sum(TempoSegundos) / 60 % 60 AS 'Minutos',
       Ativo = 0
From CTECalculo
Where Ativo=0)
Select * From CTECalculoAtivoUm
Union
Select * From CTECalculoAtivoZero
Go
