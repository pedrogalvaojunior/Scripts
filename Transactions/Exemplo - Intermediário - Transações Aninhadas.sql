CREATE Table TranTable(col varchar(3))
GO

BEGIN TRAN A
    INSERT INTO TranTable (col) Values ('abc')
    BEGIN TRAN B
        INSERT INTO TranTable (col) Values ('def')
        SAVE TRAN B
        BEGIN TRAN C
            INSERT INTO TranTable (col) Values ('ghi')
        COMMIT TRAN C
    ROLLBACK TRAN B
    INSERT INTO TranTable (col) Values ('xyz') 
COMMIT TRAN A
GO 

Select col from TranTable

GO

Drop TABLE TranTable 

GO 