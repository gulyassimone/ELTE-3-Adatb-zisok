--Kik azok a dolgozók, akik 1982.01.01 után léptek be a céghez?
select dnev from dolgozo where belepes > to_date('1982.01.01','YYYY.MM.DD');

--Adjuk meg azon dolgozókat, akik nevének második betûje A.
select dnev from  dolgozo
where lower(dnev) like '_a%';

--Adjuk meg azon dolgozókat, akik nevében van legalább két L betû.
select dnev from  dolgozo
where lower(dnev) like '%l%l%';

--Adjuk meg a dolgozók nevének utolsó három betûjét.
select dnev, substr(dnev, -3,3) from  dolgozo;

--Adjuk meg a dolgozók fizetéseinek négyzetgyökét két tizedesre, és ennek egészrészét.
select --fizetes, 
    round(sqrt(fizetes),2) tizedes,
    round(sqrt(fizetes)) kerekites--,
    --ceil(sqrt(fizetes)) egesz_resz 
from  dolgozo;

--Adjuk meg, hogy hány napja dolgozik a cégnél ADAMS és milyen hónapban lépett be.
select dnev, round(sysdate  - belepes) napja_dolgozik, extract(month from belepes) belepes_honap
from  dolgozo;

--Adjuk meg azokat a (név, fõnök) párokat, ahol a két ember neve ugyanannyi betûbõl áll.
select d1.dnev beosztott, d2.dnev fonok
from  dolgozo d1
join  dolgozo d2
on d1.fonoke = d2.dkod
where length(d1.dnev) = length(d2.dnev);

--Listázzuk ki a dolgozók nevét és fizetését, valamint jelenítsük meg a fizetést grafikusan úgy, hogy a fizetést 1000 Ft-ra kerekítve, minden 1000 Ft-ot egy # jel jelöl.
select dnev,fizetes, RPAD(' ', (fizetes/1000)+1, '#') ll
from  dolgozo d;

--Listázzuk ki azoknak a dolgozóknak a nevét, fizetését, jutalékát, és a jutalék/fizetés arányát, akiknek a foglalkozása eladó (salesman). Az arányt két tizedesen jelenítsük meg.
select dnev,fizetes,jutalek,round(nvl(jutalek,1)/fizetes,2)arany
from  dolgozo d;







