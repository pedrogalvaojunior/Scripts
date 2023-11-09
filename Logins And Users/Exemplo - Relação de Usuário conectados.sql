Select SPID As 'Id', 
          Loginame As 'Usuário - SQL Server', 
          HostName As 'Computador', 
          NT_Domain As 'Domínio', 
          NT_UserName As 'Usuário - Domínio'
From Master..SysProcesses
Where Loginame <> 'sa'
Order By Loginame