select * from syscolumns

select * from sysobjects

select so.Name As "Nome da Tabela",
         sc.Name As "Nome do Campo"
 from syscolumns sc inner join sysobjects so
                            on sc.id = so.id
where so.Name='Produtos'

select so.Name+' --> '+sc.Name As "Tabela --> Campo"
 from syscolumns sc inner join sysobjects so
                            on sc.id = so.id
where so.Name='Produtos'

                                
sp_columns produtos

select * from information_schema.tables where table_name = 'produtos'

select * from information_schema.columns where table_name = 'produtos'
