Create Table OcorrenciaQuantidades
(CodigoOcorrencia Int Primary Key Identity(1,1),
 DataOcorrencia Date Not Null,
 StatusOcorrencia Varchar(20) Not Null)

Insert Into OcorrenciaQuantidades (StatusOcorrencia, DataOcorrencia)
Values('Pendente', '2019-04-23'),
('Pendente', '2019-06-22'),
('Pendente', '2019-11-13'),
('Pendente', '2019-08-15'),
('Pendente', '2019-11-13'),
('Pendente', '2019-11-13'),
('Pendente', '2019-11-13'),
('Cancelado', '2019-02-16'),
('Resolvido', '2019-03-26'),
('Resolvido', '2019-12-12'),
('Resolvido', '2019-09-28'),
('Resolvido', '2019-12-12'),
('Resolvido', '2019-09-28')

Select 	
       (CASE Month(A.DataOcorrencia)
        When '1'   THEN 'Janeiro'  
        WHEN '2'   THEN 'Fevereiro'   
        WHEN '3'   THEN 'Março'   
        WHEN '4'   THEN 'Abril' 
        WHEN '5'   THEN 'Maio'     
        WHEN '6'   THEN 'Junho' 
        WHEN '7'   THEN 'Julho' 
        WHEN '8'   THEN 'Agosto' 
        WHEN '9'   THEN 'Setembro' 
        WHEN '10'  THEN 'Outubro' 
        WHEN '11'  THEN 'Novembro' 
        WHEN '12'  THEN 'Dezembro'  
    END) AS 'Mês',
    Year(A.DataOcorrencia) As Ano, 
    Pendente = (Case When StatusOcorrencia = 'Pendente' Then Count(StatusOcorrencia) Else 0 End),    
    Resolvido = (Case When StatusOcorrencia = 'Resolvido' Then Count(StatusOcorrencia) Else 0 End),    
    Cancelado = (Case When StatusOcorrencia = 'Cancelado' Then Count(StatusOcorrencia) Else 0 End)    
From OcorrenciaQuantidades A
Group By Month(A.DataOcorrencia), Year(A.DataOcorrencia), A.StatusOcorrencia
Order By Month(A.DataOcorrencia)

Select 
       (CASE Month(A.DataOcorrencia)
        When '1'   THEN 'Janeiro'  
        WHEN '2'   THEN 'Fevereiro'   
        WHEN '3'   THEN 'Março'   
        WHEN '4'   THEN 'Abril' 
        WHEN '5'   THEN 'Maio'     
        WHEN '6'   THEN 'Junho' 
        WHEN '7'   THEN 'Julho' 
        WHEN '8'   THEN 'Agosto' 
        WHEN '9'   THEN 'Setembro' 
        WHEN '10'  THEN 'Outubro' 
        WHEN '11'  THEN 'Novembro' 
        WHEN '12'  THEN 'Dezembro'  
    END) AS 'Mês',
    Year(A.DataOcorrencia) As Ano, 
    Pendente = (Select Count(StatusOcorrencia) From OcorrenciaQuantidades 
                Where StatusOcorrencia = 'Pendente' 
                And Month(A.DataOcorrencia) = Month(DataOcorrencia)),    
    Resolvido = (Select Count(StatusOcorrencia) From OcorrenciaQuantidades 
                Where StatusOcorrencia = 'Resolvido' 
                And Month(A.DataOcorrencia) = Month(DataOcorrencia)),    
    Cancelado = (Select Count(StatusOcorrencia) From OcorrenciaQuantidades 
                Where StatusOcorrencia = 'Cancelado' 
                And Month(A.DataOcorrencia) = Month(DataOcorrencia))    
From OcorrenciaQuantidades A
Group By Month(A.DataOcorrencia), Year(A.DataOcorrencia), A.StatusOcorrencia
Order By MONTH(A.DataOcorrencia)