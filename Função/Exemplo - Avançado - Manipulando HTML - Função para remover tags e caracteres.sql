--SUBSTITUI PARTE DAS TAGS HTML ENCONTRADAS
--PARA TAGS "DIFERENCIADAS", SER� NECESS�RIO O AJUSTE PONTUAL
CREATE FUNCTION dbo.RemoveTagHTML(@HTML VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	SET @HTML = REPLACE(@HTML, '<br>', CHAR(13) + char(10))
	SET @HTML = REPLACE(@HTML, '<p>', CHAR(13) + char(10))

	DECLARE @Inicio INT	 = CHARINDEX('<',@HTML)
	DECLARE @Fim INT	 = CHARINDEX('>',@HTML, CHARINDEX('<', @HTML))
	DECLARE @Tamanho INT = (@Fim - @Inicio) + 1

	WHILE @Inicio > 0 AND @Fim > 0 AND @Tamanho > 0
		BEGIN
		SET @HTML = STUFF(@HTML,@Inicio,@Tamanho,'')

		SELECT	@Inicio = CHARINDEX('<',@HTML),
				@Fim	= CHARINDEX('>',@HTML,CHARINDEX('<',@HTML))


		SET @Tamanho = (@Fim - @Inicio) + 1
		END

	RETURN LTRIM(RTRIM(@HTML))
END
GO


--UTILIZE ESTA FUN��O COMO UMA BIBLIOTECA DE SUBSTITUI��O DE CARACTERES HTML
CREATE FUNCTION dbo.ConverteCaracteresHTML(@HTML varchar(8000))
RETURNS varchar(MAX) AS
BEGIN

	SET @HTML = REPLACE(@HTML, '&ccedil;', '�')
	SET @HTML = REPLACE(@HTML, '&atilde;', '�')
	SET @HTML = REPLACE(@HTML, '&aacute;', '�')
	SET @HTML = REPLACE(@HTML, '&uacute;', '�')
	SET @HTML = REPLACE(@HTML, '&otilde;', '�')
	SET @HTML = REPLACE(@HTML, '&acirc;', '�')
	SET @HTML = REPLACE(@HTML, '&eacute;', '�')

	RETURN LTRIM(RTRIM(@HTML))
END
GO

DECLARE @HTML_CONVERTIDO	VARCHAR(8000)

SELECT @HTML_CONVERTIDO = dbo.RemoveTagHTML('Solicita&ccedil;&atilde;o fechada.<br>Detalhes:<br><p> n&uacute;mero m&aacute;ximo de conex&otilde;es simult&acirc;neas, o usu&aacute;rio recebe a msg:</p>
<p><font color="#0000ff" size="2"><strong>No momento n&atilde;o h&aacute; disponibilidade de conex&atilde;o.</strong></font></p>
<p><font color="#0000ff" size="2"><strong>Tente novamente.</strong></font></p>
<p><font color="#000000" size="2">aguardar , at&eacute;')

SELECT dbo.ConverteCaracteresHTML(@HTML_CONVERTIDO);
GO