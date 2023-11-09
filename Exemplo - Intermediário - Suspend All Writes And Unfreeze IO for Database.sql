-- Suspend all writes from this database --
dbcc freeze_io(9)

-- Testing --
select * from Automovel
Go

-- Unfreeze the IO --
DBCC Thaw_IO(9)
Go