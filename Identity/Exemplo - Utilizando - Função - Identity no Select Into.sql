-- Utilizando - Fun��o - Identity no Select Into --
select identity(int, 1,1) As Seq, name into #teste from sys.sysdatabases