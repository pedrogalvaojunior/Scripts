-- 1. crie um table type para ser seu array --

Create type MeuArray as table(valor nvarchar(200))
go

-- 2. crie a função que irá fazer a procura do valor no "array" --

Create function TestaExistencia (@valor nvarchar(200), @array MeuArray readonly)
returns bit
as
begin
  declare @achou as  bit = 0
  if exists (select 1 from @array where @valor in (select valor from @array))
  begin
     set @achou = 1
  end
  return @achou
end
go

-- 3. Use e seja feliz! --

declare @acheIsso nvarchar(200) = 'Oi'
declare @listaDeValores MeuArray

--Insert into @listaDeValores values ('Oi'),( 'Tchau'),( 'Good Bye'),( 'Hello World!'),( 'Vaza!'),( 'Da linha'),( 'Some')

Select dbo.TestaExistencia(@acheIsso, @listaDeValores)

O select acima mostra 1 porque 'Hello World!' faz parte do "array". Mude a string e o resultado será 0.