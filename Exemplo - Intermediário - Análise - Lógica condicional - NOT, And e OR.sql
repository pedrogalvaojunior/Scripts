DECLARE @Logic TABLE ( ID INT, Product VARCHAR(50) )

INSERT INTO @Logic
    VALUES  ( 1, 'Baseball Hat' ),
            ( 2, 'Bicycle' ),
            ( 3, 'Snowboard' ),
            ( 4, 'Goggles' ),
            ( 5, 'Shows' )

SELECT ID
    FROM @Logic
    WHERE Product = 'Bicycle' OR Product = 'Snowboard' AND ID = 4