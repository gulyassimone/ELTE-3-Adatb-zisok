--Adjuk meg az átlagfizetést azokon az osztályokon, ahol legalább 4-en dolgoznak (oazon, avg_fiz)
select oazon, avg(fizetes)  avg_fiz 
from dolgozo 
group by oazon having count(distinct dkod)>4

--Adjuk meg az átlagfizetést és telephelyet azokon az osztályokon, ahol legalább 4-en dolgoznak. (oazon, telephely, avg_fiz)
select oazon, avg(fizetes)  avg_fiz, telephely 
from dolgozo 
natural join osztaly 
group by oazon , telephely having count(distinct dkod)>4;
--Adjuk meg azon osztályok nevét és telephelyét, ahol az átlagfizetés nagyobb mint 2000. (onev, telephely)
select onev,telephely 
from dolgozo 
natural join osztaly 
group by onev,telephely 
having avg(fizetes)>2000
--Adjuk meg azokat a fizetési kategóriákat, amelybe pontosan 3 dolgozó fizetése esik. (kategoria)
select kategoria 
from fiz_kategoria 
join dolgozo 
on fizetes>also and fizetes < felso 
group by kategoria having count(distinct dkod) =3;
--Adjuk meg azokat a fizetési kategóriákat, amelyekbe esõ dolgozók mindannyian ugyanazon az osztályon dolgoznak. (kategoria)
select kategoria 
from fiz_kategoria 
join dolgozo 
on fizetes>also and fizetes < felso 
group by kategoria having count(distinct nvl(oazon,-1)) =1;
--Adjuk meg azon osztályok nevét és telephelyét, amelyeknek van 1-es fizetési kategóriájú dolgozója. (onev, telephely)
select distinct onev, telephely 
from fiz_kategoria 
join dolgozo d 
on fizetes>also and fizetes < felso 
left join osztaly o on d.oazon = o.oazon
where kategoria = 1;
--Adjuk meg azon osztályok nevét és telephelyét, amelyeknek legalább 2 fõ 1-es fiz. kategóriájú dolgozója van. (onev, telephely)
select o.onev, o.telephely from fiz_kategoria f
join dolgozo d 
on d.fizetes>f.also and d.fizetes < f.felso 
left join osztaly o 
on d.oazon = o.oazon 
where kategoria = 1 
group by o.onev, o.telephely 
having count(distinct nvl(d.dkod,-1))>1;
--Listázzuk ki foglalkozásonként a dolgozók számát, átlagfizetését (kerekítve) numerikusan és grafikusan is. 200-anként jelenítsünk meg egy #-ot.
select foglalkozas, count(distinct dkod), avg(fizetes), rpad(' ', avg(fizetes)/200+1,'#') 
from dolgozo d group by foglalkozas 
