

-----1) Выведем ТОП-10 ресторанов с лушчши средним рейтингом рейтингом

select * from   (select rating_final.placeid, avg(rating) from rating_final group by  rating_final.placeid)t   order by avg desc limit 10;

-----2) Выведем количество клиентов ресторанов в каждом городе
with cte2 as (select distinct userid, city  from rating_final  r inner join geoplaces2  g on r.placeid=g.placeid where city is not null)
select distinct city, count(userid) over (PARTITION BY  city) as num from cte2 limit 10;

------3)   Выведем посетителей которые посещеют рестораны   и японской и китайской кухни

with cte2 as (select  distinct userid, restcuisine from chefmoz ch inner join rating_final r on r.placeid=ch.placeid)
select *  into Jap_Chi from(
select userid from cte2 where restcuisine='Chinese'
intersect
select userid from cte2 where restcuisine='Japanese') g;
select * from Jap_Chi;
------4)   Определим входят ли хотя бы одна из кухонь в их предпочтения

 select distinct userid from users where rcuisine='Chinese' or rcuisine='Japanese'
 intersect
 select userid from Jap_Chi;
------5)   Определим средний рейтинг ресторанов  каждой ценовой категории
select distinct g.price,  avg(r.rating) over (partition by g.price) from rating_final r inner join geoplaces2 g on  r.placeid=g.placeid limit 10;



------6)  опредлим насколько репрезентативны оценки( насколько отличаются худшие и лучшие ресторанов, также учтем количство оценок) и выведем средний рейтинг с наименьшей волатильностью
select * from (
select distinct placeid, max(rating) over (PARTITION by placeid)-min(rating) over (PARTITION by placeid) as razn, avg(rating) over (PARTITION by placeid) from rating_final  

where placeid in( select  placeid  from rating_final group by placeid having count(rating)>5 ))h  where razn<2 order by  avg desc, razn   limit 10;


------7)  Определим долю курящих посетителей в  ресторанах

with  cte as ( select distinct r.userid, smoker, r.placeid from rating_final r inner join  users u on r.userid=u.userid),
smoke as (select placeid, count ( userid) as count_smoke from cte  where smoker=true  group by placeid ),
all_ as (select placeid, count (userid) as count_all from cte group by placeid )
select * into PLACE_SMOKE FROM(
select all_.placeid,(count_smoke::NUMERIC/count_all *100) AS PERCENT from all_ LEFT join smoke on smoke.placeid=all_.placeid )  X ORDER BY PERCENT ASC;
select * FROM PLACE_SMOKE limit 10;


------8) Определим некурящие рестораны, где больинство посетителей - курильщики


select g.placeid  from geoplaces2 g inner join PLACE_SMOKE p on p.placeid=g.placeid where smoking_area='not permitted' and PERCENT>50;


------9)  Определим количство ресторанов на 100 0000 населения

select  distinct g.city, ((count( placeid) over (PARTITION by g.city))::NUMERIC/population * 100000) as t from geoplaces2 g LEFT join cities c on g.city=c.city ;


------10)  Определим количство тучных посетителей ресторанов в каждом городе
select distinct  city, count (userid ) OVER (PARTITION BY city) FROM (
select userid, city from rating_final r inner join geoplaces2 g on g.placeid=r.placeid
where  CITY IS NOT NULL AND userid in (
select userid from users where weight> 90) ) X LIMIT 10 ;

-------------------------ПРЕДСТАВЛЕНИЯ----------------------
------1) МОЛОДЫЕ ПЬЯНИЦЫ
CREATE VIEW  young_drunkards AS 
select userid from users
where birth_year> 1988 and drink_level='casual drinker';
select * from young_drunkards limit 2;


------2) Посетители-город

CREATE VIEW users_city AS 
select distinct userid, city from rating_final r LEFT join geoplaces2 g  on g.placeid=r.placeid;
select * from users_city limit 5;


