-- Inserindo a senha criptografada
INSERT INTO Usuarios_novos VALUES (CONVERT(VARBINARY(255), PWDENCRYPT('Senha_Teste'))) 

-- Comparando a senha digitada com a senha criptografada
SELECT PWDCOMPARE('Senha_Teste',CONVERT(VARBINARY(255), PWDENCRYPT('Senha_Teste')), 0) AS RESULTADO 