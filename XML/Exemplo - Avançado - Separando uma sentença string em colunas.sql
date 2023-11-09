create table temp
(Valores varchar(500))
Go

Insert Into temp Values('
<2>9999 999999999</2><4>Whatsapp Proprio</4><3>9999 999999999</3><5>Irmã Tem Whatsapp</5><6>9999  99999999</6><7>Clinica do Cliente</7><8>9999 999999999</8><9>Vizinho</9><10>9999  99999999</10><11>Outra Vizinha</11><12>9999  9999999</12><13>Comercial da Vizinha</13><14>9999 999999999</14><15>Prima da Mae</15><16>9999 999999999</16><17>Whats da Avo do Namorado</17><18>9999  99999999</18><19>Irmã da Cunhada</19><20>9999 999999999</20><21>Whatsapp do Patrão</21><1>2</1>')

-- código #1
;with toXML as (
SELECT cast ('<N>'+replace (replace (Valores, '<', '<N'), '<N/', '</N')+'</N>' as xml) as Ix
  from TEMP
)
SELECT -- telefone 1
       Ix.value('(N/N2)[1]', 'varchar(20)') as [Telefone 1],
       Ix.value('(N/N4)[1]', 'varchar(20)') as [Observações telefone 1],
       -- telefone 2
       Ix.value('(N/N3)[1]', 'varchar(20)') as [Telefone 2],
       Ix.value('(N/N5)[1]', 'varchar(20)') as [Observações telefone 2],
       -- telefone 3
       Ix.value('(N/N6)[1]', 'varchar(20)') as [Telefone 3],
       Ix.value('(N/N7)[1]', 'varchar(20)') as [Observações telefone 3]
       -- e em diante
  from toXML;