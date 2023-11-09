CREATE DATABASE TESTE

Set Ansi_Padding OFF

Create TABLE T1
 (CODIGO VARCHAR(3),
  CODIGO1 VARCHAR(3),
  CODIGO2 VARCHAR(3))

-- O Ansi Padding Status tem que estar em False --
Select Case ColumnProperty(Object_Id('T1'),'codigo','UsesAnsiTrim') 
            When 0 Then 'False'
            When 1 Then 'True'
           End As Ansi_Padding_Status_On
          

--Alterando o Ansi_Padding_Status para True --
Set Ansi_Padding On
alter table t1
 alter column codigo varchar(3)

-- O Ansi Padding Status tem que estar em True --
Select Case ColumnProperty(Object_Id('T1'),'codigo','UsesAnsiTrim') 
            When 0 Then 'False'
            When 1 Then 'True'
           End As Ansi_Padding_Status_On
