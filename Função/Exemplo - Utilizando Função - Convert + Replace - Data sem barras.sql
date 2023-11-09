select * from cadmicros

set dateformat dmy

select convert(char(8),GetDate(),112) from cadmicros

Select SubString(Convert(Char(8),Data_ProductKey,112),7,2)+
          SubString(Convert(Char(8),Data_ProductKey,112),5,2)+
          SubString(Convert(Char(8),Data_ProductKey,112),1,4) from CadMicros

select replace(convert(char(8),getdate(),112),'/','')

select data_productkey from cadmicros

select replace(convert(char(10),getdate(),103),'/','')

