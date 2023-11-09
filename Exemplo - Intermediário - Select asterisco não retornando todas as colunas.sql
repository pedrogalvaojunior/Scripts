-- Exemplo 1 --
DROP TABLE #temp;

CREATE TABLE #temp (
	RowID INT IDENTITY PRIMARY KEY CLUSTERED,
	Name VARCHAR(25),
	Column1 INT SPARSE,
	Column2 INT SPARSE,
	Column3 INT SPARSE,
	Column4 INT SPARSE,
	ColumnSet XML COLUMN_SET FOR ALL_SPARSE_COLUMNS);

INSERT INTO #temp (Name, Column1) VALUES ('Row1', 1);
INSERT INTO #temp (Name, Column1, Column2) VALUES ('Row2', 2, 2);
INSERT INTO #temp (Name, Column1, Column2, Column3) VALUES ('Row3', 3, 3, 3);
INSERT INTO #temp (Name, Column1, Column2, Column3, Column4) VALUES ('Row4', 4, 4, 4, 4);
INSERT INTO #temp (Name, Column1, Column3) VALUES ('Row5', 5, 5);
INSERT INTO #temp (Name, Column3, Column4) VALUES ('Row6', 6, 6);

SELECT * FROM #temp;

-- Exemplo 2 --
DROP TABLE #temp;

CREATE TABLE #temp (
	RowID INT IDENTITY PRIMARY KEY CLUSTERED,
	Name VARCHAR(25),
	Column1 INT SPARSE,
	Column2 INT SPARSE,
	Column3 INT SPARSE,
	Column4 INT SPARSE);	

INSERT INTO #temp (Name, Column1) VALUES ('Row1', 1);
INSERT INTO #temp (Name, Column1, Column2) VALUES ('Row2', 2, 2);
INSERT INTO #temp (Name, Column1, Column2, Column3) VALUES ('Row3', 3, 3, 3);
INSERT INTO #temp (Name, Column1, Column2, Column3, Column4) VALUES ('Row4', 4, 4, 4, 4);
INSERT INTO #temp (Name, Column1, Column3) VALUES ('Row5', 5, 5);
INSERT INTO #temp (Name, Column3, Column4) VALUES ('Row6', 6, 6);

SELECT * FROM #temp;