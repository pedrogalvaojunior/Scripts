Create Table Sequence
 (Code Int Primary Key Identity(1,1),
  Number BigInt Not Null)
Go

Declare @Counter Int = 1,
        @String Varchar(Max)

While @Counter <=50
Begin

 Insert Into Sequence (Number)
 Select IsNull(Sum(Number),1) from Sequence
 Where Code < @Counter -1

 Set @String = (Select Concat(@String,',',Number) 
                from Sequence 
				Where Code = @Counter)
 
 Set @Counter +=1

End

Update Sequence
Set Number = 0
Where Code = 1


Select Number 'Number List' From Sequence

Select '0'+@String As 'Sequence Fibonacci'
Go

Truncate Table Sequence