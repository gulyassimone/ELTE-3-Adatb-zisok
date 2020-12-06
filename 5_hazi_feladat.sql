--Kik azok a dolgoz�k, akik 1982.01.01 ut�n l�ptek be a c�ghez?
select dnev from dolgozo where belepes > to_date('1982.01.01','YYYY.MM.DD');

--Adjuk meg azon dolgoz�kat, akik nev�nek m�sodik bet�je A.
select dnev from  dolgozo
where lower(dnev) like '_a%';

--Adjuk meg azon dolgoz�kat, akik nev�ben van legal�bb k�t L bet�.
select dnev from  dolgozo
where lower(dnev) like '%l%l%';

--Adjuk meg a dolgoz�k nev�nek utols� h�rom bet�j�t.
select dnev, substr(dnev, -3,3) from  dolgozo;

--Adjuk meg a dolgoz�k fizet�seinek n�gyzetgy�k�t k�t tizedesre, �s ennek eg�szr�sz�t.
select --fizetes, 
    round(sqrt(fizetes),2) tizedes,
    round(sqrt(fizetes)) kerekites--,
    --ceil(sqrt(fizetes)) egesz_resz 
from  dolgozo;

--Adjuk meg, hogy h�ny napja dolgozik a c�gn�l ADAMS �s milyen h�napban l�pett be.
select dnev, round(sysdate  - belepes) napja_dolgozik, extract(month from belepes) belepes_honap
from  dolgozo;

--Adjuk meg azokat a (n�v, f�n�k) p�rokat, ahol a k�t ember neve ugyanannyi bet�b�l �ll.
select d1.dnev beosztott, d2.dnev fonok
from  dolgozo d1
join  dolgozo d2
on d1.fonoke = d2.dkod
where length(d1.dnev) = length(d2.dnev);

--List�zzuk ki a dolgoz�k nev�t �s fizet�s�t, valamint jelen�ts�k meg a fizet�st grafikusan �gy, hogy a fizet�st 1000 Ft-ra kerek�tve, minden 1000 Ft-ot egy # jel jel�l.
select dnev,fizetes, RPAD(' ', (fizetes/1000)+1, '#') ll
from  dolgozo d;

--List�zzuk ki azoknak a dolgoz�knak a nev�t, fizet�s�t, jutal�k�t, �s a jutal�k/fizet�s ar�ny�t, akiknek a foglalkoz�sa elad� (salesman). Az ar�nyt k�t tizedesen jelen�ts�k meg.
select dnev,fizetes,jutalek,round(nvl(jutalek,1)/fizetes,2)arany
from  dolgozo d;







