Set LinhaValor=%1

@Echo "Executando o Script"
sqlcmd -SSAOM4036\SQLEXPRESS -E -v Valor=%LinhaValor% -i teste1.sql