select column_name As 'Nome da Coluna',
         Case Is_Nullable
          When 'YES' THEN 'Sim'
          When 'No'   Then 'Não'
         End As 'Aceita Valores Nulos',
         UPPER(Data_Type) As Tipo,
         Character_Maximum_Length As Tamanho          
from information_schema.columns
where table_name='produtos'