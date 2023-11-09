Create Table Imagens
 (
  Codigo Int Identity(1,1) Not Null Primary Key,
  NomedoArquivo Varchar(1000) Not Null,
  Arquivo Varbinary(Max)  
  )
   

--Inserindo os dados, fazendo a busca das imagens e carregando para o banco através do comando Bulk
INSERT INTO Imagens(NomedoArquivo, Arquivo)
SELECT 'Image.jpg', * 
 FROM OPENROWSET(BULK N'C:\Temp\Image.jpg',
  SINGLE_BLOB
) load;

INSERT INTO Imagens(NomedoArquivo, Arquivo)
SELECT 'Assinatura.jpg', * 
 FROM OPENROWSET(BULK N'C:\Temp\Assinatura.jpg',
  SINGLE_BLOB
) load;


Select * from Imagens