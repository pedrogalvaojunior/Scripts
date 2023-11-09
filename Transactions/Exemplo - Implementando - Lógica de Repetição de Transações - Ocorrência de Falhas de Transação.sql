-- Criando o Banco de Dados - RetryLogicTransaction --
Use Master
Go

Create Database RetryLogicTransaction 
On Primary
(NAME = N'RetryLogicTransaction_data', 
 FILENAME = N'C:\Bancos\RetryLogicTransaction.mdf', 
 SIZE = 10240KB, 
 MAXSIZE = UNLIMITED, 
 FILEGROWTH = 1024KB)
Log On 
(NAME = N'RetryLogicTransaction_Log', 
 FILENAME = N'C:\Bancos\RetryLogicTransaction_log.ldf', 
 SIZE = 1024KB, 
 MAXSIZE = UNLIMITED , 
 FILEGROWTH = 1024KB)
GO

-- Acessandor o Banco de Dados - RetryLogicTransaction --
Use RetryLogicTransaction
Go

-- Criando a Tabela - Clientes --
Use RetryLogicTransaction
GO

IF OBJECT_ID('dbo.Clientes','U') IS NOT NULL
  Drop Table dbo.Clientes
GO

Create Table dbo.Clientes
(
  ClienteId INT Not Null Identity(1,1) Primary Key Clustered,
  ClienteCode VarChar(10) Not Null,
  ClienteName VarChar(50) Not Null,
  ClienteAddress VarChar(50) Not Null,
  LastModified Datetime Not Null Default GetDate()  
)
GO

-- Simulando - DeadLock --
USE RetryLogicTransaction
GO

Begin Transaction
Insert Into dbo.Clientes (ClienteCode, ClienteName, ClienteAddress)
Values ('0215', 'Pedro Galvão', 'Rua Professor Tibério Justo da Silva')

Waitfor Delay '00:00:10'
Select * From dbo.Clientes
Commit Transaction

--Copiar o código e executar em outra query de forma simultânea --

-- Limpando a Tabela - Clientes --
USE RetryLogicTransaction
GO

TRUNCATE TABLE dbo.Clientes

-- Implementando - Lógica de Repetição de Transações --
USE RetryLogicTransaction
GO

DECLARE @RetryCount Int, @Success Bit

Set @RetryCount = 1 
Set @Success = 0

While @RetryCount <=3 AND @Success = 0
Begin
   Begin Try
      Begin Transaction
       -- This line is to show you on which execution we successfully commit.
       Select CAST (@ReTryCount AS VARCHAR(5)) +  'st. Attempt'
  
       Insert Into dbo.Clientes (ClienteCode, ClienteName, ClienteAddress)
       Values ('0215', 'Pedro Galvão', 'Rua Professor Tibério Justo da Silva')
 
       -- This Delay is set in order to simulate failure
       -- DO NOT USE IN REAL CODE!
       Waitfor Delay '00:00:05'
  
       Select * FROM dbo.Clientes
  
       Commit Transaction
  
       Select 'Success!'
       Set @Success = 1 -- To exit the loop
   End Try
 
    Begin Catch
      Rollback Transaction
 
      Select ERROR_NUMBER() AS [Error Number],
             ERROR_MESSAGE() AS [ErrorMessage];     
  
      -- Now we check the error number to only use reTry logic on the errors we are able to handle.
      -- You can set different handlers for different errors

      If ERROR_NUMBER() IN (1204, -- SqlOutOfLocks
                            1205, -- SqlDeadlockVictim
                            1222 -- SqlLockRequestTimeout
							)
      Begin
       Set @ReTryCount = @ReTryCount + 1  
       
	    -- This Delay is to give the blocking Transaction time to finish.
        -- So you need to tune according to your environment.
        
	   Waitfor Delay '00:00:02'  
      End 
      Else    
       Begin
       -- If we don't have a handler for current error then we Throw an exception and abort the loop
        Throw;
       End
    End Catch
End

--Copiar o código e executar em outra query de forma simultânea --