-- Exemplo 1 – Utilizando a claúsula JSON Auto --
Select Top 20 
             AddressID, AddressLine1, 
             City, PostalCode, 
			 ModifiedDate 
from [Person].[Address]
For JSON Auto
Go

-- Exemplo 2 – Utilizando a claúsula JSON Path --
Select Top 5 
             AddressID, AddressLine1, 
             City, PostalCode, 
	 ModifiedDate 
from [Person].[Address]
For JSON Path
Go

-- Exemplo 3 – Utilizando a claúsula JSON Path em conjunto com uma variável –
DECLARE @MyJson as NVARCHAR(MAX)
SET @MyJson = (SELECT 'Pedro' as Nome, 'Galvão' as Sobrenome,
                     35 as Idade, Getdate() as DataAtual
                     FOR JSON PATH)

Print (@MyJson)

-- Exemplo 4 – Utilizando a claúsula JSON Root –
Select Top 20
             AddressID As 'ID',
	 AddressLine1 As 'AdressLine',
            City As 'City',
	 PostalCode As 'Cep', 
	ModifiedDate As 'Data Modificação'
from [Person].[Address]
For JSON Path, Root('MyJSON')
Go

-- Exemplo 1 – Utilizando a função ISJSON –
CREATE TABLE MyTable(
   Id int, 
   jsonCol1 varchar(MAX) CHECK (ISJSON(jsonCol1)>0),
   jsonCol2 varchar(4000));
ALTER TABLE MyTable
ADD CONSTRAINT jsonCol2_is_json CHECK (ISJSON(jsonCol2) > 0);
GO

SELECT id, json_col
FROM tab1
WHERE ISJSON(json_col) > 0
GO

-- Exemplo 2 – Utilizando a função JSON_VALUE –
Declare @VarJSON NVarchar(400)
Set @VarJSON = 
N'{
    "info":{  
      "type":1,
      "address":{  
        "town":"Bristol",
        "county":"Avon",
        "country":"England"
      },
      "tags":["Sport", "Water polo"]
   },
   "type":"Basic"
}'

SELECT FirstName, LastName, 
       JSON_VALUE(jsonInfo, '$.info.address[0].town') AS Town
FROM Person.Person
WHERE JSON_VALUE(jsonInfo, '$.info.address[0].state') like 'US%'
ORDER BY JSON_VALUE(jsonInfo, '$.info.address[0].town')
Go

-- Exemplo 3 – Utilizando a função JSON_Query –
Declare @jsoninfo nvarchar(400)
Set @jsoninfo = 
N'{
    "info":{  
      "type":1,
      "address":{  
        "town":"Bristol",
        "county":"Avon",
        "country":"England"
      },
      "tags":["Sport", "Water polo"]
   },
   "type":"Basic"
}'

SELECT FirstName, LastName, 
       JSON_QUERY(@jsoninfo, '$.info.address') AS Address
FROM Person.Person
ORDER BY LastName
Go

-- Exemplo 4 – Utilizando a função OPENJSON –
SELECT * FROM OPENJSON('["Brasil", 
                                                    "United Kingdom", 
      "United States", 
      "Índia", 
      "Singapore",
      "Marrocos",
      "Suriname"]')
Go

-- Exemplo 5 – Utilizando a função OPENJSON para transformar JSON Texto em uma relational Table –
Declare @JSalestOrderDetails NVarchar(4000)

Set @JSalestOrderDetails = 
'{"OrdersArray": [
   {"Number":1, "Date": "8/10/2012", "Customer": "Adventure works", "Quantity": 1200},
   {"Number":4, "Date": "5/11/2012", "Customer": "Adventure works", "Quantity": 100},
   {"Number":6, "Date": "1/3/2012", "Customer": "Adventure works", "Quantity": 250},
   {"Number":8, "Date": "12/7/2012", "Customer": "Adventure works", "Quantity": 2200}
]}'

SELECT Number, Customer, Date, Quantity_
 FROM OPENJSON (@JSalestOrderDetails, '$.OrdersArray')
 WITH (
        Number varchar(200), 
        Date datetime,
        Customer varchar(200),
        Quantity int
 ) AS OrdersArray
Go

-- Exemplo 6 – Trabalhando com índices e dados JSON --
CREATE TABLE SalesOrderRecord 
( Id int PRIMARY KEY IDENTITY,
  OrderNumber NVARCHAR(25) NOT NULL,
  OrderDate DATETIME NOT NULL,
  JOrderDetails NVARCHAR(4000),
  Quantity AS CAST(JSON_VALUE(JOrderDetails, '$.Order.Qty') AS int),
  Price AS JSON_VALUE(JOrderDetails, '$.Order.Price'))
 GO


CREATE INDEX idxJson ON SalesOrderRecord(Quantity) INCLUDE (Price);
Go
