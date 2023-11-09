SELECT Getdate()

SELECT DatePart(dd,Getdate())
SELECT DatePart(hh,Getdate())
SELECT DatePart(yy,Getdate())
SELECT DatePart(mm,Getdate())

SELECT DateAdd(dd,1,Getdate())

SELECT Convert(char(10),getdate(),103)

SELECT Cast(10.00 as Char(10))

SELECT Power(5,2)

SELECT SQRT(25)

SELECT User
SELECT User_Name()
SELECT User_id()
/* *************************************** */
Exec SP_HelpFileGroup
Exec SP_HelpFile
Exec SP_Help
Exec SP_Rename
Exec SP_Renamedb