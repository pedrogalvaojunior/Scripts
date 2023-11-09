-- Exemplo 1: --

SELECT P.partition_id, 
             OBJECT_NAME(P.object_id) As ObjectName, 
             U.allocation_unit_id,
             SU.First_Page,
             SU.Root_Page,
             SU.First_IAM_Page    
From Sys.Partitions As P INNER JOIN Sys.Allocation_Units As U 
                                  ON P.hobt_id = U.container_id
                                 Inner Join Sys.system_internals_allocation_units SU
                                  On u.allocation_unit_id = su.allocation_unit_id
-- Exemplo 2: --

SELECT SIP.partition_id, 
             OBJECT_NAME(SIP.object_id) As ObjectName, 
             sip.rows,
             SU.First_Page,
             SU.Root_Page,
             SU.First_IAM_Page    
From Sys.system_internals_partitions As SIP Inner Join Sys.system_internals_allocation_units SU
                                  On sip.partition_id = su.allocation_unit_id

