CREATE FUNCTION dbo.fncDataPrevista(@Nr_Solicitacao_Os VARCHAR(50))
RETURNS VARCHAR(8000)
BEGIN
 DECLARE @cd_Categoria   VARCHAR(50)
 DECLARE @dt_Abertura  DATETIME
 DECLARE @hr_Abertura  DATETIME
 DECLARE @cd_Prioridade  VARCHAR(50)
 DECLARE @fl_Sabado   VARCHAR(1)
 DECLARE @fl_Domingo   VARCHAR(1)
 DECLARE @fl_Feriado   VARCHAR(1)
 DECLARE @fl_DataValida   VARCHAR(1)
 DECLARE @hr_HorarioInicial DATETIME
 DECLARE @hr_HorarioFinal DATETIME
 DECLARE @hr_diferenca  INT
 DECLARE @qt_Prioridade  INT
 DECLARE @qt_Congelada  INT
 DECLARE @qt_TempoTotal  INT
 DECLARE @qt_Feriado  INT
 DECLARE @dt_DataPrevistaFimOS  DATETIME
 DECLARE cur_tempoOS CURSOR FOR
 SELECT
  CONVERT(DATETIME,CONVERT(VARCHAR,dt_abertura,103) + ' ' + hr_abertura) as dt_abertura,
  cd_Categoria,
  cd_Prioridade
 FROM
  Registro_Atendimentos
 WHERE
  Nr_Solicitacao_Os = @Nr_Solicitacao_Os
 
 OPEN cur_tempoOS
 FETCH NEXT FROM cur_tempoOS INTO @dt_Abertura, @cd_Categoria, @cd_Prioridade
 WHILE @@FETCH_STATUS = 0
  BEGIN
   SELECT 
    @qt_Prioridade = qt_Horas3 * 60
   FROM 
    Prioridades
   WHERE
    cd_Prioridade = @cd_Prioridade
   SELECT 
    @fl_Sabado   = fl_Sabado, 
    @fl_Domingo   = fl_Domingo,
    @fl_Feriado  = fl_Feriado,
    @hr_HorarioInicial = CONVERT(VARCHAR,hr_HorarioInicial,108), 
    @hr_HorarioFinal = CONVERT(VARCHAR,hr_HorarioFinal,108) 
   FROM 
    Periodos_Ativos
   WHERE 
    cd_Categoria = @cd_Categoria
     
   SET @dt_DataPrevistaFimOS = @dt_Abertura
   SET @qt_TempoTotal = @qt_Prioridade
   SET @fl_DataValida = 1
           
   WHILE (@fl_DataValida = 1)
   BEGIN
    --Verifica se vai contar o Feriado  
    SELECT 
     @qt_Feriado   = COUNT(DT_FERIADO)
    FROM 
     CALENDARIOS 
    WHERE 
     DATEPART(d,DT_FERIADO)  = DATEPART(d,@dt_DataPrevistaFimOS)
     AND DATEPART(m,DT_FERIADO) = DATEPART(m,@dt_DataPrevistaFimOS)
    
    IF @qt_Feriado > 0 
    BEGIN
     IF @fl_Feriado = 'S' 
     BEGIN    
      IF DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS) < = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal)
      BEGIN
       SET @dt_DataPrevistaFimOS = DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS)
       SET @fl_DataValida = 0
      END
      ELSE
      BEGIN
       SET @hr_diferenca = DATEDIFF(ss, @dt_DataPrevistaFimOS, CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal))
       SET @qt_TempoTotal = @qt_TempoTotal - @hr_diferenca
       SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)
       SET @dt_DataPrevistaFimOS = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioInicial)
      END 
     END
     ELSE
     BEGIN
      SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)
     END
    END
    --Verifica se vai contar o Sábado
    ELSE IF DATEPART(dw,@dt_DataPrevistaFimOS) = '7' 
    BEGIN
     IF @fl_Sabado = 'S'
     BEGIN
      IF DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS) < = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal)
      BEGIN
       SET @dt_DataPrevistaFimOS = DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS)
       SET @fl_DataValida = 0
      END
      ELSE
      BEGIN
       SET @hr_diferenca = DATEDIFF(ss, @dt_DataPrevistaFimOS, CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal))
       SET @qt_TempoTotal = @qt_TempoTotal - @hr_diferenca
       SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)
       SET @dt_DataPrevistaFimOS = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioInicial)
      END 
     END
     ELSE
     BEGIN
      SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)     
     END
    END
    --Verifica se vai contar o Domingo
    ELSE IF DATEPART(dw,@dt_DataPrevistaFimOS) = '1' 
    BEGIN
     IF @fl_Domingo = 'S'
     BEGIN
      IF DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS) < = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal)
      BEGIN
       SET @dt_DataPrevistaFimOS = DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS)
       SET @fl_DataValida = 0
      END
      ELSE
      BEGIN
       SET @hr_diferenca = DATEDIFF(ss, @dt_DataPrevistaFimOS, CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal))
       SET @qt_TempoTotal = @qt_TempoTotal - @hr_diferenca
       SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)
       SET @dt_DataPrevistaFimOS = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioInicial)
      END 
     END
     ELSE
     BEGIN
      SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)
     END
    END
    -- Dias Normais
    ELSE
    BEGIN
     IF DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS) < = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal)
     BEGIN
      SET @dt_DataPrevistaFimOS = DATEADD(ss,@qt_TempoTotal, @dt_DataPrevistaFimOS)
      SET @fl_DataValida = 0
     END
     ELSE
     BEGIN
      SET @hr_diferenca = DATEDIFF(ss, @dt_DataPrevistaFimOS, CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioFinal))
      SET @qt_TempoTotal = @qt_TempoTotal - @hr_diferenca
      SET @dt_DataPrevistaFimOS = DATEADD(dd,1, @dt_DataPrevistaFimOS)     
      SET @dt_DataPrevistaFimOS = CONVERT(DATETIME,CONVERT(VARCHAR,@dt_DataPrevistaFimOS,103) + ' ' + @hr_HorarioInicial)
     END 
    END
   END 
    
  FETCH NEXT FROM cur_tempoOS INTO @dt_Abertura, @cd_Categoria, @cd_Prioridade
  END
 CLOSE cur_tempoOS
 DEALLOCATE cur_tempoOS
 
 RETURN CONVERT(VARCHAR, @dt_DataPrevistaFimOS,103) + ' ' + CONVERT(VARCHAR, @dt_DataPrevistaFimOS,108)
END
GO
