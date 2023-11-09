-- Verifica todas as permissões do usuário 'Usuario_Teste' na instância
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste'
    
    
-- Verifica todas as permissões da tabela 'SA1010' no database 'Protheus_Producao'
EXEC dbo.stpVerifica_Permissoes
    @Ds_Database = 'Protheus_Producao',
    @Ds_Objeto = 'SA1010'
    

-- Verifica as roles de database do usuário 'Usuario_Teste' em todos os bancos
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste', -- varchar(100)
    @Ds_Database = NULL, -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 1,
    @Fl_Permissoes_Servidor = 0 -- Não
    
    
-- Verifica as permissões a nível de Database do usuário 'Usuario_Teste'
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste', -- varchar(100)
    @Ds_Database = NULL, -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 2,
    @Fl_Permissoes_Servidor = 0 -- Não
    
    
-- Verifica as permissões do database 'Protheus_Producao' para todos os usuários
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = NULL, -- varchar(100)
    @Ds_Database = 'Protheus_Producao', -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 2,
    @Fl_Permissoes_Servidor = 0 -- Não
    
    
-- Verifica as permissões a nível de sistema da instância
EXEC dbo.stpVerifica_Permissoes
    @Nr_Tipo_Permissao = 4
    
   
-- Verifica os membros de roles de sistema da instância
EXEC dbo.stpVerifica_Permissoes
    @Nr_Tipo_Permissao = 3