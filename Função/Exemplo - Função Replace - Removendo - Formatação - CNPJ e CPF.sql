Declare @Documentos Table 

        (Documento VarChar(20))

 

Insert Into @Documentos Values('255.999.999-01')

Insert Into @Documentos Values('99.223.990-0')

 

Select Replace(Documento,'.','') As 'Campo Formatado sem Ponto', 

       Replace(Documento,'-','') As 'Campo Formatado sem traço',

       Replace(Replace(Documento,'.',''),'-','') As 'Campo Formatado'

from @Documentos
Where Documento = '255.999.999-01'

ou 

Select Replace(Documento,'.','') As 'Campo Formatado sem Ponto', 

       Replace(Documento,'-','') As 'Campo Formatado sem traço',

       Replace(Replace(Documento,'.',''),'-','') As 'Campo Formatado'

from @Documentos
Where Replace(Replace(Documento,'.',''),'-','')  = '25599999901'