SELECT

object_name As Servidor,

instance_name As Banco,

cntr_value As [Transações por Segundo]

FROM sysperfinfo

WHERE counter_name = 'Transactions/sec'
