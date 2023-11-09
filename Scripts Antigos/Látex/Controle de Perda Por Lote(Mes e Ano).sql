Alter  Procedure P_ControlePerdaPorLoteMes @Mes Int, @Ano Int
As
SELECT SubString(Convert(VarChar(7), CodProduto),1,3)+' - '+
           (Select Descricao From Produtos Where Codigo =  SubString(Convert(VarChar(7), CodProduto),1,3)) As "Descrição do Produto",
           Case
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),6,2)=10 Then 'VERDE'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),6,2)=30 Then 'AMARELA'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),6,2)=60 Then 'LARANJA'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 Or   SubString(Convert(VarChar(7), CodProduto),1,1)=4   And SubString(Convert(VarChar(7), CodProduto),6,2)=00 Then 'BRANCA'
           End As Cor,  
           Case
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then 'P'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then 'M'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then 'G'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=4 Then 'XG'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=0 Then 'PP'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then 'P'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then 'M'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then 'G'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then '6.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then '6.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then '7.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=4 Then '7.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=5 Then '8.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=6 Then '8.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=7 Then '9.0'
           End As Tamanho,  
           LOTEPRODUCAO,                        
           CONVERT(CHAR(10), DATAPRODUCAO, 103) AS "Data de Produção",
           SubString(LoteProducao,6,1) As Máquina,
           LOTEINTERNO,
           Round(PESO,2) As Peso,
           Furos=Round(FUROS01 + ISNULL(FUROS03,0.000) + ((FUROS02 + ISNULL(FUROS04,0)) * 
                    (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))),2),
           Rasgos=Round(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                      (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),
           Bolhas=Round(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                      (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),
           Bordas=Round(Borda01 + ISNULL(Borda03,0.000) + ((Borda02 + ISNULL(Borda04,0)) * 
                      (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))),2),
           Sujas=Round(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                     (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),
           Outros=Round(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                      (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),
           Residuos=Round(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),
           PorcFuros=(FUROS01 + ISNULL(FUROS03,0.000) + (FUROS02 + ISNULL(FUROS04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcRasgos=(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcBolhas=(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcBordas=(Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcSujas=(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcOutros=(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           PorcResiduos=(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2),
           SomaTiposPerdas=Round(FUROS01 + ISNULL(FUROS03,0.000) + (FUROS02 + ISNULL(FUROS04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2)+
                                    Round(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),2),             
           SomaPorcTiposPerdas=(FUROS01 + ISNULL(FUROS03,0.000) + (FUROS02 + ISNULL(FUROS04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
                                         (RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
                                         (Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
	                              (Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
			       (Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
			       (Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))*100)/Round(Peso,2)+
		                  (Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) *100)/
                                           (Select Sum(IsNull(Round(Peso,2),0.000)) From CTLuvas Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano),
           SomaPeso=(Select Sum(IsNull(Round(Peso,2),0.000)) From CTLuvas 
                            Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano),
           MaoDireita=(Select Sum(IsNull(Round(Peso,2),0.000)) From CTLuvas 
                            Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano And Mao='D' And SubString(Convert(Char(1), CodProduto),1,1) <> '3' And CTLuvas.LoteProducao = LoteProducao),
           MaoEsquerda=(Select Sum(Round(Peso,2)) From CTLuvas 
                               Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano And Mao='E' And SubString(Convert(Char(1), CodProduto),1,1) <> '3' And CTLuvas.LoteProducao = LoteProducao),
           SomaPerdaTotalProducao=(Select Top 1 IsNull(Round(Quantidade,2),0.000) From Residuos 
                                                Where Residuos.Codigo = SubString(Convert(VarChar(7),CodProduto),1,3) And Residuos.LoteProducao = LoteProducao),
           PorcSomaPerdaTotalProducao=((Select Top 1 IsNull(Round(Quantidade,2),0.000) From Residuos 
                                                       Where Residuos.Codigo = SubString(Convert(VarChar(7),CodProduto),1,3) And Residuos.LoteProducao  = LoteProducao)*100)/
                                                       (Select Sum(IsNull(Round(Peso,2),0.000)) From CTLuvas, Residuos Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano And CodProduto = Residuos.Codigo),
           SomaFinalPerdaTotalProducao=(Select Sum(IsNull(Round(Quantidade,2),0.000)) From Residuos 
                                                Where DatePart(Month, Data)=@Mes And DatePart(Year, Data)=@Ano),
           PorcSomaFinalPerdaTotalProducao=((Select Sum(IsNull(Round(Quantidade,2),0.000)) From Residuos 
                                                       Where DatePart(Month, DataProducao)=@Mes 
                                                       And    DatePart(Year,   DataProducao)=@Ano)*100)/
                                                       (Select Sum(IsNull(Round(Peso,2),0.000)) From CTLuvas Where DatePart(Month, DataProducao)=@Mes And DatePart(Year, DataProducao)=@Ano)

FROM CTLUVAS 
WHERE DatePart(Month, DataProducao)=@Mes
And      DatePart(Year,    DataProducao)=@Ano
ORDER BY LoteProducao, CodProduto, LoteInterno 


Drop Procedure P_ControlePerdaPorLoteMes




