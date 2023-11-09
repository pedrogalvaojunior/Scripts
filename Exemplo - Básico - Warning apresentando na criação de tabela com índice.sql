Create table sales
(
COL1 varchar(20) not null,
COL2 varchar(600) not null,
COL3 varchar(400) not null,
date datetime not null,
Unique clustered (COL2, COL3)
)