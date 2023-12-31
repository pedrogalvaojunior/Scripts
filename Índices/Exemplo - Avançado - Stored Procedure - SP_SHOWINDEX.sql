USE MASTER

GO

IF(SELECT OBJECT_ID('SP_SHOWINDEX')) IS NOT NULL

BEGIN

	DROP PROCEDURE SP_SHOWINDEX

END



GO



CREATE PROCEDURE SP_SHOWINDEX

@TABLE_NAME		      VARCHAR(200) = '',

@INDEX_NAME		      VARCHAR(200) = '',

@SCHEMA_NAME		  VARCHAR(200) = '',

@INDEX_DETAILS		  BIT = 0,

@INDEX_FRAGMENTATION  BIT = 0,

@NOTUTILIZED		  BIT = 0,

@LIMITED			  BIT = 0,

@IS_DISABLED          BIT = 0,

@IS_DUPLICATE         BIT = 0,

@INDEX_INMEMORY		  BIT = 0,

@COLUMN_STORE		  BIT = 0,

@ORDER_BY			  VARCHAR(1000) = '',

@OUTPUT_COLUMNS		  VARCHAR(1000) = '',

@FILTER				  VARCHAR(1000) = '',

@HELP				  BIT = 0

AS



IF(@HELP <> 0)

BEGIN

PRINT 

'

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

															SP_SHOWINDEX

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Nome Procedure: SP_SHOWINDEX

Projeto.......: SCRIPTS

Vers�o........: 2.0.0.3

---------------------------------------------------------------------------------------------------------------------------------------------



SQL Server edi��es testadas: SQL Server 2008 e superiores.



---------------------------------------------------------------------------------------------------------------------------------------------

Id		Autor                      Vers�o	      Data                            Descri��o

---------------------------------------------------------------------------------------------------------------------------------------------



1		Paulo Katsuo Katayama Jr   1.0.0.1		01/01/2014     Cria��o do script para consulta personalizada dos indices.

2		Reginaldo da Cruz Silva	   1.0.0.1		27/11/2016     Padroniza��o de campos e implementa��o da procedure.

3		Reginaldo da Cruz Silva	   1.0.0.2		29/11/2016     Inclus�o dos campos FILL_FACTOR e COMPRESSION.

4		Reginaldo da Cruz Silva	   1.0.0.2		29/11/2016     Inclus�o do filtro pelo SCHEMA do objeto e apresentado schema junto ao nome da tabela.

5		Reginaldo da Cruz Silva	   1.0.0.2		29/11/2016     Corre��o em algumas passagens de parametros.

6		Reginaldo da Cruz Silva	   2.0.0.0		03/01/2017     Corre��o quando especificado parametro @INDEX_FRAGMENTATION trocado de AVG para SUM no page count.

7		Reginaldo da Cruz Silva	   2.0.0.0		03/01/2017     Inclus�o do parametro @IS_DUPLICATE.

8		Reginaldo da Cruz Silva	   2.0.0.0		03/01/2017     Melhoria de c�digo para ajustes de performance quando especificado o parametro @INDEX_DETAILS.

9		Reginaldo da Cruz Silva	   2.0.0.0		04/01/2017     Inclus�o de informa��es sobre Particionamento quando o parametro @INDEX_DETAILS = 1

10		Reginaldo da Cruz Silva	   2.0.0.0		05/01/2017     Altera��o dos parametros @TABLE_NAME, @INDEX_NAME e @SCHEMA_NAME de varchar(100) para varchar(200)

11		Reginaldo da Cruz Silva	   2.0.0.0		05/01/2017     Inclus�o do parametro @INDEX_NAME para filtrar indices especificos

12		Reginaldo da Cruz Silva	   2.0.0.0		05/01/2017     Inclus�o da busca por %% nos parametros @TABLE_NAME, @INDEX_NAME e @SCHEMA_NAME

13		Reginaldo da Cruz Silva	   2.0.0.1		06/01/2017     Corre��o de problema no parametro @IS_DUPLICATE.

14		Reginaldo da Cruz Silva	   2.0.0.2		27/01/2017     Build da vers�o para o Azure, removido tabelas temporarias globais.

15		Reginaldo da Cruz Silva	   2.0.0.2		31/01/2017     Inclus�o de parametro @INDEX_INMEMORY para trazer informa��es sobre �ndices In Memory.

16		Reginaldo da Cruz Silva	   2.0.0.2		31/01/2017     Inclus�o de parametro @COLUMN_STORE para trazer informa��es sobre os row groups do �ndice ColumStore.

17		Reginaldo da Cruz Silva	   2.0.0.2		01/02/2017     Inclus�o de parametro @ORDER_BY para ordernar o result set de acordo com o especificado pelo usuario.

18		Reginaldo da Cruz Silva	   2.0.0.2		01/02/2017     Inclus�o de parametro @COLUMNS_OUTPUT para apenas as colunas desejadas pelo usuario.

19		Reginaldo da Cruz Silva	   2.0.0.2		01/02/2017     Inclus�o de parametro @EXAMPLE para retornar exemplos de utiliza��o.

20		Reginaldo da Cruz Silva	   2.0.0.2		02/02/2017     Corre��o de funcionalidade, quando a tabela pertence a 2 schemas n�o duplicar linhas.

21		Reginaldo da Cruz Silva	   2.0.0.3		08/09/2017     Inclus�o do par�metro @FILTER.	

---------------------------------------------------------------------------------------------------------------------------------------------



Revis�o:

Reginaldo da Cruz Silva - 08/09/2017 16:00



Duvidas e sugest�es:

Blog: https://blogdojamal.wordpress.com/

Email: Reginaldo.silva27@gmail.com





>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

												PARAMETROS

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



 PARAMETRO									DESCRI��O 

 

@TABLE_NAME				- FILTRA APENAS INDICES DA TABELA INFORMADA, OU TABELAS QUE ESTEJAM ENTRE O %% (COMO O OPERADOR LIKE)

@INDEX_NAME				- FILTRA APENAS INDICE ESPECIFICADO, OU INDICES QUE ESTEJAM ENTRE O %% (COMO O OPERADOR LIKE)

@SCHEMA_NAME			- FILTRA PELO SCHEMA DA TABELA

@INDEX_DETAILS			- MOSTRA MAIS DETALHES DO INDICE (INDEX PAGE COUNT, ROWCOUNT, COMPRESSION, FILLFACTOR, PARTICIONAMENTO, FILEGROUP)

@INDEX_FRAGMENTATION	- MOSTRA FRAGMENTA��O DO INDICE (INDEX FRAGMENTATION), ESTE PROCESSO PODE SER LENTO

@NOTUTILIZED			- MOSTRA INDICES NUNCA UTILIZADOS OU A MAIS DE UM MES SEM SER FEITO UM SEEK.

@LIMITED				- LIMITA AS COLUNAS QUE S�O APRESENTADAS PARA UMA VISUALIZA��O MAIS SIMPLES

@IS_DISABLED			- MOSTRA INDICES DESABILITADOS

@IS_DUPLICATE			- MOSTRA �NDICES DUPLICADO (QUE POSSUEM OS MESMOS CAMPOS NA CHAVE E COM A MESMA ORDEM) IGNORANDO O INCLUDE,.

@INDEX_INMEMORY			- MOSTRA INFORMA��ES SOBRE �NDICES IN MEMORY.

@COLUMN_STORE			- MOSTRA INFORMA��ES SOBRE OS ROW GROUPS DO �NDICE COLUMNSTORE.

@ORDER_BY				- ORDENA O RESULT SET PELO CONJUNTO DE COLUNAS ESPECIFICADOS NO CAMPO, COLUNAS SEPARADAS POR (,).

@COLUMNS_OUTPUT			- APRESENTA NO RESULT SET APENAS AS COLUNAS DENTRO DA STRING INFORMADA, COLUNAS SEPARADAS POR (,).

@FILTER					- FILTRA O RESULTSET FINAL UTILIZANDO CLAUSULAS INFORMADAS, EXEMPLO: @FILTER = PAGE_COUNT > 0 AND PK_OR_INDEX = PK

@HELP					- MOSTRA DESCRI��O DAS COLUNAS, PARAMETROS E CABE�ALHO.





>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

										DESCRI��O DAS COLUNAS

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



   COLUNA											DESCRI��O    



SERVER_NAME						- NOME DO SERVIDOR QUE ESTA LOGADO

DATABASE_NAME					- NOME DA BASE DE DADOS EM USO

TABLE_NAME						- NOME DA TABELA QUE PERTENCE O INDICE, JUNTO COM O NOME DO SEU SCHEMA

INDEX_NAME						- NOME DO INDICE

PK_OR_INDEX						- MOSTRA SE O INDICE FOI CRIADO POR UMA PRIMARY KEY, VALORES PARA ESSA COLUNA:INDEX OU PK

INDEX_TYPE						- TIPO DO INDICE, VALORES PARA ESSA COLUNA: CLUSTERED E NONCLUSTERED

SEEKS							- NUMERO DE PESQUISAS(INDEX SEEK) EXECUTAS NESSE INDICE

SCANS							- NUMERO DE VARREDURAS(INDEX SCAN) EXECUTADAS NESSE INDICE

LOOKUPS							- NUMERO DE LOOKUPS EXECUTADOS NESSE INDICE

UPDATES							- NUMERO DE ALTERA��ES(INSERT, DELETE E UPDATE) EXECUTADAS NESSE INDICES

COLUMNS							- COLUNAS QUE PERTENCEM AO INDICE(EST�O EM TODOS OS NIVEIS DO INDICE)

INCLUDE_COLUMNS					- COLUNAS QUE PERTENCEM AO INDICE(EST�O APENAS NO NIVEL FOLHA DO INDICE)

DROP_COMMAND					- COMANDO PARA EXCLUIR O INDICE

CREATE COMMAND					- COMANDO PARA CRIAR O INDICE

PRIMARY_KEY						- INFORMA SE O INDICE � VINCULADO A UMA PRIMARY KEY

INDEX_UNIQUE					- INFORMA SE O INDICE PERTENCE A UMA CONSTRAINT UNIQUE

UNIQUE_KEY						- INFORMA SE O INDICE � UM INDICE UNICO

LAST_SEEK						- MOSTRA ULTIMA VEZ QUE FOI REALIZADO UMA PESQUISA(INDEX SEEK) NO INDICE

LAST_SCAN						- MOSTRA ULTIMA VEZ QUE FOI EXECUTADO UMA VARREDURA(INDEX SCAN) NO INDICE

LAST_LOOKUP						- MOSTRA ULTIMA VEZ QUE FOI EXECUTADO UM LOOKUP NO INDICE

LAST_UODATE						- MOSTRA ULTIMA VEZ QUE O INDICE SOFRE UMA ALTERA��O(INSERT, DELETE E UPDATE)

IS_DISABLED						- INFORMA SE O INDICE ESTA HABILITADO OU DESABILITADO

PAGE_COUNT						- QUANTIDADE DE PAGINAS DE 8K PARA ARMAZENAR DADOS, MOSTRASPAGINAS DO TIPO  IN_ROW_DATA,LOB E ROW_OVERFLOW

ROW_COUNT						- QUANTIDADE APROXIMADA DE LINHAS QUE POSSUI A TABELA

AVG_FRAGMENTATION_IN_PERCENT	- MEDIA DE FRAGMENTA��O DO INDICE, REPRESENTA��O EM % (APENAS FRAGMENTA��O DO LEVEL FOLHA)

PAGE_COUNT_FRAGMENTATION		- QUANTIDADE DE PAGINAS DE 8K, APENAS DO TIPO IN_ROW_DATA

FILL_FACTOR						- FATOR DE PREENCHIMENTO DA PAGINA

DATA_COMPRESSION				- TIPO DE COMPRESS�O UTILIZADO

PARTITION_SCHEME				- NOME DO ESQUEMA DE PARTI��O

FILE_GROUPNAME					- NOME DOS FILE GROUPS QUE O INDICE ESTA ARMAZENADO

FUNCTION_NAME					- NOME DA FUN��O QUE REALIZA O PARTICIONAMENTO

PARTITIONS						- QUANTIDADE DE PARTI��ES DO INDICE

XTP_SCANS_STARTED				- QUANTIDADE DE SCANS REALIZADA NO �NDICE (OPERA��ES INSERT, UPDATE E DELETE TAMB�M CONTAM COMO UM SCAN)

XTP_SCANS_RETRIES				- QUANTIDADE DE VEZES QUE A BUSCA PRECISOU RECOME�AR NOVAMENTE (TALVEZ DEVIDO A UM CONFLITO)

XTP_ROWS_TOUCHED				- N�MERO CUMULATIVO DE LINHAS ACESSADAS DESDE A �LTIMA REINICIALIZA��O

XTP_DELTA_PAGES					- N�MERO TOTAL DE P�GINAS DELTA PARA O �NDICE

XTP_LEAF_PAGES					- N�MERO TOTAL DE P�GINAS FOLHA PARA O �NDICE

XTP_PAGE_UPDATE_COUNT			- N�MERO CUMULATIVO DE ATUALIZA��ES QUE O �NDICE SOFREU

XTP_PAGE_SPLIT_COUNT			- N�MERO CUMULATIVO DE OPERA��ES DE SPLIT NO �NDICE

STATE_ROWGROUP					- STATUS DO ROW GROUP DO �NDICE COLUMN STORE (APENAS MOSTRADO O STATUS OPEN E COMPRESSED)

TOTAL_ROWS_OPEN					- N�MERO TOTAL DE LINHAS NO ROW GROUP COM STATUS ABERTO

DELETE_ROWS_OPEN				- N�MERO TOTAL DE LINHAS DELETADAS NO ROW GROUP ABERTO

PERCENTFULL_OPEN				- PORCENTAGEM UTILIZADA DO ROW GROUP ABERTO (CALCULO BASEADO NA QUANTIDADE DE LINHAS TOTAIS E DELETADAS)

TOTAL_ROWS_COMPRESSED			- N�MERO TOTAL DE LINHAS NO ROW GROUP COM STATUS COMPRESSED

DELETE_ROWS_COMPRESSED			- �MERO TOTAL DE LINHAS DELETADAS NO ROW GROUP COMPRESSED

PERCENTFULL_COMPRESSED			- PORCENTAGEM UTILIZADA DO ROW GROUP COMPRESSED (CALCULO BASEADO NA QUANTIDADE DE LINHAS TOTAIS E DELETADAS)







>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



'



RETURN

END

DECLARE @COMMAND VARCHAR(MAX) = ''



DECLARE @SQLNEWVERSION BIT = 0

IF(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50))) LIKE '12%' OR (CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50))) LIKE '13%'

BEGIN

	SET @SQLNEWVERSION = 1

END



SET @COMMAND = 

CASE WHEN @IS_DUPLICATE <> 0 THEN

'

IF(SELECT OBJECT_ID(''tempdb..#INDEXDUPLICATE_TABLE'')) IS NOT NULL

	DROP TABLE #INDEXDUPLICATE_TABLE



CREATE TABLE #INDEXDUPLICATE_TABLE (OBJECTNAME VARCHAR(200),INDEXNAME VARCHAR(200))



;WITH INDEXCOLS AS

(

SELECT OBJECT_ID AS ID, INDEX_ID AS INDID, NAME,

(SELECT CASE KEYNO WHEN 0 THEN NULL ELSE COLID END AS [data()]

FROM SYS.SYSINDEXKEYS AS K

WHERE K.ID = I.OBJECT_ID

AND K.INDID = I.INDEX_ID

ORDER BY KEYNO, COLID

FOR XML PATH('''')) AS COLS,

I.IS_DISABLED

FROM SYS.INDEXES AS I

) 



INSERT INTO #INDEXDUPLICATE_TABLE

SELECT 

OBJECT_NAME(C1.ID),

C1.NAME

FROM INDEXCOLS AS C1

JOIN INDEXCOLS AS C2

ON C1.ID = C2.ID 

AND C1.INDID < C2.INDID

AND C1.COLS = C2.COLS

UNION ALL

SELECT 

OBJECT_NAME(C2.ID),

C2.NAME

FROM INDEXCOLS AS C1

JOIN INDEXCOLS AS C2

ON C1.ID = C2.ID 

AND C1.INDID < C2.INDID

AND C1.COLS = C2.COLS

AND C2.IS_DISABLED=0

ORDER BY 1

' ELSE '' END +



CASE WHEN @INDEX_DETAILS <> 0 THEN 

'

IF(SELECT OBJECT_ID(''tempdb..#TEMP_INDICES'')) IS NOT NULL

	DROP TABLE #TEMP_INDICES

	

	

 SELECT MIN(I.object_id) AS object_id,I.index_id AS index_id,MAX(S.NAME) AS PARTITION_SCHEME,ISNULL(MAX(P.data_compression_desc),''NONE'') AS DATA_COMPRESSION, MAX(p.partition_number) AS PARTITIONS, SUM(rows) AS ROW_COUNT,SUM(A.used_pages) PAGE_COUNT,MIN(F.name) AS FUNCTION_NAME,

				         ISNULL((

				         	select  '','' + FG.name AS [text()] from SYS.filegroups FG where  FG.data_space_id in 

				         	(select a.data_space_id from  sys.indexes AS i2    

				         JOIN sys.partitions AS p  

				             ON i2.object_id = p.object_id AND i2.index_id = p.index_id   

				         LEFT JOIN  sys.partition_schemes AS s   

				             ON i2.data_space_id = s.data_space_id  

				         LEFT JOIN sys.partition_functions AS f   

				             ON s.function_id = f.function_id

				         LEFT JOIN SYS.allocation_units A ON P.hobt_id = A.container_id

				         where I.object_id = i2.object_id AND  I.index_id = i2.index_id

				         )

				         	order by name 

				         	for xml path('''')

				         ),''PRIMARY'')  AS FILE_GROUPNAME into #TEMP_INDICES

				         FROM sys.tables AS t  

				         JOIN sys.indexes AS i  

				             ON t.object_id = i.object_id  

				         JOIN sys.partitions AS p  

				             ON i.object_id = p.object_id AND i.index_id = p.index_id   

				         LEFT JOIN  sys.partition_schemes AS s   

				             ON i.data_space_id = s.data_space_id  

				         LEFT JOIN sys.partition_functions AS f   

				             ON s.function_id = f.function_id

				         LEFT JOIN SYS.allocation_units A ON P.hobt_id = A.container_id ' +

				         CASE WHEN @TABLE_NAME <> '' THEN 

				         ' WHERE OBJECT_NAME(I.object_id) LIKE '''+@TABLE_NAME+''' AND  A.TOTAL_PAGES > 0'

				         ELSE ' WHERE A.TOTAL_PAGES > 0 ' END 

				         +

				         '

				         GROUP BY I.object_id,I.index_id

' 

ELSE '' END +

'

SELECT	'+CAST(CASE WHEN @OUTPUT_COLUMNS <> '' THEN @OUTPUT_COLUMNS ELSE '*' END + ' FROM ( SELECT '

 +

CASE WHEN @LIMITED <> 0 THEN 

'

		A.SCHEMA_NAME + ''.'' + A.TABLE_NAME AS TABLE_NAME,A.INDEX_NAME,B.INDEX_TYPE,

		' + CAST(case when @INDEX_DETAILS <> 0 then 'ISNULL(PARTITION.PAGE_COUNT,0) AS PAGE_COUNT,ISNULL(PARTITION.ROW_COUNT,0) AS ROW_COUNT,FILL_FACTOR,ISNULL(PARTITION.DATA_COMPRESSION,''NONE'') AS DATA_COMPRESSION,ISNULL(PARTITION.PARTITION_SCHEME,''NONE'') AS PARTITION_SCHEME,ISNULL(SUBSTRING(PARTITION.FILE_GROUPNAME,2,LEN(PARTITION.FILE_GROUPNAME)-1),''PRIMARY'') AS FILE_GROUPNAME,ISNULL(PARTITION.FUNCTION_NAME,''NONE'') AS FUNCTION_NAME,ISNULL(PARTITION.PARTITIONS,1) AS PARTITIONS,' else '' end AS VARCHAR(MAX)) + '

		' + CAST(case when @SQLNEWVERSION <> 0 AND @INDEX_INMEMORY <> 0 then	'SCANS_STARTED AS XTP_SCANS_STARTED, SCANS_RETRIES AS XTP_SCANS_RETRIES,ROWS_TOUCHED AS XTP_ROWS_TOUCHED,DELTA_PAGES AS XTP_DELTA_PAGES,LEAF_PAGES AS XTP_LEAF_PAGES,PAGE_UPDATE_COUNT AS XTP_PAGE_UPDATE_COUNT,PAGE_SPLIT_COUNT AS XTP_PAGE_SPLIT_COUNT,' else '' end AS VARCHAR(MAX)) + '

		' + CAST(case when @INDEX_FRAGMENTATION <> 0 then 'AVG_FRAGMENTATION_IN_PERCENT,PAGE_COUNT_FRAGMENTATION,' else '' end AS VARCHAR(MAX)) + '

		' + CAST(CASE WHEN (CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50)) LIKE '11%' OR @SQLNEWVERSION = 1) AND @COLUMN_STORE = 1 then 'ISNULL(STATE1,''NONE'') AS STATE_ROWGROUP,ISNULL(TOTAL_ROWS_OPEN,0) TOTAL_ROWS_OPEN,ISNULL(DELETED_ROWS_OPEN,0) DELETED_ROWS_OPEN,ISNULL(PERCENTFULL_OPEN,0) PERCENTFULL_OPEN,ISNULL(STATE2,''NONE'') AS STATE_ROWGROUP2,ISNULL(TOTAL_ROWS_COMPRESSED,0) TOTAL_ROWS_COMPRESSED,ISNULL(DELETED_ROWS_COMPRESSED,0) DELETED_ROWS_COMPRESSED,ISNULL(PERCENTFULL_COMPRESSED,0) PERCENTFULL_COMPRESSED,' ELSE '' END AS VARCHAR(MAX)) +'

		SEEKS,SCANS,LOOKUPS,UPDATES,COLUMNS,ISNULL(INCLUDE,'''') AS INCLUDE_COLUMNS,LAST_SEEK,LAST_UPDATE,IS_DISABLED

' ELSE 

'

		@@SERVERNAME AS SERVER_NAME,

		ISNULL(DATABASE_NAME,DB_NAME(DB_ID())) AS DATABASE_NAME,

		A.SCHEMA_NAME + ''.'' + A.TABLE_NAME AS TABLE_NAME,A.INDEX_NAME,PK_OR_INDEX,B.INDEX_TYPE,ISNULL(SEEKS,0) AS SEEKS,

		ISNULL(SCANS,0) AS SCANS,

		ISNULL(LOOKUPS,0) AS LOOKUPS,

		ISNULL(UPDATES,0) AS UPDATES,

		' + CAST(case when @INDEX_DETAILS <> 0 then 'ISNULL(PARTITION.PAGE_COUNT,0) AS PAGE_COUNT,ISNULL(PARTITION.ROW_COUNT,0) AS ROW_COUNT,FILL_FACTOR,ISNULL(PARTITION.DATA_COMPRESSION,''NONE'') AS DATA_COMPRESSION,ISNULL(PARTITION.PARTITION_SCHEME,''NONE'') AS PARTITION_SCHEME,ISNULL(SUBSTRING(PARTITION.FILE_GROUPNAME,2,LEN(PARTITION.FILE_GROUPNAME)-1),''PRIMARY'') AS FILE_GROUPNAME,ISNULL(PARTITION.FUNCTION_NAME,''NONE'') AS FUNCTION_NAME,ISNULL(PARTITION.PARTITIONS,1) AS PARTITIONS,' else '' end AS VARCHAR(MAX)) + '

		' + CAST(case when @SQLNEWVERSION <> 0 AND @INDEX_INMEMORY <> 0 then	'SCANS_STARTED AS XTP_SCANS_STARTED, SCANS_RETRIES AS XTP_SCANS_RETRIES,ROWS_TOUCHED AS XTP_ROWS_TOUCHED,DELTA_PAGES AS XTP_DELTA_PAGES,LEAF_PAGES AS XTP_LEAF_PAGES,PAGE_UPDATE_COUNT AS XTP_PAGE_UPDATE_COUNT,PAGE_SPLIT_COUNT AS XTP_PAGE_SPLIT_COUNT,' else '' end AS VARCHAR(MAX)) + '

		' + CAST(CASE WHEN @INDEX_FRAGMENTATION <> 0 THEN 'AVG_FRAGMENTATION_IN_PERCENT,PAGE_COUNT_FRAGMENTATION,' ELSE '' END AS VARCHAR(MAX)) + '

		' + CAST(CASE WHEN (CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50)) LIKE '11%' OR @SQLNEWVERSION = 1) AND @COLUMN_STORE = 1 then 'ISNULL(STATE1,''NONE'') AS STATE_ROWGROUP,ISNULL(TOTAL_ROWS_OPEN,0) TOTAL_ROWS_OPEN,ISNULL(DELETED_ROWS_OPEN,0) DELETED_ROWS_OPEN,ISNULL(PERCENTFULL_OPEN,0) PERCENTFULL_OPEN,ISNULL(STATE2,''NONE'') AS STATE_ROWGROUP2,ISNULL(TOTAL_ROWS_COMPRESSED,0) TOTAL_ROWS_COMPRESSED,ISNULL(DELETED_ROWS_COMPRESSED,0) DELETED_ROWS_COMPRESSED,ISNULL(PERCENTFULL_COMPRESSED,0) PERCENTFULL_COMPRESSED,' ELSE '' END AS VARCHAR(MAX)) +'

		COLUMNS,

		ISNULL(INCLUDE,'''') AS INCLUDE_COLUMNS,

		DROP_COMMAND,CREATE_COMMAND,PRIMARY_KEY,INDEX_UNIQUE,UNIQUE_KEY,LAST_SEEK,LAST_SCAN,LAST_LOOKUP,LAST_UPDATE,IS_DISABLED

' END AS VARCHAR(MAX))+ '

FROM (

		SELECT 

		    DB_NAME(U.DATABASE_ID) AS DATABASE_NAME, 

			OBJECT_NAME(I.OBJECT_ID) AS TABLE_NAME,

			S4.NAME SCHEMA_NAME, 

			I.NAME AS INDEX_NAME,I.OBJECT_ID,I.INDEX_ID,MAX(I.FILL_FACTOR) AS FILL_FACTOR,

			MAX(CASE WHEN IS_PRIMARY_KEY = 0 THEN ''INDEX'' ELSE ''PK'' END) AS PK_OR_INDEX,

		    SUM(ISNULL(U.USER_SEEKS,0)) AS SEEKS, 

			SUM(ISNULL(U.USER_SCANS,0)) AS SCANS, 

			SUM(ISNULL(U.USER_LOOKUPS,0)) AS LOOKUPS,

			SUM(ISNULL(U.USER_UPDATES,0)) AS UPDATES,

		    MAX(U.LAST_USER_SEEK) AS LAST_SEEK, 

			MAX(U.LAST_USER_SCAN) AS LAST_SCAN,

		    MAX(U.LAST_USER_LOOKUP) AS LAST_LOOKUP, 

			MAX(U.LAST_USER_UPDATE) AS LAST_UPDATE,

			CASE WHEN I.IS_DISABLED = 1 THEN ''YES'' ELSE ''NO'' END IS_DISABLED			

			' + CAST(case when @INDEX_FRAGMENTATION <> 0 then ',MAX(CAST(ISNULL(S.AVG_FRAGMENTATION_IN_PERCENT,0) AS DECIMAL(18,2))) AS AVG_FRAGMENTATION_IN_PERCENT, SUM(ISNULL(S.PAGE_COUNT,0)) AS PAGE_COUNT_FRAGMENTATION' else '' end AS VARCHAR(MAX)) + '			

			' + CAST(CASE WHEN (CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50)) LIKE '11%' OR @SQLNEWVERSION = 1) AND @COLUMN_STORE = 1 then ',MIN(CSROWGROUPS_OPEN.STATE_DESCRIPTION) STATE1,SUM(CSROWGROUPS_OPEN.TOTAL_ROWS) TOTAL_ROWS_OPEN,ISNULL(SUM(CSROWGROUPS_OPEN.DELETED_ROWS),0) DELETED_ROWS_OPEN,SUM(100*(ISNULL(CSROWGROUPS_OPEN.TOTAL_ROWS,0) - ISNULL(CSROWGROUPS_OPEN.DELETED_ROWS,0))/ (CASE WHEN CSROWGROUPS_OPEN.TOTAL_ROWS = 0 THEN 1 ELSE CSROWGROUPS_OPEN.TOTAL_ROWS END)) AS PERCENTFULL_OPEN,MIN(CSROWGROUPS_COMPRESSED.STATE_DESCRIPTION) STATE2,SUM(CSROWGROUPS_COMPRESSED.TOTAL_ROWS) TOTAL_ROWS_COMPRESSED,SUM(CSROWGROUPS_COMPRESSED.DELETED_ROWS) DELETED_ROWS_COMPRESSED, SUM(100*(CSROWGROUPS_COMPRESSED.TOTAL_ROWS - ISNULL(CSROWGROUPS_COMPRESSED.DELETED_ROWS,1))/(ISNULL(CSROWGROUPS_COMPRESSED.TOTAL_ROWS,0)+1)) AS PERCENTFULL_COMPRESSED ' else '' end AS VARCHAR(MAX)) + '			

			' + CAST(case when @SQLNEWVERSION <> 0 AND @INDEX_INMEMORY<> 0 then ',MAX(CAST(ISNULL(XTP1.SCANS_STARTED,0) AS INT)) AS SCANS_STARTED, MAX(CAST(ISNULL(XTP1.SCANS_RETRIES,0) AS INT)) AS SCANS_RETRIES,MAX(CAST(ISNULL(XTP1.ROWS_TOUCHED,0) AS INT)) AS ROWS_TOUCHED,

			MAX(CAST(ISNULL(XTP2.DELTA_PAGES,0) AS INT)) AS DELTA_PAGES,MAX(CAST(ISNULL(XTP2.LEAF_PAGES,0) AS INT)) AS LEAF_PAGES,MAX(CAST(ISNULL(XTP2.PAGE_UPDATE_COUNT,0) AS INT)) AS PAGE_UPDATE_COUNT,MAX(CAST(ISNULL(XTP2.PAGE_SPLIT_COUNT,0) AS INT)) AS PAGE_SPLIT_COUNT' else '' end AS VARCHAR(MAX)) + '			

		FROM

		    SYS.INDEXES AS I INNER JOIN SYS.OBJECTS OBJ ON I.OBJECT_ID = OBJ.OBJECT_ID AND OBJ.TYPE = ''U''

            INNER JOIN SYS.SCHEMAS S4 ON OBJ.SCHEMA_ID = S4.SCHEMA_ID

			LEFT OUTER JOIN SYS.DM_DB_INDEX_USAGE_STATS AS U ON I.OBJECT_ID = U.OBJECT_ID AND I.INDEX_ID = U.INDEX_ID AND U.DATABASE_ID = DB_ID()		    		    

		    ' + CAST(case when @INDEX_FRAGMENTATION <> 0 then 'LEFT JOIN  SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(), NULL, NULL, NULL, ''LIMITED'') S ON S.OBJECT_ID = I.OBJECT_ID AND S.INDEX_ID = I.INDEX_ID AND S.PAGE_COUNT > 0' else '' end  AS VARCHAR(MAX))+ '

			' + CAST(case when @SQLNEWVERSION <> 0 AND @INDEX_INMEMORY <> 0 then 'LEFT JOIN  SYS.DM_DB_XTP_INDEX_STATS XTP1 ON XTP1.OBJECT_ID = I.OBJECT_ID AND XTP1.INDEX_ID = I.INDEX_ID 

																			LEFT JOIN  SYS.DM_DB_XTP_NONCLUSTERED_INDEX_STATS XTP2	ON XTP2.OBJECT_ID = I.OBJECT_ID AND XTP2.INDEX_ID = I.INDEX_ID  ' ELSE '' END  AS VARCHAR(MAX))+ '			    

			' + CASE WHEN (CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(50)) LIKE '11%' OR @SQLNEWVERSION = 1) AND @COLUMN_STORE = 1 THEN '

			LEFT JOIN SYS.COLUMN_STORE_ROW_GROUPS AS CSROWGROUPS_OPEN  ON 

			I.OBJECT_ID = CSROWGROUPS_OPEN.OBJECT_ID AND I.INDEX_ID = CSROWGROUPS_OPEN.INDEX_ID AND CSROWGROUPS_OPEN.STATE_DESCRIPTION = ''OPEN''

			LEFT JOIN SYS.COLUMN_STORE_ROW_GROUPS AS CSROWGROUPS_COMPRESSED  ON 

			I.OBJECT_ID = CSROWGROUPS_COMPRESSED.OBJECT_ID AND I.INDEX_ID = CSROWGROUPS_COMPRESSED.INDEX_ID  AND CSROWGROUPS_COMPRESSED.STATE_DESCRIPTION = ''COMPRESSED''

			' ELSE '' END +'

		WHERE (U.DATABASE_ID = DB_ID() OR U.DATABASE_ID IS NULL) AND I.NAME IS NOT NULL 		

		' + CAST(case when @IS_DISABLED <> 0 then '  AND IS_DISABLED = 1 ' else '' end AS VARCHAR(MAX)) 

		+

CASE WHEN @TABLE_NAME <> '' THEN 

' AND OBJECT_NAME(I.object_id) LIKE '''+@TABLE_NAME+'''

'

ELSE '' END 

+		    

		'GROUP BY U.DATABASE_ID, I.OBJECT_ID,I.INDEX_ID, I.NAME,S4.NAME,I.IS_DISABLED

	) A

' + CAST(case when @INDEX_DETAILS <> 0 then '

	LEFT JOIN #TEMP_INDICES PARTITION ON PARTITION.OBJECT_ID = A.OBJECT_ID AND PARTITION.INDEX_ID = A.INDEX_ID



			' else '' end  AS VARCHAR(MAX)) + '	

LEFT JOIN (



			SELECT	TABLE_NAME, INDEX_NAME, PRIMARY_KEY, INDEX_UNIQUE, UNIQUE_KEY, INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS INDEX_TYPE, 

					SUBSTRING(COLUMNS,1,LEN(COLUMNS)-1)COLUMNS, SUBSTRING([INCLUDE],1,LEN([INCLUDE])-1)[INCLUDE], SCHEMA_NAME,

					

					CASE WHEN PRIMARY_KEY = 1 THEN ''ALTER TABLE ''+SCHEMA_NAME+''.''+TABLE_NAME+'' ADD CONSTRAINT ''+UPPER(INDEX_NAME)+'' PRIMARY KEY ''+INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS +'' (''+SUBSTRING(COLUMNS,1,LEN(COLUMNS)-1)+'')''

						WHEN UNIQUE_KEY = 1 THEN ''ALTER TABLE ''+SCHEMA_NAME+''.''+TABLE_NAME+'' ADD CONSTRAINT ''+UPPER(INDEX_NAME)+'' UNIQUE ''+INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS +'' (''+SUBSTRING(COLUMNS,1,LEN(COLUMNS)-1)+'')''						

						WHEN INDEX_TYPE = ''CLUSTERED COLUMNSTORE'' THEN ''CREATE ''+INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS +'' INDEX ''+UPPER(INDEX_NAME)+ '' ON ''+SCHEMA_NAME+''.''+TABLE_NAME+'' ''

						WHEN PRIMARY_KEY = 0 AND UNIQUE_KEY = 0 AND INDEX_UNIQUE = 1 THEN ''CREATE UNIQUE ''+INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS +'' INDEX ''+UPPER(INDEX_NAME)+ '' ON ''+SCHEMA_NAME+''.''+TABLE_NAME+'' (''+SUBSTRING(COLUMNS,1,LEN(COLUMNS)-1)+'')''+ CASE WHEN [INCLUDE] IS NOT NULL THEN '' INCLUDE (''+SUBSTRING([INCLUDE],1,LEN([INCLUDE])-1)+'')'' ELSE '''' END

						WHEN PRIMARY_KEY = 0 AND UNIQUE_KEY = 0 AND INDEX_UNIQUE = 0 THEN ''CREATE ''+INDEX_TYPE COLLATE SQL_Latin1_General_CP1_CI_AS +'' INDEX ''+UPPER(INDEX_NAME)+ '' ON ''+SCHEMA_NAME+''.''+TABLE_NAME+'' (''+SUBSTRING(COLUMNS,1,LEN(COLUMNS)-1)+'')''+ CASE WHEN [INCLUDE] IS NOT NULL THEN '' INCLUDE (''+SUBSTRING([INCLUDE],1,LEN([INCLUDE])-1)+'')'' ELSE '''' END END AS CREATE_COMMAND,

			

					CASE WHEN PRIMARY_KEY = 1 THEN ''ALTER TABLE ''+SCHEMA_NAME+''.''+TABLE_NAME+'' DROP CONSTRAINT ''+INDEX_NAME

						WHEN UNIQUE_KEY = 1 THEN ''ALTER TABLE ''+SCHEMA_NAME+''.''+TABLE_NAME+'' DROP CONSTRAINT ''+INDEX_NAME

						WHEN PRIMARY_KEY = 0 AND UNIQUE_KEY = 0 AND INDEX_UNIQUE = 1 THEN ''DROP INDEX ''+INDEX_NAME+ '' ON ''+SCHEMA_NAME+''.''+TABLE_NAME 

						WHEN PRIMARY_KEY = 0 AND UNIQUE_KEY = 0 AND INDEX_UNIQUE = 0 THEN ''DROP INDEX ''+INDEX_NAME+ '' ON ''+SCHEMA_NAME+''.''+TABLE_NAME END AS DROP_COMMAND

			

			FROM(

			SELECT	TABLE_NAME, 

					INDEX_NAME,

					SCHEMA_NAME,

					MAX(CAST(IS_PRIMARY_KEY AS INT))PRIMARY_KEY,

					MAX(CAST(IS_UNIQUE AS INT))INDEX_UNIQUE,

					MAX(CAST(IS_UNIQUE_CONSTRAINT AS INT))UNIQUE_KEY,

					MAX(TYPE_DESC) AS INDEX_TYPE,

					

				(	SELECT CAMPO + '','' AS [text()]

					FROM (	SELECT	DISTINCT S.NAME AS TABLE_NAME, S6.NAME AS INDEX_NAME, S2.NAME AS CAMPO, S6.KEY_ORDINAL AS ORDEM, S6.IS_INCLUDED_COLUMN AS INCLUD	

							FROM	[DBO].[SYSOBJECTS] S 

							INNER JOIN [DBO].[SYSCOLUMNS]		S2 ON S.ID = S2.ID

							INNER JOIN [DBO].[SYSTYPES]			S3 ON S2.XTYPE = S3.XTYPE AND S2.XUSERTYPE = S3.XUSERTYPE 

							INNER JOIN [SYS].[SCHEMAS]			S4 ON S.[UID] = S4.[SCHEMA_ID]

							LEFT  JOIN [SYS].[IDENTITY_COLUMNS]	S5 ON S2.ID = S5.[OBJECT_ID] AND S2.COLID = S5.COLUMN_ID

							LEFT  JOIN (SELECT S.[OBJECT_ID], S.NAME, S.TYPE_DESC, ISNULL(COLUMN_ID,0) AS COLUMN_ID, INDEX_COLUMN_ID, KEY_ORDINAL, IS_INCLUDED_COLUMN

										FROM	[SYS].[INDEXES] S 

										INNER JOIN [SYS].[INDEX_COLUMNS] S2 ON S.[OBJECT_ID] = S2.[OBJECT_ID] AND S.INDEX_ID = S2.INDEX_ID

										)S6 ON S6.[OBJECT_ID] = S.ID AND S6.COLUMN_ID = S2.COLID

							WHERE (S.XTYPE = ''U''  AND S6.COLUMN_ID <> 0 AND IS_INCLUDED_COLUMN = 0 )

							OR (S.XTYPE = ''U''  AND S6.COLUMN_ID <> 0 AND S6.TYPE_DESC = ''CLUSTERED COLUMNSTORE'')

						)A 

					WHERE A.TABLE_NAME = B.TABLE_NAME AND A.INDEX_NAME = B.INDEX_NAME 

					ORDER BY TABLE_NAME,INDEX_NAME,ORDEM FOR XML PATH(''''))COLUMNS,

				

			

				(	SELECT CAMPO + '','' AS [text()]

					FROM (	SELECT	S.NAME AS TABLE_NAME, S6.NAME AS INDEX_NAME, S2.NAME AS CAMPO, S6.INDEX_COLUMN_ID AS ORDEM, S6.IS_INCLUDED_COLUMN AS INCLUD	

							FROM	[DBO].[SYSOBJECTS] S 

							INNER JOIN [DBO].[SYSCOLUMNS]		S2 ON S.ID = S2.ID

							INNER JOIN [DBO].[SYSTYPES]			S3 ON S2.XTYPE = S3.XTYPE AND S2.XUSERTYPE = S3.XUSERTYPE 

							INNER JOIN [SYS].[SCHEMAS]			S4 ON S.[UID] = S4.[SCHEMA_ID]

							LEFT  JOIN [SYS].[IDENTITY_COLUMNS]	S5 ON S2.ID = S5.[OBJECT_ID] AND S2.COLID = S5.COLUMN_ID

							LEFT  JOIN (SELECT S.[OBJECT_ID], S.NAME, S.TYPE_DESC, ISNULL(COLUMN_ID,0) AS COLUMN_ID, INDEX_COLUMN_ID, IS_INCLUDED_COLUMN

										FROM	[SYS].[INDEXES] S 

										INNER JOIN [SYS].[INDEX_COLUMNS] S2 ON S.[OBJECT_ID] = S2.[OBJECT_ID] AND S.INDEX_ID = S2.INDEX_ID

										)S6 ON S6.[OBJECT_ID] = S.ID AND S6.COLUMN_ID = S2.COLID

							WHERE S.XTYPE = ''U''  AND S6.COLUMN_ID <> 0 AND IS_INCLUDED_COLUMN <> 0 AND S6.TYPE_DESC <> ''CLUSTERED COLUMNSTORE''

						)A 

					WHERE A.TABLE_NAME = B.TABLE_NAME AND A.INDEX_NAME = B.INDEX_NAME 

					ORDER BY TABLE_NAME,INDEX_NAME,ORDEM FOR XML PATH(''''))[INCLUDE]

			

			FROM (

			SELECT S.NAME AS TABLE_NAME,S4.NAME AS SCHEMA_NAME, S6.NAME AS INDEX_NAME, TYPE_DESC, IS_PRIMARY_KEY, IS_UNIQUE, IS_UNIQUE_CONSTRAINT, S2.NAME AS CAMPO, S6.INDEX_COLUMN_ID AS ORDEM, S6.IS_INCLUDED_COLUMN AS INCLUD

			FROM	[DBO].[SYSOBJECTS] S 

						INNER JOIN [DBO].[SYSCOLUMNS]		S2 ON S.ID = S2.ID

						INNER JOIN [DBO].[SYSTYPES]			S3 ON S2.XTYPE = S3.XTYPE AND S2.XUSERTYPE = S3.XUSERTYPE 

						INNER JOIN [SYS].[SCHEMAS]			S4 ON S.[UID] = S4.[SCHEMA_ID]

						LEFT  JOIN [SYS].[IDENTITY_COLUMNS]	S5 ON S2.ID = S5.[OBJECT_ID] AND S2.COLID = S5.COLUMN_ID

						LEFT  JOIN (SELECT S.[OBJECT_ID], S.NAME, S.TYPE_DESC, IS_PRIMARY_KEY, IS_UNIQUE, IS_UNIQUE_CONSTRAINT, ISNULL(COLUMN_ID,0) AS COLUMN_ID, INDEX_COLUMN_ID, IS_INCLUDED_COLUMN

									FROM	[SYS].[INDEXES] S 

											INNER JOIN [SYS].[INDEX_COLUMNS] S2 ON S.[OBJECT_ID] = S2.[OBJECT_ID] AND S.INDEX_ID = S2.INDEX_ID

									)S6 ON S6.[OBJECT_ID] = S.ID AND S6.COLUMN_ID = S2.COLID

				WHERE S.XTYPE = ''U''  AND S6.COLUMN_ID <> 0 

				

			)B

			GROUP BY TABLE_NAME, INDEX_NAME,SCHEMA_NAME

			)CONSULTA 

		) B ON A.TABLE_NAME= B.TABLE_NAME AND A.INDEX_NAME = B.INDEX_NAME AND A.SCHEMA_NAME = B.SCHEMA_NAME

'

+

CASE WHEN @IS_DUPLICATE <> 0 THEN ' INNER JOIN #INDEXDUPLICATE_TABLE IDX ON A.TABLE_NAME= IDX.OBJECTNAME AND A.INDEX_NAME = IDX.INDEXNAME ' ELSE '' END

+

CASE WHEN @TABLE_NAME <> ''  THEN 

' WHERE A.TABLE_NAME LIKE '''+@TABLE_NAME+'''

'

ELSE '' END 

+

CASE WHEN @INDEX_NAME <> '' AND @TABLE_NAME = ''  THEN 

' WHERE A.INDEX_NAME LIKE '''+@INDEX_NAME+'''

'

WHEN @INDEX_NAME <> '' AND (@TABLE_NAME <> '') THEN 

' AND A.INDEX_NAME LIKE '''+@INDEX_NAME+'''

'

ELSE '' END 

+

CASE WHEN @SCHEMA_NAME <> '' AND @TABLE_NAME = '' AND @INDEX_NAME = '' THEN 

' WHERE A.SCHEMA_NAME LIKE '''+@SCHEMA_NAME+'''

'

WHEN @SCHEMA_NAME <> '' AND (@TABLE_NAME <> '' OR @INDEX_NAME <> '') THEN

' AND A.SCHEMA_NAME LIKE '''+@SCHEMA_NAME+'''

'

ELSE '' END +

CASE WHEN @TABLE_NAME = '' AND @SCHEMA_NAME = '' AND @NOTUTILIZED <> 0  AND @INDEX_NAME = ''

THEN 

' WHERE (A.SEEKS <= 0 OR DATEDIFF(DAY,A.LAST_SEEK,GETDATE()) > 30)

'

WHEN (@TABLE_NAME <> '' OR @SCHEMA_NAME <> '' OR @INDEX_NAME <> '') AND @NOTUTILIZED <> 0

THEN 

' AND (A.SEEKS <= 0 OR DATEDIFF(DAY,A.LAST_SEEK,GETDATE()) > 30)

'

ELSE '' 

END 

+

CASE WHEN @FILTER <> '' THEN 'WHERE ' + @FILTER ELSE '' END  

+ 

CASE WHEN @IS_DUPLICATE <> 0  

THEN CAST(' )TAB ORDER BY '+ CASE WHEN @ORDER_BY <> '' THEN @ORDER_BY ELSE 'TABLE_NAME,COLUMNS,INDEX_NAME,SEEKS DESC' END +'



IF(SELECT OBJECT_ID(''tempdb..#TEMP_INDICES'')) IS NOT NULL

	DROP TABLE #TEMP_INDICES 



IF(SELECT OBJECT_ID(''tempdb..#INDEXDUPLICATE_TABLE'')) IS NOT NULL

	DROP TABLE #INDEXDUPLICATE_TABLE

	' AS VARCHAR(MAX))

ELSE CAST(' )TAB ORDER BY '+ CASE WHEN @ORDER_BY <> '' THEN @ORDER_BY ELSE 'TABLE_NAME,SEEKS DESC, SCANS DESC, LOOKUPS DESC' END + '



IF(SELECT OBJECT_ID(''tempdb..#TEMP_INDICES'')) IS NOT NULL

	DROP TABLE #TEMP_INDICES 



IF(SELECT OBJECT_ID(''tempdb..#INDEXDUPLICATE_TABLE'')) IS NOT NULL

	DROP TABLE #INDEXDUPLICATE_TABLE

' AS VARCHAR(MAX)) END



EXEC (@COMMAND)