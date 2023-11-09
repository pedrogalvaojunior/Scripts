SELECT Values.Prefix + Values1.Suffix As Name, 
       Values.Number
FROM (VALUES ('a', 1), ('de', 2)) As Values (Prefix, Number),
     (VALUES ('pple'), ('ttach'), ('manda')) As Values1 (Suffix)
Go