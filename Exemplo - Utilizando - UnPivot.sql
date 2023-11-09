-- Exemplo 1 --
CREATE TABLE dbo.CustomerPhones
(
  CustomerID INT PRIMARY KEY, -- FK
  Phone1 VARCHAR(32),
  Phone2 VARCHAR(32),
  Phone3 VARCHAR(32)
);

INSERT dbo.CustomerPhones (CustomerID, Phone1, Phone2, Phone3)
VALUES (1,'705-491-1111', '705-491-1110', NULL),
                (2,'613-492-2222', NULL, NULL),
                (3,'416-493-3333', '416-493-3330', '416-493-3339');
               
-- Forçando UnPivot sem utilizar o Operador UnPivot --
SELECT CustomerID, Phone = Phone1 
  FROM dbo.CustomerPhones WHERE Phone1 IS NOT NULL
UNION ALL
SELECT CustomerID, Phone = Phone2 
  FROM dbo.CustomerPhones WHERE Phone2 IS NOT NULL
UNION ALL
SELECT CustomerID, Phone = Phone3 
  FROM dbo.CustomerPhones WHERE Phone3 IS NOT NULL;

-- Utilizando o Operador UnPivot --
SELECT CustomerID, Phone
FROM
(
  SELECT CustomerID, Phone1, Phone2, Phone3 
  FROM dbo.CustomerPhones
) AS cp
UNPIVOT 
(
  Phone FOR Phones IN (Phone1, Phone2, Phone3)
) AS up;  


-- Exemplo 2 --
CREATE TABLE dbo.CustomerPhones2
(
  CustomerID INT PRIMARY KEY, -- FK
  Phone1 VARCHAR(32),
  PhoneType1 CHAR(4),
  Phone2 VARCHAR(32),
  PhoneType2 CHAR(4),
  Phone3 VARCHAR(32),
  PhoneType3 CHAR(4)
);

INSERT dbo.CustomerPhones2 VALUES
  (1,'705-491-1111', 'cell', '705-491-1110', 'home', NULL,NULL),
  (2,'613-492-2222', 'home', NULL, NULL, NULL, NULL),
  (3,'416-493-3333', 'work', '416-493-3330', 'cell',
     '416-493-3339', 'home');

-- Utilizando o Operador UnPivot --  
SELECT CustomerID, Phone, PhoneType
FROM 
(
  SELECT CustomerID, Phone, PhoneType,
    idp = SUBSTRING(Phones, LEN(Phones) - PATINDEX('%[^0-9]%', REVERSE(Phones)) + 2, 32),
    idpt = SUBSTRING(PhoneTypes, LEN(PhoneTypes) - PATINDEX('%[^0-9]%', REVERSE(PhoneTypes)) + 2, 32)
  FROM
  (
    SELECT CustomerID, Phone1, Phone2, Phone3,
           PhoneType1, PhoneType2, PhoneType3
    FROM dbo.CustomerPhones2
  ) AS cp
  UNPIVOT 
  (
    Phone FOR Phones IN (Phone1, Phone2, Phone3)
  ) AS p
  UNPIVOT
  (
    PhoneType FOR PhoneTypes IN (PhoneType1, PhoneType2, PhoneType3)
  ) AS pt
) AS x
WHERE idp = idpt;    