Create Table CalendaryJulian
 (CalendaryCodigo Int Identity(40000,1) Primary Key)
Go

Insert Into CalendaryJulian Default Values
Go 10000

Select CalendaryCodigo, 
          Convert(DateTime, CalendaryCodigo) As 'Convertido com Convert()',
		  Cast(CalendaryCodigo As DateTime)  As 'Convertido com Cast()'
From CalendaryJulian
Go
