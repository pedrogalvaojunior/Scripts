select * from cmpprodutos
where descricao like 'banac%'
select * from gerpessoas
select * from cmpprodxfornec

select cmp.codprodsequencial, cmp.codantigo, cmp.descricao,
       ger.codcadgeral, ger.codantigo, ger.razaosocial
from cmpprodutos cmp inner join cmpprodxfornec cmpp
                      on cmp.codprodsequencial = cmpp.codprodsequencial
                     inner join gerpessoas ger
                      on ger.codcadgeral = cmpp.codcadgeral
where cmp.codantigo='955012009'         



