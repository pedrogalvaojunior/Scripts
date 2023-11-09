-- Utilizando Set Ansi_Nulls On --
SET ANSI_NULLS ON
Declare @i int

--Test #1
If @i is null
 Print 'i is null'
Else
 Print 'i is not null'

--Test #2
if @i = 0
 Print 'i = 0'
Else
 Print 'i <> 0'

--Test #3
If not @i = 0
 Print 'i <> 0'
Else
 Print 'i = 0'
 
-- Utilizando Set Ansi_Nulls OFF --
Declare @i int

--Test #1
If @i is null
 Print 'i is null'
Else
 Print 'i is not null'

--Test #2
if @i = 0
 Print 'i = 0'
Else
 Print 'i <> 0'

--Test #3
If not @i = 0
 Print 'i <> 0'
Else
 Print 'i = 0'

-- ANSWERS:

A) i is null
i <> 0
i = 0

B) i is null
i <> 0
i <> 0

C) i is null
i = 0
i = 0

D) i is null
i = 0
i <> 0

Always A   
Always B   
Always C   
Always D   
A when SET ANSI_NULLS is ON, B when SET ANSI_NULLS is OFF  -- Correta --
A when SET ANSI_NULLS is OFF, B when SET ANSI_NULLS is ON  
