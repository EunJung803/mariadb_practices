select version(), current_date(), now() from dual;

-- 수학함수 , 사칙연산도 된다.
select sin(pi()/4), 1 + 2 * 3 - 4 / 5 from dual;

-- 대소문자 구분이 없다.
sELecT VERSION(), current_date(), NOW() fRom DUAL;

-- table 생성 : DDL
create table pet(
	name varchar(100),
    owner varchar(50),
    species varchar(20),
    gender char(1),
    birth date,
    death date
);

-- schema 확인
describe pet;
desc pet;

-- table 삭제
drop table pet;
show tables;

-- insert : DML (C)
insert into pet values('뿌식이', '김은정', 'hamster', 'f', '2000-03-25', null);

-- select : DML (R)
select * from pet;

-- update : DML (U)
update pet set name='이뿌식'
where name='뿌식이';

-- delete : DML (D)
delete from pet where name='이뿌식';

-- load data : mySQL (CLI) 전용
load data local infile '/root/pet.txt' into table pet;

-- select 연습
select name, species
from pet
where name='bowser';

select name, species, birth
from pet
where birth>='1998-01-01';

select name, species, gender
from pet
where gender='f' and species='dog';

select name, species
from pet
where species='bird' or species='snake';

select name, birth
from pet
order by birth asc;

select name, birth
from pet
order by birth desc;

select name, birth, death
from pet
where death is not null;

select name
from pet
where name like 'b%';

select name
from pet
where name like '%fy';

select name
from pet
where name like '%w%';

select name
from pet
where name like '_____';

select name
from pet
where name like 'b____';

select count(*)
from pet;

select count(death)
from pet;

-- 논리 오류인데 에러가 나지 않음 (mysql)
select name, count(*), max(birth)
from pet;

