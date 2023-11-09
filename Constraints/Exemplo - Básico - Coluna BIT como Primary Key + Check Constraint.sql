CREATE TABLE Test_Table (PK BIT PRIMARY KEY, Comment VARCHAR(10));

ALTER TABLE Test_Table ADD CONSTRAINT PK_check CHECK (PK <> 0);

INSERT INTO Test_Table VALUES (0, 'row 1');
INSERT INTO Test_Table VALUES (1, 'row 2');
INSERT INTO Test_Table VALUES (2, 'row 3');
INSERT INTO Test_Table VALUES (1, 'row 4');
INSERT INTO Test_Table VALUES (NULL, 'row 5');

SELECT * FROM Test_Table;

DROP TABLE Test_Table;