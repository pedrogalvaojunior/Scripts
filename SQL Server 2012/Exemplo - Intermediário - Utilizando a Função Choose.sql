CREATE TABLE #Leaders(title INT,Name VARCHAR(50),Score INT) 

Insert Into #Leaders
Values(1,'GilaMonster',35452),
(1,'Jeff Moden',31783),
(1,'Steve Jones',30901),
(2,'RBarryYoung',9851),
(2,'Koen Verbeeck',8842),
(3,'Matt Miller', 6980),
(3,'WayneS',6284),
(4,'someone',3657)

SELECT CHOOSE(Title,'SS Champion','SS Crazy Eights','SS Certifiable','Hall of Fame') AS Title 

,Name,Score 

FROM #Leaders