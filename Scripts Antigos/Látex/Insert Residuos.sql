Declare @Lote Char(5),
           @Ano Char(4),
           @Dia Char(2),
           @Mes Char(2),
           @Quantidade Float

Select @Lote=Lote, 
          @Ano=Ano, 
          @Dia=Dia, 
          @Mes=Mes from LoteProducao
Where Ano=2007
And Dia=16
And Mes=10

Set @Quantidade=0.800+0.400+0.150

INSERT INTO RESIDUOS(CODIGO, DATA, LOTEPRODUCAO, MAQUINA, QUANTIDADE)
VALUES(251,@Dia+'/'+@Mes+'/'+@Ano,@lote+'8',8,@Quantidade)

select count(codigo) from residuos

select * from residuos
where codigo=251
and datepart(month,data)=10
and maquina=8



