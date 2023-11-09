CREATE TRIGGER T_Incfunc
ON Funcionario
FOR INSERT
AS
INSERT Premio
  SELECT Cod_Func,
                  getdate(),
                  200.00,
                  '0'
  FROM inserted
  WHERE SexoFunc = 'F'
/* ****************************************** */
CREATE TRIGGER T_Incfunc
ON Funcionario
FOR INSERT
AS

DECLARE @Sexo char(1),@Codigo int

SELECT @Sexo = Sexo_Func,
               @Codigo = Cod_Func
FROM Inserted

IF @Sexo = 'F'
	INSERT Premio
	VALUES(@Codigo,getdate(), 200.00,'0')
