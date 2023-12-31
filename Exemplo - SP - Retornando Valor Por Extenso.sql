if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Monetario_Nivel1_RetornoValorPorExtenso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Monetario_Nivel1_RetornoValorPorExtenso]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Monetario_RetornoValorPorExtenso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Monetario_RetornoValorPorExtenso]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [Monetario_Nivel1_RetornoValorPorExtenso] 

@valor_numerico as varchar(3),
@valor_porextenso as varchar(100) out

AS

declare @valor_len as int
declare @unidade as varchar(50)
declare @dezena as varchar(50)
declare @centena as varchar(50)

set @valor_len = len(@valor_numerico)

if( right(@valor_numerico,1) between 1 and 9 ) 
begin
   select @unidade = case right(@valor_numerico,1)
   when 1 then 'Um'
   when 2 then 'Dois'
   when 3 then 'Três'
   when 4 then 'Quatro'
   when 5 then 'Cinco'
   when 6 then 'Seis'
   when 7 then 'Sete'
   when 8 then 'Oito'
   when 9 then 'Nove'
   end
end

if( right(@valor_numerico,2) between 10 and 19 ) 
begin
   select @unidade = case right(@valor_numerico,2)
   when 10 then 'Dez'
   when 11 then 'Onze'
   when 12 then 'Doze'
   when 13 then 'Treze'
   when 14 then 'Quatorze'
   when 15 then 'Quinze'
   when 16 then 'Dezesseis'
   when 17 then 'Dezessete'
   when 18 then 'Dezoito'
   when 19 then 'Dezenove'
   end
end

if( len(@valor_numerico) >= 2 and cast(right(@valor_numerico,2) as char(1)) between 2 and 9 )
begin
   select @dezena = case cast(right(@valor_numerico,2) as char(1))
   when 2 then 'Vinte'
   when 3 then 'Trinta'
   when 4 then 'Quarenta'
   when 5 then 'Cinquenta'
   when 6 then 'Sessenta'
   when 7 then 'Setenta'
   when 8 then 'Oitenta'
   when 9 then 'Noventa'
   end
end

if( len(@valor_numerico) = 3 and cast(right(@valor_numerico,3) as char(1)) between 1 and 9 )
begin
   select @centena = case cast(right(@valor_numerico,3) as char(1))
   when 1 then 'Cento'
   when 2 then 'Duzentos'
   when 3 then 'Trezentos'
   when 4 then 'Quatrocentos'
   when 5 then 'Quinhentos'
   when 6 then 'Seiscentos'
   when 7 then 'Setecentos'
   when 8 then 'Oitocentos'
   when 9 then 'Novecentos'
   end
end

if @unidade is not null
   set @valor_porextenso = @unidade

if @dezena is not null and @unidade is null
   set @valor_porextenso = @dezena
else if @dezena is not null and @unidade is not null
   set @valor_porextenso = @dezena + ' e ' + @unidade

if @centena is not null
begin
   set @valor_porextenso = @centena
   if @dezena is not null and @unidade is null
      set @valor_porextenso = @centena + ' e ' + @dezena
   else if @dezena is not null and @unidade is not null
      set @valor_porextenso = @centena + ' e ' + @dezena + ' e ' + @unidade
   else if @dezena is null and @unidade is not null
      set @valor_porextenso = @centena + ' e ' + @unidade
   if( @valor_porextenso = 'Cento' )
      set @valor_porextenso = 'Cem'
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [Monetario_RetornoValorPorExtenso] 

@valor_numerico as varchar(100),			--FORMATO: 1.123,00
@valor_porextenso_completo as varchar(500) out

AS

if @valor_numerico is null
   return 1
if @valor_numerico = ''
   return 2

declare @valor_numerico_tmp as varchar(100)
declare @valor_numerico_spt as varchar(100)
declare @valor_num_inter as varchar(100)
declare @valor_num_cent as varchar(100)
declare @valor_porextenso as varchar(500)
declare @index as int
declare @final as int
declare @x as int

-- separa valor inteiro e centavo.
set @valor_num_inter = replace( left(@valor_numerico,len(@valor_numerico)-2), ',' , '.' )
set @valor_num_cent = right( @valor_numerico, 2 )
set @valor_numerico_tmp = @valor_num_inter
set @x = 0
set @index = 0

/* 
looping para gerar o valor por extenso de cada parte do valor inteiro; 
exemplo: 123.456.
executa primeiro para 123 em seguida para 456.
*/
while( 0 = 0 )
begin
   set @valor_numerico_tmp = right( @valor_numerico_tmp, len( @valor_numerico_tmp ) - @index )
   set @index = charindex( '.', @valor_numerico_tmp )
   if( @index < 1 ) break
   set @final = charindex( '.', @valor_numerico_tmp ) - 1
   set @valor_numerico_spt = substring( @valor_numerico_tmp, 1, @final )

   exec Monetario_Nivel1_RetornoValorPorExtenso @valor_numerico_spt, @valor_porextenso out

   set @x = @x + 1
   if( len(@valor_num_inter) < 5 )
   begin
      if( @x = 1 )
         set @valor_porextenso_completo = @valor_porextenso
   end

   if( len(@valor_num_inter) between 5 and 9 )
   begin
      if( @x = 1 )
         set @valor_porextenso_completo = @valor_porextenso + ' Mil'
      if( @x = 2 )
         set @valor_porextenso_completo = @valor_porextenso_completo + ' ' + @valor_porextenso 
   end

   if( len(@valor_num_inter) > 9 )
   begin
      if( @x = 1 )
      begin      
         if( cast(@valor_numerico_spt as int) > 1 )
           set @valor_porextenso_completo = @valor_porextenso + ' Milhões '
         else
           set @valor_porextenso_completo = @valor_porextenso + ' Milhão '
      end
      if( @x = 2 )
         set @valor_porextenso_completo = @valor_porextenso_completo + @valor_porextenso + ' Mil' 
      if( @x = 3 )
         set @valor_porextenso_completo = @valor_porextenso_completo + ' ' + @valor_porextenso 
   end
end

set @valor_porextenso_completo = @valor_porextenso_completo + ' Reais'

if( @valor_num_cent > 0 )
begin
   exec Monetario_Nivel1_RetornoValorPorExtenso @valor_num_cent, @valor_porextenso out
   if( @valor_num_cent > 1 )
      set @valor_porextenso_completo = @valor_porextenso_completo + ' e ' + @valor_porextenso + ' Centavos'
   else
      set @valor_porextenso_completo = @valor_porextenso_completo + ' e ' + @valor_porextenso + ' Centavo'
end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



declare @valor_numerico as varchar(100)
declare @valor_porextenso as varchar(500)

set @valor_numerico = '19.256,02'

exec Monetario_RetornoValorPorExtenso @valor_numerico, @valor_porextenso out

print 'R$' + @valor_numerico + ' (' + @valor_porextenso + ')'
