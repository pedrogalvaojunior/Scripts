select
    Empresas,
    [0] as [0:00],
    [1] as [1:00],
    [2] as [2:00],
    [3] as [3:00],
    [4] as [4:00],
    [5] as [5:00],
    [6] as [6:00],
    [7] as [7:00],
    [8] as [8:00],
    [9] as [9:00],
    [10] as [10:00],
    [11] as [11:00],
    [12] as [12:00],
    [13] as [13:00],
    [14] as [14:00],
    [15] as [15:00],
    [16] as [16:00],
    [17] as [17:00],
    [18] as [18:00],
    [19] as [19:00],
    [20] as [20:00],
    [21] as [21:00],
    [22] as [22:00],
    [23] as [23:00]
from
(
    select Empresas, DATEPART(HOUR, ColunaHorario) as Hora
    from Transito
    inner join Empresas on Empresas.id = Transito.id
    where Transito.Data between @dataini and @datafim)
) as t
pivot
(
    count(Hora) for Hora in ([0], [1], [2], [3], [4], [5], [6], 
                             [7], [8], [9], [10], [11], [12], 
                             [13], [14], [15], [16], [17], [18],
                             [19], [20], [21], [22], [23], [24])
) as p