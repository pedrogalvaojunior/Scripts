IF OBJECT_ID('dbo.wages') IS NOT NULL
    DROP TABLE wages;
GO
CREATE TABLE dbo.wages
(
    emp_id        tinyint   identity,
    hourly_wage   decimal   NULL,
    salary        decimal   NULL,
    commission    decimal   NULL,
    num_sales     tinyint   NULL
);
GO
INSERT dbo.wages (hourly_wage, salary, commission, num_sales)
VALUES
    (10.00, NULL, NULL, NULL),
    (20.00, NULL, NULL, NULL),
    (30.00, NULL, NULL, NULL),
    (40.00, NULL, NULL, NULL),
    (NULL, 10000.00, NULL, NULL),
    (NULL, 20000.00, NULL, NULL),
    (NULL, 30000.00, NULL, NULL),
    (NULL, 40000.00, NULL, NULL),
    (NULL, NULL, 15000, 3),
    (NULL, NULL, 25000, 2),
    (NULL, NULL, 20000, 6),
    (NULL, NULL, 14000, 4);
GO
SET NOCOUNT OFF;
GO
SELECT CAST(COALESCE(hourly_wage * 40 * 52, salary, commission * num_sales) AS money) AS 'Total Salary',
       COALESCE(hourly_wage * 40 * 52,salary,commission * num_sales) As 'Total Salary II',
	   (hourly_wage * 40 * 52),
	   salary,
	   (commission * num_sales) As 'Total Salary III'
FROM dbo.wages
ORDER BY 'Total Salary';
GO