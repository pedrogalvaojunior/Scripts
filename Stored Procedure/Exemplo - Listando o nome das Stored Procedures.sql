SELECT

OBJECT_NAME([Object_Id]) As [Procedure], [definition] as Estrutura

FROM

sys.sql_modules

WHERE

OBJECTPROPERTY([Object_Id],'IsProcedure') = 1

 

SELECT

OBJECT_NAME(ID) As [Procedure], [text] as Estrutura

FROM

syscomments

WHERE

OBJECTPROPERTY(ID,'IsProcedure') = 1
