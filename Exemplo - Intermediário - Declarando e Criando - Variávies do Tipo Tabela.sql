 DECLARE @Users TABLE
    (
        UserID  INT PRIMARY KEY,
        UserName VARCHAR(50),
        FirstName VARCHAR(50),
        UNIQUE CLUSTERED (UserName,UserID)
    )

DECLARE @Users1 TABLE
    (
        UserID  INT PRIMARY KEY Nonclustered,
        UserName VARCHAR(50),
        FirstName VARCHAR(50),
        UNIQUE  Nonclustered (UserName,UserID)
    )


DECLARE @Users2 TABLE
    (
        UserID  INT Identity(1,1) PRIMARY KEY Nonclustered,
        UserName VARCHAR(50),
        FirstName VARCHAR(50),
		Teste UniqueIdentifier ROWGUIDCOL,
		Teste2 UniqueIdentifier ROWGUIDCOL
        UNIQUE NonCLUSTERED (UserName,UserID)
    )

DECLARE @Users TABLE
    (
        UserID  INT PRIMARY KEY,
        UserName VARCHAR(50),
        UNIQUE (UserName)
    )


DECLARE @Users TABLE
    (
        UserID  INT PRIMARY KEY,
        UserName VARCHAR(50),
        FirstName VARCHAR(50),
        UNIQUE CLUSTERED (UserName,UserID)
    )

DECLARE @Users TABLE
    (
        UserID  INT PRIMARY KEY,
        UserName VARCHAR(50),
        FirstName VARCHAR(50),
		Valor Int,
		Valor1 Int Check ((Valor1+Valor) > 1),
		Valor2 Int Check ((Valor2) > 1),
        UNIQUE CLUSTERED (UserName,UserID)
    )