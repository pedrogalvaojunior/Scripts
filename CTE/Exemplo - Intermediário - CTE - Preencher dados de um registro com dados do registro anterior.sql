DECLARE @Metas TABLE ( Data DATE, Meta INT );

INSERT INTO @Metas
        ( Data, Meta )
    VALUES  ( DATEFROMPARTS(2017, 03, 29), 50 ),
            ( DATEFROMPARTS(2017, 04, 11), 35 ),
            ( DATEFROMPARTS(2017, 04, 13), 50 );

DECLARE @Producao TABLE
    (
      Data DATE ,
      Quantidade INT
    );
	
INSERT INTO @Producao
        ( Data, Quantidade )
    VALUES  ( DATEFROMPARTS(2017, 04, 10), 49 ),
            ( DATEFROMPARTS(2017, 04, 11), 35 ),
            ( DATEFROMPARTS(2017, 04, 12), 36 ),
            ( DATEFROMPARTS(2017, 04, 13), 50 ),
            ( DATEFROMPARTS(2017, 04, 14), 50 );

WITH    DadosProduzidos
          AS ( SELECT P.Data ,
                    Quantidade = SUM(P.Quantidade)
                FROM @Producao AS P
                GROUP BY P.Data
             )
    SELECT D.Data ,
            [Produzido] = D.Quantidade ,
            Meta = ( SELECT TOP 1 M.Meta
                        FROM @Metas AS M
                        WHERE M.Data <= D.Data
                        ORDER BY M.Data DESC
                   )
        FROM DadosProduzidos D;