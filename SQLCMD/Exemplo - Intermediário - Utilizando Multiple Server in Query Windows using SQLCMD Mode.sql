-- Sem o GO o SQLCMD Mode não entende o final do bloco --
:connect saom4276
  select @@SERVERNAME

 :connect SAOM4276\SQLEXPRESS2014
  select @@SERVERNAME

-- Utilizando o comando Go para encerrar o bloco --
:connect saom4276
  select @@SERVERNAME
Go

 :connect SAOM4276\SQLEXPRESS2014
  select @@SERVERNAME
Go