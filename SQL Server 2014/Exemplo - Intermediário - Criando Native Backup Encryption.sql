-- Criando o Banco de Dados --
Create Database NativeBackupEncryption
Go

-- Criando a Master Key --
Use Master
Go

Create Master Key Encryption By Password = 'Backup@@01'
Go

-- Criando o Certificado --
Create Certificate CertNativeBackupEncryption
With Subject = 'Certificado para Criptografia de Backup';
Go

-- Realizando o Backup da Master Key --
Use Master
Go

-- Se realizar este backup poderemos receber mensagem de erro no backup do certificado --
Backup Master Key To File = 'S:\MSSQL-2016\Backup\Backup-Master-Key-File.key'
Encryption By Password = 'Backup@@01'
Go

-- Realizando o Backup do Certificado vinculando a Master Key --
Backup Certificate CertNativeBackupEncryption
To File = 'S:\MSSQL-2016\Backup\Backup-Certificate-CertNativeBackupEncryption.cert'
With Private Key
 (
  File = 'S:\MSSQL-2016\Backup\Backup-Master-Key-File.key',
  Encryption By Password = 'Backup@@01'
 )
Go

-- Realizando o Backup Criptografado --
Backup Database NativeBackupEncryption
To Disk = 'S:\MSSQL-2016\Backup\Backup-NativeBackupEncryption.Bak'
With Compression,
Encryption 
 (Algorithm = AES_256,
  Server Certificate = CertNativeBackupEncryption)
Go

-- Confirmando a camada de criptografia de conteúdo ao arquivo de backup --
Restore HeaderOnly 
from Disk = 'S:\MSSQL-2016\Backup\Backup-NativeBackupEncryption.Bak'
Go