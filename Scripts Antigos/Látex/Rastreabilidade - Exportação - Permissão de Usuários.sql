Select d.caption As 'Descri��o - Tela', 
         u.nome As 'Nome do Usu�rio',
         case a.permitir
          When 'S' Then 'Liberada' 
          When 'N' Then 'Negada'
         End As Permissao
from Acessos a Inner Join Descricao_telas d
                      on a.codtela = d.codtela
                     Inner Join Usuarios u
                      on a.codusuario = u.numusuario
Order by D.Caption, U.Nome

