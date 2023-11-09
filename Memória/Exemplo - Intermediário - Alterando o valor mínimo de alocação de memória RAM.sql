-- Reconfigurando a valor inicial da propriedade valor m�nimo de mem�ria RAM --
SP_Configure 'show advanced options', 1;  -- Habilitando apresenta��o das configura��es avan�adas
Reconfigure With Override  
Go

SP_Configure 'min server memory', 8192; -- definindo 8Gbs  
Reconfigure With Override  
Go

SP_Configure 'show advanced options', 0;  -- Desabilitando apresenta��o das configura��es avan�adas
Reconfigure With Override 
GO

-- Identificando a aloca��o atual de mem�ria --
SELECT 
  physical_memory_in_use_kb/1024 AS sql_physical_memory_in_use_MB, 
    large_page_allocations_kb/1024 AS sql_large_page_allocations_MB, 
    locked_page_allocations_kb/1024 AS sql_locked_page_allocations_MB,
    virtual_address_space_reserved_kb/1024 AS sql_VAS_reserved_MB, 
    virtual_address_space_committed_kb/1024 AS sql_VAS_committed_MB, 
    virtual_address_space_available_kb/1024 AS sql_VAS_available_MB,
    page_fault_count AS sql_page_fault_count,
    memory_utilization_percentage AS sql_memory_utilization_percentage, 
    process_physical_memory_low AS sql_process_physical_memory_low, 
    process_virtual_memory_low AS sql_process_virtual_memory_low
FROM sys.dm_os_process_memory
Go