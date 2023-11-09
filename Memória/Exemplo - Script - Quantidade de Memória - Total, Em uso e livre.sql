Declare @memoriaservidor numeric(10,4), @memoriasql numeric(10,4)

Select 
    @memoriaservidor = (memoria.total_physical_memory_kb / 1024),
    @memoriasql = (memoria.available_physical_memory_kb / 1024)    
from sys.dm_os_sys_memory memoria

Select @memoriaservidor, @memoriasql
Go

;With CTEOsMemory
As
(
Select 
    (total_physical_memory_kb / 1024) as MemoriaFisicaTotal, 
    (available_physical_memory_kb / 1024) as MemoriaFisicaDisponivel
from sys.dm_os_sys_memory)
Select MemoriaFisicaTotal As 'Memória RAM Total em GBs',
       MemoriaFisicaDisponivel As 'Memória RAM Dispónivel em GBs',
       (MemoriaFisicaTotal-MemoriaFisicaDisponivel) As 'Memória RAM Alocada em GBs para uso'
From CTEOsMemory
Go


