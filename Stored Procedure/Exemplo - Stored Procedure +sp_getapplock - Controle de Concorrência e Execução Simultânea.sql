USE [tempdb]
GO

Set ANSI_NULLS ON
Set QUOTED_IDENTIfIER ON
GO

Alter PROC dbo.critical_section_worker  @Wait_duration VarChar(30) = '00:01:00' -- default one minute
/* Performs a task in a critical section of code that can only be run
   by one session at a time. The task is simulated by a Wait  */
AS
Begin
Declare @rc Int = 0, -- return code
        @msg VarChar(2000)

Set @msg = Convert(VarChar,Getdate(), 114) + ' critical_section_worker starting'
Raiserror (@msg, 0, 1) With NoWait 

Begin Try
 Begin Tran

  Set @msg= Convert(VarChar,getdate(), 114) + ' requesting lock'
  Raiserror (@msg, 0, 1) With NoWait

  Exec @rc = sp_getapplock @Resource='CriticalSectionWorker', -- the resource to be locked
             @LockMode='Exclusive',  -- Type of lock
             @LockOwner='Transaction', -- Transaction or Session
             @LockTimeout = 15000 -- timeout in milliseconds, 15 seconds
                            
  Set @msg= Convert(VarChar,getdate(), 114) + ' sp_getapplock returned ' + Convert(VarChar(30), @rc) + ' -- '
            + Case 
			    When @rc < 0 Then 'Could not obtain the lock'  
		        Else 'Lock obtained'  
			  End
  Raiserror (@msg, 0, 1) With NoWait
  
  If @rc >= 0 
   Begin
    Set @msg= Convert(VarChar,getdate(), 114) + ' got lock starting critical work '
    Raiserror (@msg, 0, 1) With NoWait
  
    Waitfor Delay @Wait_duration -- Critical Work simulated by Waiting
  
    Commit Tran -- will release the lock
    Set @msg= Convert(VarChar,Getdate(), 114) + ' work complete released lock' 
    Raiserror (@msg, 0, 1) With NoWait
   End 
   Else 
    Begin
        
     Rollback tran
     Set @rc = 50000
    End
 End Try
 Begin Catch
 
  Set @msg = 'ERROR: ' + ERROR_MESSAGE() + ' at ' + Coalesce(ERROR_PROCEDURE(), '') + Coalesce (' line:' + Convert(VarChar(30), ERROR_LINE()), '')
            
  Raiserror (@msg, 0, 1) With NoWait -- ensure the message gets out                                 
 
  If @@Trancount > 1 
   Rollback Tran

  Raiserror (@msg, 16, 1)
 End catch

 Return @rc
End
GO