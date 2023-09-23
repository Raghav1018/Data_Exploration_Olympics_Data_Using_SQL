----1 which team has won the maximum gold medals over the years.


SELECT TOP 1 a.team, COUNT(CASE WHEN ae.medal='Gold' THEN 1 END) as total_gold
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
GROUP BY a.team
ORDER BY total_gold DESC;

SELECT * FROM athlete_events$;
SELECT * FROM athletes$;

--2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver(DOUBT)

WITH A AS(SELECT a.team, ae.year,  COUNT(CASE WHEN ae.medal='Silver' THEN 1 END) as total_silver_medals
, RANK() OVER(PARTITION BY a.team ORDER BY  COUNT(CASE WHEN ae.medal='Silver' THEN 1 END) DESC) AS rnk
FROM  athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
GROUP BY a.team,ae.year)

SELECT a.team, total_silver_medals , MAX(CASE WHEN rnk=1 THEN year END) AS year_of_max_silver
FROM A
GROUP BY a.team,total_silver_medals;


--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years

with cte as (
select a.name, ae.medal
from athlete_events$ as ae
inner join athletes$ as a
on ae.athlete_id = a.id)

SELECT TOP 1 name,COUNT(medal) as total_gold_medals
FROM cte
WHERE name NOT IN (SELECT name FROM cte WHERE medal  IN ('Silver','Bronze'))
AND medal='Gold'
GROUP BY name
ORDER BY total_gold_medals DESC;

--4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.


WITH CTE AS(SELECT ae.year,a.name, COUNT(medal) as total_gold_medals
, RANK() OVER(PARTITION BY ae.year,a.name ORDER BY COUNT(medal) DESC) AS rnk
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
WHERE medal='Gold'
GROUP BY ae.year,a.name)

SELECT year,total_gold_medals,STRING_AGG(name,' , ') as names
FROM CTE
WHERE rnk=1
GROUP BY year,total_gold_medals;

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport

WITH CTE AS(SELECT ae.event,ae.sport,ae.medal,ae.year
,RANK() OVER(PARTITION BY medal ORDER BY ae.year) as rnk
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
WHERE team='India' and medal IN('Gold','Silver','Bronze'))

SELECT  DISTINCT *
FROM CTE
WHERE rnk=1;


--6 find players who won gold medal in summer and winter olympics both.

select a.name
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
WHERE medal='Gold'
GROUP BY a.name
HAVING COUNT(DISTINCT ae.season)=2;

--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.

select a.name,ae.year
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
WHERE medal NOT IN ('NA')
GROUP BY ae.year,a.name
HAVING COUNT(DISTINCT medal)=3;

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.(DOUBT)

SELECT * FROM athlete_events$;
SELECT * FROM athletes$;


WITH CTE AS (select a.name,ae.event
FROM athlete_events$ ae
INNER JOIN athletes$ a ON ae.athlete_id=a.id
WHERE medal='Gold' and year>1999 and season='Summer' 
GROUP BY a.name,ae.event
HAVING COUNT(DISTINCT ae.year)=3)

SELECT * FROM CTE; 










