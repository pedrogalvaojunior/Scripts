CREATE TABLE Cadastro (ID int, Nome varchar(40), Foto varbinary(max));

-- simulação do cadastro
INSERT into Cadastro values 
     (1, 'funcionário 1', 0xFFD8FFE00010),
     (2, 'funcionário 2', 0x474946383961C2),
     (3, 'funcionário 3', 0x89504E470D0A1A);
go

-- função que decodifica o tipo
CREATE FUNCTION DecodHeader (@Header varchar(20))
  returns table as return
SELECT case when Left(@Header, 2) = 0xFFD8 then 'jpeg'
            when Left(@Header, 3) = 'GIF' then 'gif'
            when Substring(@Header, 2, 3) = 'PNG' then 'png' 
            else '?' end as Tipo;
go

--
SELECT C.ID, C.Nome, H.Tipo
  from Cadastro as C
       cross apply dbo.DecodHeader(Convert(varchar(20), Foto)) as H;