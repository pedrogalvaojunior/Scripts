BEGIN TRY

    BEGIN TRAN

    INSERT INTO OBJETO VALUES (1, 'Primeira coluna', 'Primeira coluna');

    INSERT INTO OBJETO VALUES (2, null, 'Segunda coluna');

    INSERT INTO OBJETO VALUES (3, 'Terceira coluna', 'Terceira coluna');

    COMMIT TRAN;

END TRY

BEGIN CATCH

    SELECT ERROR_NUMBER() AS "ERROR_NUMBER",

           	ERROR_SEVERITY() AS "ERROR_SEVERITY",

	ERROR_STATE() AS "ERROR_STATE",

	ERROR_PROCEDURE() AS "ERROR_PROCEDURE",

	ERROR_LINE() AS "ERROR_LINE",

           	ERROR_MESSAGE() AS "ERROR_MESSAGE"

    RAISERROR('Erro na transação', 14, 1)

    ROLLBACK TRAN;

END CATCH; 
