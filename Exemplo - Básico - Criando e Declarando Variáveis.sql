DECLARE @Var int
SET @Var = 10
PRINT @Var
/* ***************************************** */
DECLARE @Var int
SET @Var = 11
IF @Var <= 10
   Print 'Número pequeno'
ELSE 
   Print 'Número grande'
/* ***************************************** */
DECLARE @Var int
SET @Var = 101
IF @Var < 10
   Print 'Número pequeno'
ELSE  IF @Var = 10
   Print 'Dez'
ELSE
   Print 'Número grande'
/* ***************************************** */
DECLARE @Var int
SET @Var = 1010
IF @Var < 10
begin
   Print 'Número pequeno'
   Print 'Número menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'Número médio'
end
ELSE
begin
   Print 'Número grande'
   Print 'Número maior do que dez'
end

/* ***************************************** */
CREATE PROCEDURE P_Primeira
AS
DECLARE @Var int
SET @Var = 1010
IF @Var < 10
begin
   Print 'Número pequeno'
   Print 'Número menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'Número médio'
end
ELSE
begin
   Print 'Número grande'
   Print 'Número maior do que dez'
end
/* ********************************************** */
Exec P_Primeira 
/* ***************************************** */
ALTER PROCEDURE P_Primeira
@Var int
AS

IF @Var < 10
begin
   Print 'Número pequeno'
   Print 'Número menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'Número médio'
end
ELSE
begin
   Print 'Número grande'
   Print 'Número maior do que dez'
end
/* ********************************************** */
Exec P_Primeira 10
/* ********************************************** */
