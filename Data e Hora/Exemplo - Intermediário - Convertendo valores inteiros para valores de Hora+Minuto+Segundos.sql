/* 
  
Example:  Where Time Is Given In Seconds 
   
Output:     In “Day(s) : Hour(s) : Minute(s) : Second(s)” Format

*/


DECLARE @Seconds INT = 86200;
SELECT CONVERT(VARCHAR(12), @Seconds / 60 / 60 / 24) 
+ ':' + CONVERT(VARCHAR(12), @Seconds / 60 / 60 % 24) 
+ ':' + CONVERT(VARCHAR(2), @Seconds / 60 % 60) 
+ ':' + CONVERT(VARCHAR(2), @Seconds % 60) AS ' Day(s) : Hour(s) : Minute(s) : Second(s) '

GO


DECLARE @Seconds INT = 86200;

SELECT CONVERT(VARCHAR(12), @Seconds / 60 / 60 / 24) AS ' Day(s) '
,+ CONVERT(VARCHAR(12), @Seconds / 60 / 60 % 24) AS ' Hour(s) '
,+ CONVERT(VARCHAR(2), @Seconds / 60 % 60) AS ' Minute(s) '
,+ CONVERT(VARCHAR(2), @Seconds % 60) AS ' Second(s) '

GO



/* 
  Example: Where Time Given In Seconds is Higher than a Day 
*/


DECLARE @Seconds INT = 90400;
SELECT CONVERT(VARCHAR(12), @Seconds / 60 / 60 / 24) AS ' Day(s) '
,+ CONVERT(VARCHAR(12), @Seconds / 60 / 60 % 24) AS ' Hour(s) '
,+ CONVERT(VARCHAR(2), @Seconds / 60 % 60) AS ' Minute(s) '
,+ CONVERT(VARCHAR(2), @Seconds % 60) AS ' Second(s) '

GO



/* 
   Example: Where Time Given In Seconds is Higher than a 365 Days


*/


DECLARE @Seconds INT = 31555000;
SELECT CONVERT(VARCHAR(12), @Seconds / 60 / 60 / 24) AS ' Day(s) '
,+ CONVERT(VARCHAR(12), @Seconds / 60 / 60 % 24) AS ' Hour(s) '
,+ CONVERT(VARCHAR(2), @Seconds / 60 % 60) AS ' Minute(s) '
,+ CONVERT(VARCHAR(2), @Seconds % 60) AS ' Second(s) '

GO 
