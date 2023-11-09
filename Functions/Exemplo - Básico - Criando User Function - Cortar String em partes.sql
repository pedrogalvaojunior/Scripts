CREATE FUNCTION fncCortaString(@txt VARCHAR(50), @txt_ini VARCHAR(50), @txt_fim VARCHAR(50))
RETURNS VARCHAR(50)
BEGIN
   RETURN
   (
	SUBSTRING(@txt, CHARINDEX(@txt_ini, @txt) + LEN(@txt_ini), (CHARINDEX(@txt_fim, @txt) - CHARINDEX(@txt_ini, @txt)) - LEN(@txt_ini))
   )
END

Select dbo.fncCortaString('SQL Server', 'SQL ', 'ver')