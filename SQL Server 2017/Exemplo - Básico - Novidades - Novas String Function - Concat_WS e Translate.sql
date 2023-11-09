-- Concat_WS --
SELECT CONCAT_WS( ' - ', name, OBJECT_ID, create_date, modify_date) AS TablesInfo
FROM sys.tables

Select CONCAT_WS(' :: ', 'Pedro Antonio Galvão Junior', 'Idade:37', 'MVP desde 2007') As Info
Go

-- Translate --
Select 'x² – 10x + 24 = 0' As 'Antes'
Go

SELECT TRANSLATE('x² – 10x + 24 = 0', 'x', '4') As 'Depois'
Go

Select N'∆ = b² – 4 * a * c' As 'Antes'
Go

Select Translate(N'∆ = b² – 4 * a * c' , 'ac', '18') As 'Depois'
Go