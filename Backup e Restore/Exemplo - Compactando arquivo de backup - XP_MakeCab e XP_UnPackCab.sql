-- Compacta o arquivo de backup DBTESTE_BKP.BAK
EXEC master.dbo.xp_makecab
@cabfilename = 'E:/Backup/DBTESTE_BKP.cab',
@compression_mode = 'mszip',
@verbose_level = 0,
@filename1 = 'E:/Backup/DBTESTE_BKP.BAK'

--Descompactando o arquivo DBTESTE_BKP.cab
EXEC master.dbo.xp_unpackcab
@cabfilename = 'E:/Backup/DBTESTE_BKP.cab', 
@destination_folder= 'E:/Backup',
@verbose_level=0