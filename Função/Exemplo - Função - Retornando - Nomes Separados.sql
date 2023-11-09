CREATE TABLE Nomes (Nome VARCHAR(80))    
2   
3 INSERT INTO Nomes VALUES ('Joana Maria')   
4 INSERT INTO Nomes VALUES ('Ana Paula Silveira')   
5 INSERT INTO Nomes VALUES ('Pedro Paulo Almeida')   
6 INSERT INTO Nomes VALUES ('Carlos Eduardo da Silva')   
7 INSERT INTO Nomes VALUES ('Rodrigo Diógenes Cunha Meira')   
8 INSERT INTO Nomes VALUES ('Maria')   
9   
10 ;WITH ResXML (Nome, NomeXML)   
11 AS (   
12 SELECT Nome, CAST('<N><n>' +   
13     REPLACE(Nome,' ','</n><n>') +   
14     '</n></N>' AS XML) FROM Nomes)   
15   
16 SELECT Nome,   
17     Nomes.N.value('(./text())[1]','nvarchar(50)') As Nome   
18 FROM ResXML   
19 CROSS APPLY NomeXML.nodes('./N/n') As Nomes(N)  


CREATE FUNCTION dbo.SeparaNomes (@Nome VARCHAR(MAX))   
2 RETURNS @T TABLE (ParteNome NVARCHAR(50))   
3 AS  
4 BEGIN  
5     DECLARE @NomeXML XML   
6     SET @NomeXML = '<N><n>' + REPLACE(@Nome,' ','</n><n>') + '</n></N>'  
7   
8     INSERT INTO @T   
9     SELECT Nomes.N.value('(./text())[1]','nvarchar(50)') As ParteDoNome   
10     FROM @NomeXML.nodes('./N/n') As Nomes(N)   
11   
12     RETURN  
13 END  
14   
15 SELECT * FROM dbo.SeparaNomes ('Carlos Eduardo da Silva')  
