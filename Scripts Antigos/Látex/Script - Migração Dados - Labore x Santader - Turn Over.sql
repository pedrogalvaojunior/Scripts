USE CORPORERM

Select Distinct
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') <=6  And CodSituacao = 'A' And Year(DataAdmissao)<=2007) As 'Ativos Seis Meses',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=6 And DateDiff(Month,DataAdmissao,'31/12/2007') <=12  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos até 1 Ano',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=12 And DateDiff(Month,DataAdmissao,'31/12/2007') <=24  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos de 1 a 2 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=24 And DateDiff(Month,DataAdmissao,'31/12/2007') <=48  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos de 2 a 4 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=48 And DateDiff(Month,DataAdmissao,'31/12/2007') <=60  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos de 4 a 5 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=60 And DateDiff(Month,DataAdmissao,'31/12/2007') <=108  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos de 5 a 9 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=120 And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Ativos a mais de 10 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') <=6  And CodSituacao = 'A' And Year(DataAdmissao)<=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=6 And DateDiff(Month,DataAdmissao,'31/12/2007') <=12  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=12 And DateDiff(Month,DataAdmissao,'31/12/2007') <=24  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=24 And DateDiff(Month,DataAdmissao,'31/12/2007') <=48  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=48 And DateDiff(Month,DataAdmissao,'31/12/2007') <=60  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=60 And DateDiff(Month,DataAdmissao,'31/12/2007') <=108  And CodSituacao = 'A' And Year(DataAdmissao) <=2007) +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=120 And CodSituacao = 'A' And Year(DataAdmissao) <=2007) As 'Total Ativos até 2007'
From PFunc F
Go


Select Distinct
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') <=6  And CodSituacao = 'D') As 'Demitidos com Seis Meses',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=6 And DateDiff(Month,DataAdmissao,'31/12/2007') <=12  And CodSituacao = 'D') As 'Demitidos com 1 Ano',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=12 And DateDiff(Month,DataAdmissao,'31/12/2007') <=24  And CodSituacao = 'D') As 'Demitidos de 1 ou 2 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=24 And DateDiff(Month,DataAdmissao,'31/12/2007') <=48  And CodSituacao = 'D') As 'Demitidos de 2 a 4 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=48 And DateDiff(Month,DataAdmissao,'31/12/2007') <=60  And CodSituacao = 'D') As 'Demitidos de 4 a 5 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=60 And DateDiff(Month,DataAdmissao,'31/12/2007') <=108  And CodSituacao = 'D') As 'Demitidos de 5 a 9 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=120 And CodSituacao = 'D') As 'Demitidos com mais de 10 Anos',
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') <=6  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=6 And DateDiff(Month,DataAdmissao,'31/12/2007') <=12  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=12 And DateDiff(Month,DataAdmissao,'31/12/2007') <=24  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=24 And DateDiff(Month,DataAdmissao,'31/12/2007') <=48  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=48 And DateDiff(Month,DataAdmissao,'31/12/2007') <=60  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=60 And DateDiff(Month,DataAdmissao,'31/12/2007') <=108  And CodSituacao = 'D') +
        (Select Count(*) from PFunc Where DateDiff(Month,DataAdmissao,'31/12/2007') >=120 And CodSituacao = 'D') As 'Total demitidos'
From PFunc F
Go


Select (Select Count(*) from PFunc Where Year(DataAdmissao)<=2005 And CodSituacao IN ('A','F')) As 'Total 2005',
(Select (Select Count(*) from PFunc Where Year(DataAdmissao)<=2006 And CodSituacao IN ('A','F'))) As 'Total 2006',
(Select (Select Count(*) from PFunc Where Year(DataAdmissao)<=2007 And CodSituacao IN ('A','F'))) As 'Total 2007'
Go