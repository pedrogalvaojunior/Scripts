SELECT

object_name As Servidor,

instance_name As Banco,

cntr_value As [Transa��es por Segundo]

FROM sysperfinfo

WHERE counter_name = 'Transactions/sec'
