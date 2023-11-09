SET DATEFORMAT DMY
SELECT * FROM CTLUVAS
WHERE DATAPRODUCAO BETWEEN '01/06/2005' AND '01/07/2005'
order by dataproducao

Declare @Datas Table
 (Codigo Int Identity(1,1),
   Data DateTime)

Insert Into @Datas Values(GetDate())
Insert Into @Datas Values(GetDate()+1)
Insert Into @Datas Values(GetDate()+2)
Insert Into @Datas Values(GetDate()+3)

Insert Into @Datas Values(GetDate()+30)
Insert Into @Datas Values(GetDate()+31)
Insert Into @Datas Values(GetDate()+32)
Insert Into @Datas Values(GetDate()+33)

Insert Into @Datas Values(GetDate()+60)
Insert Into @Datas Values(GetDate()+61)
Insert Into @Datas Values(GetDate()+62)
Insert Into @Datas Values(GetDate()+63)


Select * from @Datas
Where Month(Data) In (9,10)


Select * from @Datas
Where Data BetWeen '05/09/2008' And '07/10/2008'
