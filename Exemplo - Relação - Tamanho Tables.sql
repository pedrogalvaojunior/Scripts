-- Create tabela auxiliar
CREATE TABLE #temp(
	rec_id		int IDENTITY (1, 1),
	table_name	varchar(128),
	[db_name]    varchar(128),
	nbr_of_rows	int,
	data_space	decimal(15,2),
	index_space	decimal(15,2),
	total_size	decimal(15,2),
	percent_of_db	decimal(15,12),
	db_size		decimal(15,2))

-- Obtém todas as tabelas, nomes e respectivos tamanhos
EXEC sp_msforeachtable @command1="insert into #temp(nbr_of_rows, data_space, index_space) exec sp_mstablespace '?'",
			@command2="update #temp set table_name = '?' where rec_id = (select max(rec_id) from #temp)"

-- Define o tamanho total e o tamanho total no database
UPDATE #temp
SET total_size = (data_space + index_space), [db_name]=db_name(),db_size = (SELECT SUM(data_space + index_space) FROM #temp)

-- Define o percentual ocupado pela tabela dentro da base
UPDATE #temp
SET percent_of_db = (total_size/case when db_size = 0 then 1 else db_size end) * 100

-- Lista as tabelas
SELECT table_name, [db_name], nbr_of_rows,
	data_space,
	index_space,
	total_size,
	db_size
FROM #temp
ORDER BY total_size DESC

-- Exclui a tabela temporária
DROP TABLE #temp

