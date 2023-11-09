 Declare @MyTable Table
  (MyID Int)

Insert Into @MyTable Values(1),(2),(3),(4),(5)

--select MyID + ';' from @MyTable for xml path('') 
 
--select MyID as "text()" + ';' as "text()" from @MyTable for xml path('') 
 
select MyID as "text()", ';' as "text()" from @MyTable for xml path('') 
 
select MyID + ';' as "text()" from @MyTable for xml path('') 