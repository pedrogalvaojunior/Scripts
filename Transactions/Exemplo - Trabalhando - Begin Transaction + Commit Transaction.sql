CREATE PROCEDURE P_DesPremio
@Codigo int
AS 
DECLARE @Valor decimal(10,2),
                   @Numero int

SELECT @Valor = Val_Ped,
                @Numero = Num_Ped
FROM Pedido
WHERE Num_Ped =
                   (SELECT MAX(Num_Ped) FROM Pedido
                    WHERE Cod_Func = @Codigo)

IF @Valor > 100.00
begin 
   BEGIN TRANSACTION

     INSERT Premio 
     VALUES(@Codigo,getdate(),@Valor  * 0.9,'0')

     IF @@ERROR <> 0
     begin
          ROLLBACK  TRANSACTION
          RETURN
     end

      UPDATE Pedido
      SET Val_Ped = Val_Ped * 0.9
      WHERE Num_Ped = @Numero

     IF @@ERROR <> 0
     begin
          ROLLBACK  TRANSACTION
          RETURN
     end

  COMMIT TRANSACTION
end
      