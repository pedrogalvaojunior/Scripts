Create Table #A (x Char(2));

Insert Into #A Values ('1');
Insert Into #A Values ('6');
Insert Into #A Values ('2');
Insert Into #A Values ('3');
Insert Into #A Values ('5');
Insert Into #A Values ('5');
Insert Into #A Values ('6');
Insert Into #A Values ('9');
Go

Create Table #B (M BigInt);

Insert Into #B Values(5);
Insert Into #B Values(5);
Insert Into #B Values(6);
Insert Into #B Values(7);
Insert Into #B Values(7);
Go

SELECT x AS 'Select #1' FROM #A
   INTERSECT SELECT M FROM #B;

-- (Select #2)
SELECT DISTINCT(x) AS 'Select #2' 
 FROM #A 
  LEFT OUTER JOIN #B
   ON #A.x = #B.M

-- (Select #3)
SELECT DISTINCT(x) AS 'Select #3' 
 FROM #A 
  LEFT OUTER JOIN #B
   ON #A.x = #B.M

-- (Select #4)
SELECT DISTINCT(x) AS 'Select #4' 
 FROM #A 
  INNER JOIN #B 
   ON #A.x = #B.M

-- (Select #5)
SELECT x AS 'Select #5' 
 FROM #A 
  INNER JOIN #B
    ON #A.x = #B.M