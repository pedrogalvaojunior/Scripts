DECLARE @a INT= 0; 

DECLARE @b INT= 0; 



CREATE TABLE #tmpPrice ( Value INT ); 



SET @a = ( SELECT 

              Value 

            FROM 

              #tmpPrice 

         ); 

SELECT 

    @b = Value 

  FROM 

    #tmpPrice; 



SELECT 

    @a AS a 

  , @b AS b; 