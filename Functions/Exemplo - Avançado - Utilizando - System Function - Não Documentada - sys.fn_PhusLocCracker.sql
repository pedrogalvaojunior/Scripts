CREATE DATABASE Teste

USE Teste

— Name: sys.fn_PhysLocCracker 
—
— Description:
— Cracks the output of %%physloc%% virtual column
—
— Notes:

create function fn_PhysLocCracker (@physical_locator binary (8))
returns @dumploc_table table
(
 [file_id] int not null,
 [page_id] int not null,
 [slot_id] int not null
)
as
begin


 declare @page_id binary (4)
 declare @file_id binary (2)
 declare @slot_id binary (2)


 --Page ID is the first four bytes, then 2 bytes of page ID, then 2 bytes of slot
 
 select @page_id = convert (binary (4), reverse (substring (@physical_locator, 1, 4)))
 select @file_id = convert (binary (2), reverse (substring (@physical_locator, 5, 2)))
 select @slot_id = convert (binary (2), reverse (substring (@physical_locator, 7, 2)))
 
 insert into @dumploc_table values (@file_id, @page_id, @slot_id)
 return
end

CREATE TABLE TEST (c1 INT IDENTITY, c2 CHAR (4000) DEFAULT 'a');
GO

INSERT INTO TEST DEFAULT VALUES;
INSERT INTO TEST DEFAULT VALUES;
INSERT INTO TEST DEFAULT VALUES;
GO


SELECT sys.fn_PhysLocFormatter (%%physloc%%) AS [Physical RID], * FROM TEST;
GO
