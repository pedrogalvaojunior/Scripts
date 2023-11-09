SELECT NUMUSUARIO,
           NOME,
           LOGIN,
           CASE STATUS
             WHEN 'U' THEN 'Usu�rio'
             WHEN 'A' THEN 'Administrado'
             WHEN 'D' THEN 'Digitador'
             WHEN 'C' THEN 'Convidado'
           END AS STATUS
FROM USUARIOS