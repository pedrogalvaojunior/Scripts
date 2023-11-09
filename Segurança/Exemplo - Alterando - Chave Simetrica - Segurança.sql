Open Symmetric Key Chave_Simetrica_Teste Decryption By Certificate Certificado_Teste
 With Password ='Edu@06@09'
Go

Alter SYMMETRIC KEY Chave_Simetrica_Teste
 Drop ENCRYPTION BY CERTIFICATE Certificado_Teste;
Go

Alter SYMMETRIC KEY Chave_Simetrica_Teste
 Add Encryption By Certificate Certificado_Teste
Go

Close SYMMETRIC KEY Chave_Simetrica_Teste;
Go