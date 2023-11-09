--Parte 1: --

--Declarando a varíavel @Buffers_EmUso
Declare @Buffers_EmUso Int;

/* Acumando o valor dos contadores na variável @Buffers_EmUso, filtrando pelo 
Object_Name=Buffer Manager e Counter_Name=Total Pages*/

Select @Buffers_EmUso = cntr_value From Sys.dm_os_performance_counters 
Where Rtrim(Object_name) LIKE '%Buffer Manager'
And counter_name = 'Total Pages';

-- Declarando a CTE Buffers_Pages para contagem de Buffers por página --
;With DB_Buffers_Pages AS
(
   SELECT database_id, Contagem_Buffers_Por_Pagina  = COUNT_BIG(*)
   From Sys.dm_os_buffer_descriptors
   Group By database_id
)

-- Retornando informações sobre os pools de Buffers por Banco de Dados com base na CTE DB_Buffers_Pages --
Select Case [database_id] 
            WHEN 32767 Then 'Recursos de Banco de Dados' Else DB_NAME([database_id]) 
           End As 'Banco de Dados',
          Contagem_Buffers_Por_Pagina,
          'Buffers em MBs por Banco' = Contagem_Buffers_Por_Pagina / 128,
          'Porcentagem de Buffers' = CONVERT(DECIMAL(6,3), Contagem_Buffers_Por_Pagina * 100.0 / @Buffers_EmUso)  
From DB_Buffers_Pages
Order By 'Buffers em MBs por Banco' Desc;

-- Parte 2: -- 
USE CRIPTOGRAFIA
GO

-- Declarando a CTE Buffers_Pages para retorno dos Objetos alocados em Pool --
;WITH DB_Buffers_Pages_Objetos AS
(
   Select
       SO.name As Objeto,
       SO.type_desc As TipoObjeto,
       COALESCE(SI.name, '') As Indice,
       SI.type_desc As TipoIndice,
       p.[object_id],
       p.index_id,
       AU.allocation_unit_id
   From sys.partitions AS P INNER JOIN sys.allocation_units AS AU
                                              ON p.hobt_id = au.container_id
                                             INNER JOIN sys.objects AS SO
                                              ON p.[object_id] = SO.[object_id]
                                             INNER JOIN sys.indexes AS SI
                                              ON SO.[object_id] = SI.[object_id]
                                              AND p.index_id = SI.index_id
   Where AU.[type] IN (1,2,3)
    And SO.is_ms_shipped = 0
)

-- Retornando informações sobre os pools de Buffers de Objetos por Banco de Dados com base na CTE DB_Buffers_Pages_Objetos --
Select Db.Objeto, Db.TipoObjeto  As 'Tipo Objeto', 
             Db.Indice, 
             Db.TipoIndice,
             COUNT_BIG(b.page_id) As 'Buffers Por Página',
             COUNT_BIG(b.page_id) / 128 As 'Buffers em MBs'
From DB_Buffers_Pages_Objetos Db INNER JOIN sys.dm_os_buffer_descriptors AS b
                                                ON Db.allocation_unit_id = b.allocation_unit_id
Where b.database_id = DB_ID()
Group By Db.Objeto, Db.TipoObjeto, Db.Indice, Db.TipoIndice
Order By 'Buffers Por Página' Desc, TipoIndice Desc;