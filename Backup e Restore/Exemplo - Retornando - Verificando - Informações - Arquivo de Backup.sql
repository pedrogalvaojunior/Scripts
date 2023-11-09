Use Master

--Retorna Informações sobre as mídias de backup --
Restore LabelOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

--Retorna Informações sobre os backups --
Restore HeaderOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

/* O comando RESTORE VERIFYONLY realiza uma checagem na integridade dos backups de um 
dispositivo, verificando se o mesmo é legível, este comando não verifica a estrutura de 
dados existente dentro do backup. Se o backup for válido, o SQL Server retorna uma mensagem 
de sucesso.*/
Restore VerifyOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

-- Retorna informações sobre os arquivos de dados e log (*.mdf, *.ndf e *.ldf) armazenados em um dispositivo --
Restore FileListOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'