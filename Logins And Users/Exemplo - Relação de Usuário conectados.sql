Select SPID As 'Id', 
          Loginame As 'Usu�rio - SQL Server', 
          HostName As 'Computador', 
          NT_Domain As 'Dom�nio', 
          NT_UserName As 'Usu�rio - Dom�nio'
From Master..SysProcesses
Where Loginame <> 'sa'
Order By Loginame