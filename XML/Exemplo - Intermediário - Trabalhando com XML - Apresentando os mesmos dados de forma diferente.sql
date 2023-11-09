create table #customers (
 id int,
 customer varchar(50)
)
insert into #customers values (1,'John')
insert into #customers values (2,'Lyss')
insert into #customers values (3,'Jack')
insert into #customers values (4,'David')
insert into #customers values (5,'Anne')
insert into #customers values (6,'Victoria')

a)
SELECT 1 AS tag,
NULL AS parent,
id AS [customers!1!id],
customer AS [customers!2!customer]
FROM #customers AS customersa
UNION ALL
SELECT 2 AS tag,
1 AS parent,
id AS [customers!1!id],
customer AS [customers!2!customer]
FROM #customers AS customersb
ORDER BY [customers!2!customer] DESC,parent
FOR XML EXPLICIT, ROOT ('customers')


B)
SELECT id AS [customers/@id],
customer AS [customers/customers/@customer]
FROM #customers AS customesra
ORDER BY customer DESC
FOR XML PATH(''),ROOT('customers')


C)
SELECT customersa.id AS [customers.id],
customersb.customer AS [customers.customer]
FROM #customers AS customersa
INNER JOIN #customers AS customersb ON customersb.id=customersa.id
ORDER BY customersa.customer DESC
FOR XML AUTO, ROOT('customers')


D)
DECLARE @x AS XML

SET @x=(
 SELECT id, customer
 FROM #customers AS customersa
 FOR XML RAW('customer'),ROOT('customers'),TYPE
 )

SELECT @x.query('
 for $e in customers/customer
 order by $e/@customer descending
 return <customers id="{$e/@id}">
 <customers customer="{$e/@customer}">
 </customers>
 </customers>')
FOR XML RAW('customers')
