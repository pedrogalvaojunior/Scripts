USE master;
GO

-- Listing 1: Setting up the initial test environment --
IF DB_ID('ClientDB') IS NOT NULL
DROP DATABASE ClientDB;
GO

CREATE DATABASE ClientDB;
GO

USE ClientDB;
GO

IF OBJECT_ID('ClientInfo') IS NOT NULL
DROP TABLE ClientInfo;
GO

CREATE TABLE ClientInfo
(
  ClientID INT PRIMARY KEY IDENTITY,
  Info XML
);

INSERT INTO ClientInfo (Info)
VALUES
(
 '<People>
    <Person id="1234">
      <FirstName>John</FirstName>
      <LastName>Doe</LastName>
    </Person>
    <Person id="5678">
      <FirstName>Jane</FirstName>
      <LastName>Doe</LastName>
    </Person>
    <Person id="2468">
      <FirstName>John</FirstName>
      <LastName>Smith</LastName>
    </Person>
    <Person id="1357">
      <FirstName>Jane</FirstName>
      <LastName>Smith</LastName>
    </Person>
  </People>'
);

Select * from ClientInfo

-- Listing 2: Creating a function that returns XML data --
IF OBJECT_ID('udfClient') IS NOT NULL
DROP FUNCTION udfClient;
GO

CREATE FUNCTION udfClient (@ClientID INT)
RETURNS XML
AS BEGIN
RETURN
(
  SELECT Info
  FROM ClientInfo
  WHERE ClientID = @ClientID
)
END;
GO

-- Listing 3: Testing the udfClient user-defined function --
SELECT dbo.udfClient(1);

-- Listing 4: Using the query() method when calling your function --
SELECT dbo.udfClient(1).query('/People/Person[@id=1234]/FirstName');

-- Listing 5: Using the value() method when calling your function --
SELECT dbo.udfClient(1).value('(/People/Person[@id=5678]/FirstName)[1]', 'varchar(20)') AS FirstName;

-- Listing 6: Using the value() and nodes() methods within your function --
IF OBJECT_ID('udfFullName') IS NOT NULL
DROP FUNCTION udfFullName;
GO

CREATE FUNCTION udfFullName (@ClientID INT)
RETURNS TABLE
AS
RETURN
(
  SELECT Person.value('concat(./FirstName[1], " ", ./LastName[1])','varchar(50)') AS FullName
  FROM ClientInfo CROSS APPLY Info.nodes('/People/Person') AS People(Person)
  WHERE ClientID = @ClientID
);
GO

-- Listing 7: Testing the udfFullName user-defined function --
SELECT * FROM dbo.udfFullName(1);

-- Listing 9: Creating a function that returns the number of people within an XML document --
IF OBJECT_ID('udfPersonCount') IS NOT NULL
DROP FUNCTION udfPersonCount;
GO

CREATE FUNCTION udfPersonCount (@ClientID INT)
RETURNS INT
AS BEGIN
RETURN
(
  SELECT Info.value('count(/People/Person)', 'int')
  FROM ClientInfo
  WHERE ClientID = @ClientID
)
END;
GO

-- Listing 10: Testing the udfPersonCount user-defined function -- 
SELECT dbo.udfPersonCount(1) AS PersonCount;

-- Listing 11: Using the udfPersonCount function to create a calculated column --
ALTER TABLE ClientInfo
ADD PersonCount AS dbo.udfPersonCount(ClientID);
GO

-- Listing 12: Verifying the data in the PersonCount calculated column --
SELECT PersonCount FROM ClientInfo
WHERE ClientID = 1;

-- Listing 13: Using the udfPersonCount function in a check constraint --
ALTER TABLE ClientInfo WITH NOCHECK 
 ADD CONSTRAINT ck_count CHECK (dbo.udfPersonCount(ClientID) > 1);
  
-- Listing 14: Inserting a single <Person> instance into the Info column --
INSERT INTO ClientInfo (Info)
VALUES
(
 '<People>
    <Person id="1234">
      <FirstName>John</FirstName>
      <LastName>Doe</LastName>
    </Person>
  </People>'
);

-- Listing 16: Inserting two <Person> instances into the Info column --
INSERT INTO ClientInfo (Info)
VALUES
(
 '<People>
    <Person id="1234">
      <FirstName>John</FirstName>
      <LastName>Doe</LastName>
    </Person>
    <Person id="5678">
      <FirstName>Jane</FirstName>
      <LastName>Doe</LastName>
    </Person>
  </People>'
);

-- Listing 17: Verifying that a second row as been added to the ClientInfo table --
SELECT * FROM ClientInfo;