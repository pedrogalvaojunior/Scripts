CREATE TABLE A ( x INT )

INSERT INTO A
    VALUES  ( 18 ),
            ( 20 ),
            ( 4 ),
            ( 1 ),
            ( 2 )

CREATE TABLE B ( Y INT )

INSERT INTO B
    VALUES  ( 1 ),
            ( 20 ),
            ( 2 ),
            ( 3 )

SELECT X AS 'Intersecting'
    FROM A
INTERSECT
SELECT Y
    FROM B