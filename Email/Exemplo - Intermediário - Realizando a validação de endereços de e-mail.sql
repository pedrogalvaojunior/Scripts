USE tempdb
GO
CREATE TABLE Contacts (EmailAddress VARCHAR(100))
INSERT INTO Contacts (EmailAddress)
SELECT 'first@validemail.com'
UNION ALL
SELECT 'first@validemail'
UNION ALL
SELECT '@validemail.com'
UNION ALL
SELECT 'second@validemail.com'
UNION ALL
SELECT 'firstvalidemail.com'
GO

Next we will run following script which will only select the valid email address:
SELECT EmailAddress AS ValidEmail
FROM Contacts
WHERE EmailAddress LIKE '%_@__%.__%'
        AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', EmailAddress) = 0
GO

We can also use NOT condition in the WHERE clause and select all the invalid emails as well.
SELECT EmailAddress AS NotValidEmail
FROM Contacts
WHERE NOT EmailAddress LIKE '%_@__%.__%'
        AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', EmailAddress) = 0
GO