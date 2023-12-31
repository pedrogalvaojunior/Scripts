CREATE VIEW [dbo].[viw_getdate]
AS
SELECT GETDATE() AS GetDate
Go
----------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[Calculate_Age] 
----------------------------------------------------------------------------------
--        This function calculate the age (in years) according to a date of birth. 
--        Due to the fact that a function cannot use the getdate() function, we need
--        to create the view (viw_getdate) that reads the getdate() value.
----------------------------------------------------------------------------------
--    Created By : Ala'a Al-Zaghal
--    Created On : 2006-Aug-13
-- Modified By: Maysarah Abu-Laban 
-- Modified On: 2007-Feb-21
----------------------------------------------------------------------------------
    (
    @DOB datetime -- date of birth
    )
RETURNS tinyint

AS
BEGIN

    DECLARE @Year_Diff smallint
    DECLARE @GetDate datetime
    -----------------------------------
    SELECT @GetDate = [getdate] FROM viw_getdate
    SELECT @Year_Diff = DATEDIFF(year,@DOB,@GetDate) 

    IF Month(@GetDate) > Month(@DOB) RETURN @Year_Diff
    IF Month(@GetDate) < Month(@DOB) RETURN @Year_Diff - 1
    IF Day(@GetDate) >= Day(@DOB) RETURN @Year_Diff    -- Here, months are the same
    -- ELSE
    RETURN @Year_Diff - 1 

END