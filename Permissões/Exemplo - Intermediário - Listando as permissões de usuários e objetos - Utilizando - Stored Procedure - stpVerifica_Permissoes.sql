-- Verifica todas as permiss�es do usu�rio 'Usuario_Teste' na inst�ncia
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste'
    
    
-- Verifica todas as permiss�es da tabela 'SA1010' no database 'Protheus_Producao'
EXEC dbo.stpVerifica_Permissoes
    @Ds_Database = 'Protheus_Producao',
    @Ds_Objeto = 'SA1010'
    

-- Verifica as roles de database do usu�rio 'Usuario_Teste' em todos os bancos
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste', -- varchar(100)
    @Ds_Database = NULL, -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 1,
    @Fl_Permissoes_Servidor = 0 -- N�o
    
    
-- Verifica as permiss�es a n�vel de Database do usu�rio 'Usuario_Teste'
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = 'Usuario_Teste', -- varchar(100)
    @Ds_Database = NULL, -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 2,
    @Fl_Permissoes_Servidor = 0 -- N�o
    
    
-- Verifica as permiss�es do database 'Protheus_Producao' para todos os usu�rios
EXEC dbo.stpVerifica_Permissoes
    @Ds_Usuario = NULL, -- varchar(100)
    @Ds_Database = 'Protheus_Producao', -- varchar(100)
    @Ds_Objeto = NULL,
    @Nr_Tipo_Permissao = 2,
    @Fl_Permissoes_Servidor = 0 -- N�o
    
    
-- Verifica as permiss�es a n�vel de sistema da inst�ncia
EXEC dbo.stpVerifica_Permissoes
    @Nr_Tipo_Permissao = 4
    
   
-- Verifica os membros de roles de sistema da inst�ncia
EXEC dbo.stpVerifica_Permissoes
    @Nr_Tipo_Permissao = 3