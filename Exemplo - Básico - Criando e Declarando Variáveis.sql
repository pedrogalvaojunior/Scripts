DECLARE @Var int
SET @Var = 10
PRINT @Var
/* ***************************************** */
DECLARE @Var int
SET @Var = 11
IF @Var <= 10
   Print 'N�mero pequeno'
ELSE 
   Print 'N�mero grande'
/* ***************************************** */
DECLARE @Var int
SET @Var = 101
IF @Var < 10
   Print 'N�mero pequeno'
ELSE  IF @Var = 10
   Print 'Dez'
ELSE
   Print 'N�mero grande'
/* ***************************************** */
DECLARE @Var int
SET @Var = 1010
IF @Var < 10
begin
   Print 'N�mero pequeno'
   Print 'N�mero menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'N�mero m�dio'
end
ELSE
begin
   Print 'N�mero grande'
   Print 'N�mero maior do que dez'
end

/* ***************************************** */
CREATE PROCEDURE P_Primeira
AS
DECLARE @Var int
SET @Var = 1010
IF @Var < 10
begin
   Print 'N�mero pequeno'
   Print 'N�mero menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'N�mero m�dio'
end
ELSE
begin
   Print 'N�mero grande'
   Print 'N�mero maior do que dez'
end
/* ********************************************** */
Exec P_Primeira 
/* ***************************************** */
ALTER PROCEDURE P_Primeira
@Var int
AS

IF @Var < 10
begin
   Print 'N�mero pequeno'
   Print 'N�mero menor do que dez'
end
ELSE  IF @Var = 10
begin
   Print 'Dez'
   Print 'N�mero m�dio'
end
ELSE
begin
   Print 'N�mero grande'
   Print 'N�mero maior do que dez'
end
/* ********************************************** */
Exec P_Primeira 10
/* ********************************************** */
