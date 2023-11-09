CREATE EVENT SESSION [CounterTest] ON SERVER  

ADD EVENT sqlserver.login, 

ADD EVENT sqlserver.logout( 

    ACTION(sqlserver.client_hostname,sqlserver.database_name,sqlserver.username))  

ADD TARGET package0.event_counter 

WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF) 

GO 

ALTER EVENT SESSION [CounterTest] 

ON SERVER 

STATE=START; 

GO 



-- login and logout a few times 

GO 

-- query for data 

-- Query the Target 

SELECT 

    n.value('@name[1]', 'varchar(50)') AS Event 

  , n.value('@count[1]', 'int') AS EventCounts 

  FROM 

    ( SELECT 

          CAST(t.target_data AS XML) AS target_data 

        FROM 

          sys.dm_xe_sessions AS s 

        JOIN 

          sys.dm_xe_session_targets AS t 

        ON 

          t.event_session_address = s.address 

        WHERE 

          s.name = 'CounterTest' 

          AND t.target_name = 'event_counter' 

    ) AS tab 

  CROSS APPLY target_data.nodes('CounterTarget/Packages/Package/Event') AS q ( n ) 



GO 



DROP EVENT SESSION CounterTest ON SERVER; 

go 