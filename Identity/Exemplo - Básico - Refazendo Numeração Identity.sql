Use Laboratorio

Declare @Identity Int

---Refazendo numera��o Controle de Entrada - Mat�ria Prima ---
Set @Identity=(Select Ident_Current('CTEntrada_PQC'))

DBCC CheckIdent('CTEntrada_PQC',Reseed,@Identity)

---Refazendo numera��o Controle de Produ��o - Moinho ---
Set @Identity=(Select Ident_Current('CTProducao_Moinho'))

DBCC CheckIdent('CTProducao_Moinho',Reseed,@Identity)

---Refazendo numera��o Controle de Entrada - Recebimento - L�tex ---
Set @Identity=(Select Ident_Current('CTEntrada_Recebimento_L�tex'))

DBCC CheckIdent('CTEntrada_Recebimento_Latatex',Reseed,@Identity)

---Refazendo numera��o Controle de Produ��o - PVM ---
Set @Identity=(Select Ident_Current('CTProducao_PVM'))

DBCC CheckIdent('CTProducao_PVM',Reseed,@Identity)
Go