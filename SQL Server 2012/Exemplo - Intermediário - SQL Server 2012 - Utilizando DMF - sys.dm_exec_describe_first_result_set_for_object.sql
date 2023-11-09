SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TestProc3] 
AS
SELECT * FROM [Sales].[vSalesPerson]

/* SELECT A */

SELECT * FROM sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID('TestProc3'), 0)

/* SELECT B */

SELECT * FROM sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID('TestProc3'), 1) 