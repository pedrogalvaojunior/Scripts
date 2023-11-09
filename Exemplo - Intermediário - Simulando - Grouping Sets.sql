create table #T (Customer varchar(100),Year int,Sales money);

insert into #T (Customer, Year, Sales)values
('Jack', 2010, 10)
,('Jack', 2010, 15)
,('Bob', 2009, 5)
,('Dick',2011, 20);

-- Sem Grouping Sets --
SELECT NULL as customer, year, SUM(sales)FROM #T GROUP BY year
UNION ALL
SELECT customer, NULL as year, SUM(sales)FROM #T GROUP BY customer;

-- Com Grouping Sets --
SELECT customer, year, SUM(sales)FROM #T
GROUP BY GROUPING SETS ((customer), (year));