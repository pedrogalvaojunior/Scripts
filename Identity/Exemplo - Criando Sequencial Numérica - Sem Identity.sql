Create Table #Sequencial
 (Sequencial Int Identity(1,1),
   Campo1 Int,
   Campo2 Int,
   Campo3 Int)

Insert Into #Sequencial Values(1,2,3)
Insert Into #Sequencial Values(4,5,6)
Insert Into #Sequencial Values(7,8,9)
Insert Into #Sequencial Values(10,11,12)


Select * from #Sequencial

SELECT
 (SELECT COUNT(Sequencial) FROM #Sequencial AS TInt Where TInt.Sequencial >= TOut.Sequencial) As SEQ,
 Campo1, Campo2, Campo3
FROM
 #Sequencial AS TOut
ORDER BY SEQ ASC