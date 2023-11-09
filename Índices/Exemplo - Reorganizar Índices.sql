sp_helpindex produtos

dbcc showcontig('produtos','pk_produtos')

dbcc dbreindex('inspecaoluvas','pk_inspecaoluvas')

dbcc indexdefrag(Laboratorio,Consulta_LaudoTec,Ind_NumLaudo)
