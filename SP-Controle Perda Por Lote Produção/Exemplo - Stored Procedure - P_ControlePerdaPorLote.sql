USE [LABORATORIO]
GO
/****** Object:  StoredProcedure [dbo].[P_ControlePerdaPorLote]    Script Date: 06/03/2008 21:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[P_ControlePerdaPorLote] @LoteProducao Char(6), @CodProduto VarChar(3)
As
Set NoCount On
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
           CONVERT(CHAR(10), DATAPRODUCAO, 103) AS "Data de Produção",
           SubString(LoteProducao,6,1) As Máquina,
           LOTEINTERNO,
           IsNull(Round(PESO,3),0.000) As Peso,
           Furos=Round(FUROS01 + ISNULL(FUROS03,0.000) + ((FUROS02 + ISNULL(FUROS04,0)) * 
                    (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))),3),
           Rasgos=Round(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                      (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),
           Bolhas=Round(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                     (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),
           Bordas=Round(Borda01 + ISNULL(Borda03,0.000) + ((Borda02 + ISNULL(Borda04,0)) * 
                     (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))),3),
           Sujas=Round(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                    (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),
           Outros=Round(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                     (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),
           Residuos=Round(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                        (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),
           PorcFuros=Round(FUROS01 + ISNULL(FUROS03,0.000) + ((FUROS02 + ISNULL(FUROS04,0)) * 
                    (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4))),2)*100/Round(Peso,3),
           PorcRasgos=(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
           PorcBolhas=(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
           PorcBordas=(Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                            (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
           PorcSujas=(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                          (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
           PorcOutros=(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                           (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
           PorcResiduos=(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                              (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)))*100/Round(Peso,3),
		   SomaTiposPerdas=IsNull(Round(FUROS01 + ISNULL(FUROS03,0.000) + (FUROS02 + ISNULL(FUROS04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),0.000),             
		   SomaPorcTiposPerdas=IsNull(Round(FUROS01 + ISNULL(FUROS03,0.000) + (FUROS02 + ISNULL(FUROS04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(RASGO01 + ISNULL(RASGO03,0.000) + (RASGOS02 + ISNULL(RASGO04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Bolha01 + ISNULL(Bolha03,0.000) + (Bolha02 + ISNULL(Bolha04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Borda01 + ISNULL(Borda03,0.000) + (Borda02 + ISNULL(Borda04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Suja01 + ISNULL(Suja03,0.000) + (Suja02 + ISNULL(Suja04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Outros01 + ISNULL(Outros03,0.000) + (Outros02 + ISNULL(Outros04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3)+
                                  Round(Residuos01 + ISNULL(Residuos03,0.000) + (Residuos02 + ISNULL(Residuos04,0)) * 
                                       (Select Peso From PesoMedio_Embalagem Where SubString(Grupo,1,4) = SubString(Convert(VarChar(7), CodProduto),1,4)),3),0.000)*100/Round(Peso,3),
           SomaPeso=IsNull((Select Sum(IsNull(Round(Peso,3),0.000)) From CTLuvas 
                            Where LoteProducao=@LoteProducao And SubString(Convert(VarChar(7),CodProduto),1,3)=@CodProduto),0.000),
           MaoDireita=IsNull((Select Sum(IsNull(Round(Peso,3),0.000)) From CTLuvas 
                            Where LoteProducao=@LoteProducao And Mao='D' And SubString(Convert(VarChar(7),CodProduto),1,3)=@CodProduto),0.000),
           MaoEsquerda=IsNull((Select Sum(Round(Peso,3)) From CTLuvas 
                               Where LoteProducao=@LoteProducao And Mao='E' And SubString(Convert(VarChar(7),CodProduto),1,3)=@CodProduto),0.000),
           SomaPerdaTotalProducao=IsNull((Select IsNull(Round(Quantidade,3),0.000) From Residuos Where LoteProducao = @LoteProducao And Codigo = SubString(Convert(VarChar(7),CodProduto),1,3)),0.000),
           PorcSomaPerdaTotalProducao=IsNull(((Select IsNull(Round(Quantidade,3),0.000) From Residuos 
                                                       Where LoteProducao = @LoteProducao And  Codigo = SubString(Convert(VarChar(7),CodProduto),1,3))*100)/
                                                       (Select Sum(IsNull(Round(Peso,3),0.000)) From CTLuvas Where LoteProducao=@LoteProducao And SubString(Convert(VarChar(7),CodProduto),1,3)=@CodProduto),0.000)
FROM CTLuvas 
WHERE LoteProducao = @LoteProducao 
And     SubString(Convert(Varchar(7), CodProduto),1,3) = @CodProduto
ORDER BY Maquina, LoteInterno, CodProduto Asc
