create table t1(c1 int);
insert into t1(c1) values(1), (2), (3), (4);

create table t2(c2 int);
insert into t2(c2) values(1), (2);

select c1
from t1
where t1.c1 in (select c1 from t2);