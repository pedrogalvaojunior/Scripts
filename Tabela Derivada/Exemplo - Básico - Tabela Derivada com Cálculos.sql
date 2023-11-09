select 
 sum(num1) AS S1,
 sum(num2) AS S2,
 sum(num1) + sum(num2) AS S3,
 sum(num1 + num2) AS S4
 from
  (
   select cast('1' as int) as num1, cast('2' as int) as num2
   union all
   select '1' as num1, '' as num2
   union all
   select '1' as num1, NULL as num2
   union all
   select NULL as num1, 2 as num2
   ) as t