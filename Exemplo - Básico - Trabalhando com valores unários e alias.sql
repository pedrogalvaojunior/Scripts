Declare @b Int

Select 0 [A],
 B = 1, -- 1
 1 ++ 1 As [C],
 1 +-+ 1 As [D],
 1 -+- 1 As [E],
 1 - - 1 As [F]

Print 'Result: ' + Cast(@b As Varchar(10))