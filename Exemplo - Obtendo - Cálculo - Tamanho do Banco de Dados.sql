SELECT getdate() AS Date,

         name AS NameOfFile,

         size/128.0 AS SizeInMB,

         CAST(FILEPROPERTY(name, 'SpaceUsed' )AS int)/128.0 AS SpaceUsedInMB,

         size/128.0 -CAST(FILEPROPERTY(name, 'SpaceUsed' )AS int)/128.0 AS AvailableSpaceInMB,

         filename

FROM dbo.SYSFILES
