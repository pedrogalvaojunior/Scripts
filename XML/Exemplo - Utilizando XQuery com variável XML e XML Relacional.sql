declare @x xml =
'<toys>
	<myToy>
		<name>Train</name>
		<components>
				<part><name>engine</name><HowMany>1</HowMany></part>
				<part><name>coaches</name><HowMany>10</HowMany></part>
				<part><name>caboose</name><HowMany>1</HowMany></part>
				<part><name>tracks</name><HowMany>125</HowMany></part>
				<part><name>switchs</name><HowMany>8</HowMany></part>
				<part><name>power controller</name><HowMany>1</HowMany></part>
		</components>
	</myToy>
	<myToy>
	<name>remote control cart</name>
	<components>
			<part><name>remote control</name><HowMany>1</HowMany></part>
			<part><name>car</name><HowMany>1</HowMany></part>
			<part><name>batteries</name><HowMany>8</HowMany></part>
	</components>
	</myToy>
</toys>
'

--Select @x

--1
Select t.c.value('../../name[1]','Varchar(20)') name,
		   t.c.value('name[1]','Varchar(20)') componentname,
		   t.c.value('HowMany[1]','tinyint') numberOfItems
from @x.nodes('toys/myToy/components/part') t (c)

--2
Select tab.col.value('name[1]','Varchar(20)') name,
		   Tab1.col.value('name[1]','Varchar(20)') componentname,
		   Tab1.col.value('HowMany[1]','Int') numberOfItems
from @x.nodes('/toys/myToy') as tab (col)
Cross Apply tab.col.nodes ('/toys/myToy/components/part') as Tab1(col)

--4
Select t.c.value('name[1]','Varchar(20)') name,
		   t.c.value('(components/part/name)[1]','Varchar(20)') componentname,
		   t.c.value('(components/part/HowMany)[1]','tinyint') numberOfItems
from @x.nodes('toys/myToy') t (c)