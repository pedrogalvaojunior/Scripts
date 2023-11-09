select j.name, s.step_name, s.command from sysjobsteps s inner join sysjobs j
																			on s.job_id = s.job_id
where command like '%Backup-Master%'

select * from sysjobs

C96DABE2-4334-476B-BF4C-39E1E6BD1F06