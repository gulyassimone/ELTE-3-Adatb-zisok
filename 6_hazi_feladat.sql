--Adjuk meg az �tlagfizet�st azokon az oszt�lyokon, ahol legal�bb 4-en dolgoznak (oazon, avg_fiz)
select oazon, avg(fizetes)  avg_fiz 
from dolgozo 
group by oazon having count(distinct dkod)>4

--Adjuk meg az �tlagfizet�st �s telephelyet azokon az oszt�lyokon, ahol legal�bb 4-en dolgoznak. (oazon, telephely, avg_fiz)
select oazon, avg(fizetes)  avg_fiz, telephely 
from dolgozo 
natural join osztaly 
group by oazon , telephely having count(distinct dkod)>4;
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, ahol az �tlagfizet�s nagyobb mint 2000. (onev, telephely)
select onev,telephely 
from dolgozo 
natural join osztaly 
group by onev,telephely 
having avg(fizetes)>2000
--Adjuk meg azokat a fizet�si kateg�ri�kat, amelybe pontosan 3 dolgoz� fizet�se esik. (kategoria)
select kategoria 
from fiz_kategoria 
join dolgozo 
on fizetes>also and fizetes < felso 
group by kategoria having count(distinct dkod) =3;
--Adjuk meg azokat a fizet�si kateg�ri�kat, amelyekbe es� dolgoz�k mindannyian ugyanazon az oszt�lyon dolgoznak. (kategoria)
select kategoria 
from fiz_kategoria 
join dolgozo 
on fizetes>also and fizetes < felso 
group by kategoria having count(distinct nvl(oazon,-1)) =1;
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek van 1-es fizet�si kateg�ri�j� dolgoz�ja. (onev, telephely)
select distinct onev, telephely 
from fiz_kategoria 
join dolgozo d 
on fizetes>also and fizetes < felso 
left join osztaly o on d.oazon = o.oazon
where kategoria = 1;
--Adjuk meg azon oszt�lyok nev�t �s telephely�t, amelyeknek legal�bb 2 f� 1-es fiz. kateg�ri�j� dolgoz�ja van. (onev, telephely)
select o.onev, o.telephely from fiz_kategoria f
join dolgozo d 
on d.fizetes>f.also and d.fizetes < f.felso 
left join osztaly o 
on d.oazon = o.oazon 
where kategoria = 1 
group by o.onev, o.telephely 
having count(distinct nvl(d.dkod,-1))>1;
--List�zzuk ki foglalkoz�sonk�nt a dolgoz�k sz�m�t, �tlagfizet�s�t (kerek�tve) numerikusan �s grafikusan is. 200-ank�nt jelen�ts�nk meg egy #-ot.
select foglalkozas, count(distinct dkod), avg(fizetes), rpad(' ', avg(fizetes)/200+1,'#') 
from dolgozo d group by foglalkozas 
