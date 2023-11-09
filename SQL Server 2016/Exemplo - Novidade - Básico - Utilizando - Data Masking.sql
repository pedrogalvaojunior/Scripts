CREATE TABLE DDM_Questions
( myemail VARCHAR(300) MASKED WITH (FUNCTION='email()')
)
GO
INSERT dbo.DDM_Questions
        ( myemail )
    VALUES
        ( '@dog.com'  -- myemail
          );
GO
CREATE USER ddmtest WITHOUT LOGIN;
GO
GRANT SELECT ON dbo.DDM_Questions TO ddmtest;
GO
EXECUTE AS USER = 'ddmtest'
SELECT * FROM dbo.DDM_Questions;
GO