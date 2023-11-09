declare @t table (horario varchar(30))

insert into @t values ('2009-05-25 12:06:00.000')
insert into @t values ('2009-05-25 13:42:00.000')
insert into @t values ('2009-05-25 18:10:00.000')
insert into @t values ('2009-05-21 07:51:00.000')
insert into @t values ('2009-05-21 12:04:00.000')
insert into @t values ('2009-05-21 17:01:00.000')
insert into @t values ('2009-05-21 18:09:00.000')
insert into @t values ('2009-05-20 13:57:00.000')
insert into @t values ('2009-05-20 18:14:00.000')
insert into @t values ('2009-05-19 09:50:00.000')
insert into @t values ('2009-05-19 12:08:00.000')
insert into @t values ('2009-05-19 12:10:00.000')
insert into @t values ('2009-05-19 12:12:00.000')
insert into @t values ('2009-05-19 12:13:00.000')
insert into @t values ('2009-05-19 12:14:00.000')
insert into @t values ('2009-05-19 12:15:00.000')

;WITH Dias (Dia) As (
	SELECT DISTINCT
		REPLACE(CONVERT(CHAR(10),horario,102),'.','-') FROM @t),
	

Horarios (Dia, Horario) As (
	SELECT
		REPLACE(CONVERT(CHAR(10),horario,102),'.','-'),
		CONVERT(CHAR(8),horario,108)
	FROM @t),
	
Res As (

SELECT D.Dia,	
	(SELECT Horario As h FROM Horarios As H WHERE D.Dia = H.Dia
	FOR XML RAW('Hs')) As Horarios
FROM Dias As D)

SELECT Dia,
	REPLACE(
		REPLACE(Horarios,'<Hs h="',''),'"/>',' ; ')
FROM Res