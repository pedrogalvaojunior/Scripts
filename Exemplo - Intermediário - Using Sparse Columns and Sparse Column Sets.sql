CREATE TABLE dbo.Table1 (
    RowID INTEGER IDENTITY PRIMARY KEY CLUSTERED,
    DateTimeStamp DATETIME DEFAULT GETDATE(),
    Col1 INTEGER SPARSE,
    Col2 INTEGER SPARSE,
    Col3 INTEGER SPARSE,
    TblColumnSet XML COLUMN_SET FOR ALL_SPARSE_COLUMNS);

INSERT INTO dbo.Table1 (Col1) VALUES (1), (2);
INSERT INTO dbo.Table1 (Col2) VALUES (3), (4);
INSERT INTO dbo.Table1 (Col3) VALUES (5), (6);
INSERT INTO dbo.Table1 (TblColumnSet) VALUES ('<Col1>1</Col1><Col2>2</Col2><Col3>3</Col3>');

SELECT RowID, DateTimeStamp, Col1, Col2, Col3, TblColumnSet
FROM dbo.Table1;