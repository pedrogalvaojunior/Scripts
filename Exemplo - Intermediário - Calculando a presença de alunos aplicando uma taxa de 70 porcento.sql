declare @Aulas table
(Disciplina varchar(20), Inicio datetime, Fim datetime);

insert into @Aulas values
('Portugues', '20180405 07:00', '20180405 7:50'),
('Matemática', '20180405 07:50', '20180405 08:40'),
('Ed. Física', '20180405 08:40', '20180405 09:30'),
('Redação', '20180405 09:40', '20180405 10:30'),
('Química', '20180405 10:30', '20180405 11:20');

declare @HorariosCatraca table
(Entrada datetime, Saida datetime);

insert into @HorariosCatraca values
('20180405 7:00', '20180405 8:00');

select
    a.Disciplina,
    a.Inicio,
    a.Fim,
    case when 100.0 * datediff(minute, o.Entrada, o.Saida) / datediff(minute, a.Inicio, a.Fim) >= 70
        then 'Presente'
        else 'Falta'
    end
from @Aulas as a
outer apply
(
    select top(1)
        case when h.Entrada > a.Inicio then h.Entrada else a.Inicio end as Entrada,
        case when h.Saida < a.Fim then h.Saida else a.Fim end as Saida
    from @HorariosCatraca as h
    where
        h.Entrada <= a.Fim and
        h.Saida >= a.Inicio
) as o