create or replace function hanyszor (p1 Varchar, p2 Varchar) return int is
db int := 0;
BEGIN 
    for i in 1..LENGTH(p1) - LENGTH(p2) + 1
    LOOP
        if substr(p1,i,2) = p2
        then
            db := db + 1;
        end if;
    END LOOP;
return db;
end hanyszor;

select hanyszor('abcabcab','ab') from dual;


create or replace procedure valami is 
    cursor curs1 is select * from dolgozo;
    rec1 curs1%ROWTYPE; --objektum fugvvenzeit, adattagjait lekeri de mar nem kell
BEGIN
    OPEN curs1;
        LOOP
           FETCH curs1 INTO rec1;
            if curs1%NOTFOUND THEN
                EXIT;
            end if;
            dbms_output.put_line(rec1.dnev || '-' || rec1.fizetes);
        END LOOP;
    CLOSE curs1;
END valami;

set serveroutput on;
call valami();

create or replace procedure valami_uj is 
    cursor curs1 is select * from dolgozo;
BEGIN
    for rec1 in curs1
    LOOP
        dbms_output.put_line(rec1.dnev || '-' || rec1.fizetes);
    END LOOP;
END valami_uj;

set serveroutput on;
call valami_uj();


create or replace function valami_avg return int is 
    cursor curs1 is select * from dolgozo;
    szum int := 0;
    db int := 0;
BEGIN
    for rec1 in curs1
        LOOP
        
            szum := szum + rec1.fizetes ;
            db := db + 1;
            
        END LOOP;
    if db > 0 then 
        return szum/db;
    else return 0;
    end if;
END valami_avg;

select valami_avg() from dual;

ACCEPT asd VARCHAR2 PROMPT 'Add meg a neved';

select * from dolgozo where dnev = '&asd';

set serveroutput on;
DECLARE 
    cursor curs1 is select * from dolgozo where oazon = &oaz;
BEGIN
    for rec in curs1 loop 
        dbms_output.put_line(rec.dnev);
    end loop;
END;



