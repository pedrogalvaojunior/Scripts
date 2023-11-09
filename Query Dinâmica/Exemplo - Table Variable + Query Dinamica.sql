--Variable for the T-SQL Statement
DECLARE @sql nvarchar(300);
SET @sql=N'INSERT INTO [AdventureWorks].[Production].[ScrapReason]
           ([Name]
           ,[ModifiedDate])
     VALUES
           (@NewNameSQL
           ,GetDate()); '
SET @sql=@sql + 'SET @NewIdSQL=(SELECT ScrapReasonID ' +
                'FROM [AdventureWorks].[Production].[ScrapReason] ' +
                'WHERE Name=@NewNameSQL)'
-- Variable to get the new Id
DECLARE @NewId int;
-- Parameters declaration
DECLARE @Params nvarchar(200);
SET @Params=N'@NewNameSQL nvarchar(100), @NewIdSQL int OUTPUT';
-- New Name to add
DECLARE @NewName nvarchar(100);
SET @NewName=N'Delayed Production';
-- Execute the insert into ScrapReason
EXEC sp_executeSql @sql,@params,@NewNameSQL=@NewName,@NewIdSQL=@NewId OUTPUT;

/* 
	Change the T-SQL statement to update the ScrapReasonID 
	to this new one, for all the records with End Date greater than
	Due Date 
*/

SET @sql=N'UPDATE [AdventureWorks].[Production].[WorkOrder] ' +
          'SET ScrapReasonID=@NewIdSQL ' + 
          'WHERE (EndDate > DueDate) AND (ScrapReasonID IS NULL)';
-- Define the parameter for this new sentence
SET @Params=N'@NewIdSQL int ';
EXEC sp_executeSql @sql, @params, @NewIdSQL=@NewId;
GO
