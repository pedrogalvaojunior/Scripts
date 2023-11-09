EXEC sp_msforeachtable 'ALTER INDEX ALL ON ? REBUILD 
                                          WITH (FILLFACTOR = 70,
                                          SORT_IN_TEMPDB = OFF, 
                                          STATISTICS_NORECOMPUTE = ON)'