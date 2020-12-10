CREATE OR REPLACE PROCEDURE kozos_oszto(x int, y int) IS
begin 
    for i in 2..least( x , y )
    loop
        if mod(x, i) = 0 and mod(y, i) = 0
        then 
            dbms_output.put_line(i );
        end if;
    end loop;
end kozos_oszto;

set serveroutput on;
call kozos_oszto(1000,100);


CREATE TABLE dolgozo2 AS SELECT 1 uj_fizetes, dolgozo.* FROM dolgozo;
SELECT * FROM dolgozo2;

CREATE OR REPLACE PROCEDURE szazalek(x int) IS
cursor curs1 is select * from dolgozo2 where fizetes < (select avg(fizetes) from dolgozo2) for update of dolgozo2.fizetes;
begin 
    for rec in curs1
    loop
        UPDATE dolgozo2 SET uj_fizetes = fizetes * (1+ x /100)  WHERE CURRENT OF curs1;
    end loop;
end szazalek;

set serveroutput on;
call szazalek(10);

CREATE TABLE dolgozo3 AS SELECT 1 uj_fizetes, dolgozo.* FROM dolgozo;
SELECT * FROM dolgozo3
order by foglalkozas, fizetes desc;

declare 
cursor curs1 is select * from dolgozo3 d1
join (select min(fizetes)min_fiz, max(fizetes) max_fiz, avg(fizetes) avg_fiz , foglalkozas from dolgozo3 group by foglalkozas) d2
on d1.fizetes = min_fiz
and d1.foglalkozas = d2.foglalkozas
for update of d1.fizetes;
begin 
 for rec in curs1 
 loop
    update dolgozo3 set uj_fizetes = fizetes + (rec.max_fiz - rec.avg_fiz) * 0.2 WHERE CURRENT OF curs1;
 end loop;
end;

CREATE TABLE dolgozo4 AS SELECT 1 plusz, dolgozo.* FROM dolgozo;
SELECT * FROM dolgozo4
order by foglalkozas, fizetes desc;

declare 
cursor curs1 is select d1.plusz, d2.n, d1.fizetes from dolgozo4 d1
join (select count(*) n , foglalkozas from dolgozo3 group by foglalkozas) d2
on nvl(d1.foglalkozas,'%') = nvl(d2.foglalkozas,'%')
for update of d1.fizetes;
begin 
 for rec in curs1 
 loop
    update dolgozo4 set plusz =  rec.fizetes / rec.n WHERE CURRENT OF curs1;
 end loop;
end;

CREATE TABLE dolgozo5 AS SELECT 1 uj_fizetes, dolgozo.* FROM dolgozo;
SELECT * FROM dolgozo5;

CREATE OR REPLACE function noveles return int IS
cursor curs1 is select * from dolgozo5 d1 join (select avg(fizetes)avg_fiz, oazon from dolgozo group by oazon) d2
on d2.oazon = d1.oazon
where fizetes < avg_fiz;
szum int := 0;
begin 
    for rec in curs1
    loop
    IF REC.DKOD MOD 2 = 0 THEN
        szum := szum + (rec.avg_fiz - rec.fizetes) * 0.2;
    end if;
    end loop;
    return szum;
end noveles;

select noveles() from dual;

CREATE OR REPLACE function noveles2 return int IS
cursor curs1 is select * from dolgozo5 d1 join (select avg(fizetes)avg_fiz, oazon from dolgozo group by oazon) d2
on d2.oazon = d1.oazon
where fizetes < avg_fiz
for update of d1.uj_fizetes;
szum int := 0;
begin 
    for rec in curs1
    loop
    IF REC.DKOD MOD 2 = 0 THEN
        update dolgozo5 set uj_fizetes = rec.fizetes + ((rec.avg_fiz - rec.fizetes) * 0.2) where current of curs1;
        szum := szum + (rec.avg_fiz - rec.fizetes) * 0.2;
    end if;
    end loop;
    return szum;
end noveles2;

select noveles2() from dual;

CREATE OR REPLACE procedure noveles3  IS
cursor curs1 is select * from dolgozo5 d1 join (select avg(fizetes)avg_fiz, oazon from dolgozo group by oazon) d2
on d2.oazon = d1.oazon
where fizetes < avg_fiz
for update of d1.uj_fizetes;
szum int := 0;
begin 
    for rec in curs1
    loop
    IF REC.DKOD MOD 2 = 0 THEN
        update dolgozo5 set uj_fizetes = rec.fizetes + ((rec.avg_fiz - rec.fizetes) * 0.2) where current of curs1;
        szum := szum + (rec.avg_fiz - rec.fizetes) * 0.2;
    end if;
    end loop;
end noveles3;
set serveroutput on;
call noveles3();
SELECT * FROM dolgozo5;


var myVar VARCHAR2
call noveles2() INTO :myVar;
dbms_out.put_line(myVar);

select myVar from dual;
