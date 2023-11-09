CREATE TABLE t
    (
      col1 VARCHAR(8) NULL
    , col1Computed AS LEFT(col1, 4)
    , col2 VARCHAR(8) NOT NULL
    , col2Computed AS LEFT(col2, 4)
    , col3 CHAR(8) NULL
    , col3Computed AS LEFT(col3, 4)
    , col4 CHAR(8) NOT NULL
    , col4Computed AS LEFT(col4, 4)
    );

sp_help 't'