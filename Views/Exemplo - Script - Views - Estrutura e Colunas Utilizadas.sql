SELECT
   Sys.Columns.Object_ID AS ID,
   Sys.Objects.Name AS Tabela,
   Sys.Columns.Column_ID AS Ordem,
   Sys.Columns.Name AS Nome,
   referenced_entity_name AS Origem_Coluna,
   Sys.Extended_Properties.value AS Descricao,
   Sys.Types.Name AS Tipo,
   CASE Sys.Columns.max_length
    WHEN -1 THEN
      'MAX'
    ELSE
      CONVERT(VARCHAR(10), Sys.Columns.max_length)
   END AS Tamanho,
  
   Sys.Columns.Precision AS Precisao,
   Sys.Columns.Scale AS Escala,
  
   CASE Sys.Columns.Is_Nullable
    WHEN 0 THEN
      'Não'
    ELSE
      'Sim'
   END AS Nulo,
  
   CASE Sys.Columns.Is_Computed
    WHEN 0 THEN
      'Não'
    ELSE
      'Sim'
   END AS Computado,
  
   CASE Sys.Columns.Is_Identity
    WHEN 0 THEN
      'Não'
    ELSE
      'Sim'
   END AS Identado,
  
   Sys.SysComments.Text AS Constraints,
   Sys.Columns.Collation_Name AS Collation,
  
   CASE Sys.Columns.Is_Replicated
    WHEN 0 THEN
      'Não'
    ELSE
      'Sim'
   END AS Replicado
 FROM
   Sys.Columns INNER JOIN Sys.Types ON Sys.Types.System_Type_ID = Sys.Columns.System_Type_ID
               LEFT OUTER JOIN Sys.SysComments ON Sys.SysComments.ID = Sys.Columns.Default_Object_ID
               LEFT OUTER JOIN Sys.Extended_Properties ON Sys.Extended_Properties.Major_ID = Sys.Columns.Object_ID AND
                                                          Sys.Extended_Properties.Minor_ID = Sys.Columns.Column_ID
               INNER JOIN Sys.Objects ON Sys.Objects.Object_ID = Sys.Columns.Object_ID
               LEFT JOIN sys.dm_sql_referenced_entities ('Produtos', 'OBJECT') ON (sys.dm_sql_referenced_entities.referenced_minor_name = Sys.Columns.name)
 WHERE
   Sys.Objects.Name = 'produtos'