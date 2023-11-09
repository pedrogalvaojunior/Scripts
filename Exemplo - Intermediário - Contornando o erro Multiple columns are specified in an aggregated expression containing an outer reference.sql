Create Table Car 
(N_state varchar(20), 
 City varchar (20), 
 Cars int) 
Go

Insert Into Car 
 values('California', 'Los Angeles',1000),
       ('Ohio', 'Columbus', 300), ('Texas', 'Austin',400), 
       ('Florida', 'Miami',800), ('Florida', 'Orlando',200)
Go

-- Estourando o erro, quantidade de colunas retornadas não atende a quantidade de colunas declaradas --
Select *, 
 (Select sum(case 
             when c1.N_state=c2.N_state Then cars 
			 else 0 end) 
  from car c2) as bb 
from car c1

-- Exemplo 1 - Utilizando CTE - Contornando o erro --
;with CTE 
As
( 
 Select *, (Select sum(cars) from car) as bb 
 from car) 
Select *, cars, bb, cars/bb as cc from cte 

-- Exemplo 2 - Select com a cláusula Over() --
Select *, sum(cars) over (partition by N_state) as bb 
from car c1