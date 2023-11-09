/* ********************************** */
/* Transações Explicitas                         */
/* ********************************** */
CREATE TABLE TESTE_UM
(
  Num int NOT NULL

  CONSTRAINT PK_TesteUM 
  PRIMARY KEY(Num) 
)

CREATE TABLE TESTE_Dois
(
  letra char(1) NOT NULL 

  CONSTRAINT PK_TesteDois
  PRIMARY KEY(letra) 
)

select * from Teste_Um
select * from Teste_Dois

/* *************************** */
BEGIN TRANSACTION 

 INSERT Teste_Um values(2)
 IF @@ERROR <> 0  
  BEGIN 
     ROLLBACK TRANSACTION  
     RETURN
  END

  SELECT * FROM Teste_Um

  INSERT Teste_Dois values('A') 
  IF @@ERROR <> 0
  BEGIN 
     ROLLBACK TRANSACTION   
     print 'VOltei aqui'
     RETURN
  END
COMMIT TRANSACTION
/* *************************** */
SELECT * FROM TESTE_UM
SELECT * FROM TESTE_DOIS
/* *************************** */
