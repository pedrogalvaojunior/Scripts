Declare @b As Int = 5, 
             @C as Int =5, 
			 @D Int = 5, 
			 @e int = 56

Set @b=5; 
Set @b &=1 -- Bitwise AND EQUALS --
Set @c=5; 
Set @c |=1 -- Bitwise OR EQUALS --
Set @d ^=1 -- (Bitwise Exclusive OR EQUALS) --
Set @e %= 5 -- Modulo EQUALS -- Mod resto da divisão --

Select @b As 'b', 
           @c As 'c', 
		   @d As 'd', 
		   @e As 'e'