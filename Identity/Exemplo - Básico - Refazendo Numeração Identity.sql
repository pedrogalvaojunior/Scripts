Use Laboratorio

Declare @Identity Int

---Refazendo numeração Controle de Entrada - Matéria Prima ---
Set @Identity=(Select Ident_Current('CTEntrada_PQC'))

DBCC CheckIdent('CTEntrada_PQC',Reseed,@Identity)

---Refazendo numeração Controle de Produção - Moinho ---
Set @Identity=(Select Ident_Current('CTProducao_Moinho'))

DBCC CheckIdent('CTProducao_Moinho',Reseed,@Identity)

---Refazendo numeração Controle de Entrada - Recebimento - Látex ---
Set @Identity=(Select Ident_Current('CTEntrada_Recebimento_Látex'))

DBCC CheckIdent('CTEntrada_Recebimento_Latatex',Reseed,@Identity)

---Refazendo numeração Controle de Produção - PVM ---
Set @Identity=(Select Ident_Current('CTProducao_PVM'))

DBCC CheckIdent('CTProducao_PVM',Reseed,@Identity)
Go