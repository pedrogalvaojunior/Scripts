CREATE FUNCTION dbo.udfNomeProprio (
	@Nome varchar(250)
)
RETURNS varchar(250)
AS
BEGIN
	DECLARE @Pos tinyint = 1
	DECLARE @Ret varchar(250) = ''

WHILE (@Pos < LEN(@Nome) + 1)
  BEGIN
	IF @Pos = 1
	  BEGIN
		--FORMATA 1.LETRA DA "FRASE"
		SET @Ret += UPPER(SUBSTRING(@Nome, @Pos, 1))
	  END
	ELSE IF (SUBSTRING(@Nome, (@Pos-1), 1) = ' ' 
                AND SUBSTRING(@Nome, (@Pos+2), 1) <> ' ') AND (@Pos+1) <> LEN(@Nome)
	  BEGIN
		--FORMATA 1.LETRA DE "CADA INTERVALO""
		SET @Ret += UPPER(SUBSTRING(@Nome, @Pos, 1))
	  END
	ELSE
	  BEGIN
		--FORMATA CADA LETRA RESTANTE
		SET @Ret += LOWER(SUBSTRING(@Nome,@Pos, 1))
	  END

	SET @Pos += 1
  END

  RETURN @Ret
END
GO

SELECT dbo.udfNomeProprio('pedro antonio galvão junior')
GO