-- Exemplo 1 --
Declare @HorasEmInteiro int

Set @HorasEmInteiro = 970000

-- Apresentando os valores separados --
Select (@HorasEmInteiro / 1000000) % 100 as Horas,
       (@HorasEmInteiro / 10000) % 100 as Minutos,
       (@HorasEmInteiro / 100) % 100 as Segundos,
       (@HorasEmInteiro % 100) * 10 as Miléssimos

-- Apresentando o valores sumarizados em horas, minutos e segundos --
Select dateadd(hour, (@HorasEmInteiro / 1000000) % 100,
       dateadd(minute, (@HorasEmInteiro / 10000) % 100,
       dateadd(second, (@HorasEmInteiro / 100) % 100,
       dateadd(millisecond, (@HorasEmInteiro % 100) * 10, cast('00:00:00' as Time(2)))))) As Hora
Go

-- Exemplo 2 --
-- Convertendo em segundos
DECLARE @Horas INT
SET @Horas = 97 -- Valores em segundos --
SELECT
(CASE WHEN LEN (CAST((@Horas / 3600) AS VARCHAR(2)))=2 
     THEN CAST((@Horas / 3600) AS VARCHAR(2)) 
     ELSE '0' +CAST((@Horas / 3600) AS VARCHAR(2)) END
+
CASE WHEN LEN (CAST(((@Horas % 3600) / 60) AS VARCHAR(2)))=2 
     THEN ':'+ CAST(((@Horas % 3600) / 60) AS VARCHAR(2)) 
     ELSE ':0' + CAST(((@Horas % 3600) / 60) AS VARCHAR(2)) END 
+
CASE WHEN LEN (CAST((@Horas % 60) AS VARCHAR(2)))=2 
     THEN ':'+ CAST((@Horas % 60) AS VARCHAR(2)) 
     ELSE ':0' + CAST((@Horas % 60) AS VARCHAR(2)) END) AS 'Horas'
Go
-- Milésimos de segundos --
DECLARE @TIME INT
SET @TIME = 24567 -- Valores em milésimos de segundos --
SELECT
(CASE WHEN LEN (CAST(((@TIME/1000) / 3600) AS VARCHAR(2)))=2 
     THEN CAST(((@TIME/1000) / 3600) AS VARCHAR(2)) 
     ELSE '0' +CAST(((@TIME/1000) / 3600) AS VARCHAR(2)) END
+
CASE WHEN LEN (CAST((((@TIME/1000) % 3600) / 60) AS VARCHAR(2)))=2 
     THEN ':'+ CAST((((@TIME/1000) % 3600) / 60) AS VARCHAR(2)) 
     ELSE ':0' + CAST((((@TIME/1000) % 3600) / 60) AS VARCHAR(2)) END 
+
CASE WHEN LEN (CAST(((@TIME/1000) % 60) AS VARCHAR(2)))=2 
     THEN ':'+ CAST(((@TIME/1000) % 60) AS VARCHAR(2)) 
     ELSE ':0' + CAST(((@TIME/1000) % 60) AS VARCHAR(2)) END
+
CASE WHEN LEN (CAST((@TIME % 1000) AS VARCHAR(3)))=3 
     THEN ':'+ CAST((@TIME % 1000) AS VARCHAR(3)) 
     WHEN LEN (CAST((@TIME % 1000) AS VARCHAR(3)))=2 
     THEN ':0'+ CAST((@TIME % 1000) AS VARCHAR(3))
     ELSE ':00' + CAST((@TIME % 1000) AS VARCHAR(3)) END) AS Time_In_HH_MM_SS_mmm
Go

-- Simplificando --
SELECT
  RIGHT('0' + CAST((@Horas / 3600) AS VARCHAR(2)), 2) + ':' +
  RIGHT('0' + CAST(((@Horas % 3600) / 60) AS VARCHAR(2)), 2) + ':' +
  RIGHT('0' + CAST((@Horas % 60) AS VARCHAR(2)), 2) AS 'Horas'
Go