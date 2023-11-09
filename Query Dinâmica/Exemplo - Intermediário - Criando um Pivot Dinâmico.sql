-- Criando a Tabela --
CREATE TABLE #T1 
(Hora time(0), 
 Carro char(3), 
 Apelido varchar(20))
Go

INSERT into #T1 (Hora, Carro, Apelido)
Values ('1:00','ABC','Carro 1'),
       ('1:00','DEF','Carro 2')
Go

-- Pesquisando os dados --
Declare @Carros varchar(200);

Set @Carros= Stuff((SELECT distinct ',' +  QuoteName(Convert(varchar,Carro))
                    from #T1 for XML PATH('')),1,1,'');

-- Declarando o Pivot com Query Dinâmica --
Declare @ComandoSQL varchar(1000);

Set @ComandoSQL= 'SELECT Hora, ' + @Carros + ' from #T1 ' +
                 'pivot (max(Apelido) for Carro in (' + @Carros + ')) as T2';

-- Executando a Query Dinâmica --
Exec(@ComandoSQL);

-- Excluíndo a tabela --
Drop Table #T1