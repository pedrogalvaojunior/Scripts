EXECUTE sys.sp_configure
     @configname = 'show advanced options'
    ,@configvalue = 1
GO

RECONFIGURE
GO

EXECUTE sys.sp_configure
     @configname = 'dsh'
    ,@configvalue = 1
GO

RECONFIGURE
GO