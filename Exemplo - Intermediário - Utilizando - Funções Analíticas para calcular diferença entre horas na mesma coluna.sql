Create Table Senhas
(CodigoSequencialSenha SmallInt Identity(1,1) Primary Key Not Null,
 CodigoCaractereSenha Char(4),
 DataCriacaoSenha DateTime)
Go

Insert Into Senhas (CodigoCaractereSenha, DataCriacaoSenha)
Values ('0001','2019-05-30 08:51:00'),
	        ('0001','2019-05-30 11:11:00'),
            ('0002','2019-06-11 17:22:00'),
            ('0002','2019-06-13 13:21:00'),
            ('0003','2019-06-10 15:59:00'),
            ('0002','2019-06-13 14:00:00')
Go

Select Distinct CodigoCaractereSenha, 
           DateDiff(Hour,First_Value(DataCriacaoSenha) Over (Partition By CodigoCaractereSenha Order By DataCriacaoSenha),
		                          Last_Value(DataCriacaoSenha) Over (Partition By CodigoCaractereSenha Order By CodigoCaractereSenha)) As Horas
From Senhas
Go