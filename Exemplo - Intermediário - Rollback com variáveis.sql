DECLARE @salary INT = 1000
 BEGIN TRAN
 SELECT @salary = @salary * 2
 ROLLBACK
 SELECT @salary