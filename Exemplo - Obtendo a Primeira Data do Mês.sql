Declare @Dia Char(2)
Set @Dia=Day(GetDate())
Print @Dia

SELECT Convert(Varchar(2),DAY(GETDATE())-@dia+1)+'/'+
       Convert(Varchar(2),Month(GetDate()))+'/'+Convert(Char(4),Year(GetDate()))