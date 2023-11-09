EXEC sp_droplinkedsrvlogin 'Pedro', Null

Exec sp_dropserver 'OurLinkedServer', droplogins

exec sp_addlinkedserver
@server = N'OurLinkedServer',
@srvproduct=N'Excel',
@provider=N'Microsoft.Jet.OLEDB.4.0',
@datasrc=N'\\saom4098\Share\DePara_Laboratorio.xls',
@provstr=N'Excel 8.0;IMEX=1'
 
EXEC sp_addlinkedsrvlogin 'OurLinkedServer', 'False','Pedro','Americas\SaoPgalv','Jpe@0609'

exec sp_testlinkedserver OurLinkedServer
-- Or select from it
select top 1 * from OurLinkedServer...teste$