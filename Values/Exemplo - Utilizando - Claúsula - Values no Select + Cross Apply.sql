Select * from (Values ('Pedro'),('FIT')) As Teste(About)

Select * from (Values ('Teste')) As Tabela ("Teste")

Select * from (Values ('Pedro'),('FIT')) As Teste(About)
 Cross Apply (Select About) As CrossApplyColuna(Coluna)