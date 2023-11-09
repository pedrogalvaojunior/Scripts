-- To allow advanced options to be changed. 
EXEC sp_configure 'show advanced options', 1 
GO 
-- To update the currently configured value for advanced options. 
RECONFIGURE 
GO 
-- To disable the feature. 
EXEC sp_configure 'default trace enabled', 0 
GO 
-- To update the currently configured value for this feature. 
RECONFIGURE 
GO 
