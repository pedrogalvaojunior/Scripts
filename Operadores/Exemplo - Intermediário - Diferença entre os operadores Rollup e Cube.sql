-- The Difference Between Rollup and Cube --
Create Table Funcionarios
(Codigo Int Primary Key,
 Nome VarChar(50) Not Null,
 Sexo VarChar(50) Not Null,
 Salario Int Not Null,
 Departamento VarChar(50) Not Null)
Go

Insert Into Funcionarios
  Values
  (1, 'David', 'Male', 5000, 'Sales'),
  (2, 'Jim', 'Female', 6000, 'HR'),
  (3, 'Kate', 'Female', 7500, 'IT'),
  (4, 'Will', 'Male', 6500, 'Marketing'),
  (5, 'Shane', 'Female', 5500, 'Finance'),
  (6, 'Shed', 'Male', 8000, 'Sales'),
  (7, 'Vik', 'Male', 7200, 'HR'),
  (8, 'Vince', 'Female', 6600, 'IT'),
  (9, 'Jane', 'Female', 5400, 'Marketing'),
  (10, 'Laura', 'Female', 6300, 'Finance'),
  (11, 'Mac', 'Male', 5700, 'Sales'),
  (12, 'Pat', 'Male', 7000, 'HR'),
  (13, 'Julie', 'Female', 7100, 'IT'),
  (14, 'Elice', 'Female', 6800,'Marketing'),
  (15, 'Wayne', 'Male', 5000, 'Finance')
Go

-- Simple Group By Clause --
Select Departamento,
               Sum(Salario) As Salario_Sum
From Funcionarios
Group By Departamento
Go

-- The Rollup Operator  --
Select Coalesce (Departamento, 'Total Geral --->') As Departamento,
              Sum(Salario) As Salario_Sum
From Funcionarios
Group By Rollup (Departamento)
Go

-- Finding Subtotals Using Rollup Operator --
Select Coalesce (Departamento, '-- Total --') As Departamento,
           Coalesce (Sexo,' *** Total ***') As Sexo,
           Sum(Salario) As Salario_Sum
From Funcionarios
Group By Rollup (Departamento, Sexo)
Go

-- The CUBE Operator  --
Select Coalesce (Departamento, '-- Total --') As Departamento,
               Coalesce (Sexo,'*** Total ***') As Sexo,
               Sum(Salario) As Salario_Sum
From Funcionarios
Group By Cube (Departamento, Sexo)
Go