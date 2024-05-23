USE sakila;
	-- Rank films by their length and create an output table that includes the title, length, and rank columns only. 
    -- Filter out any rows with null or zero values in the length column.

SELECT f.title, f.length,
RANK() OVER(ORDER BY length DESC)
FROM film AS f;

-- Rank films by length within the rating category and create an output table that includes the title, length, rating and rank columns only. 
-- Filter out any rows with null or zero values in the length column.

SELECT f.title, f.length, f.rating,
RANK() OVER(ORDER BY rating DESC) AS 'rank'
FROM film AS f
WHERE f.length IS NOT NULL AND f.rating !=0;

-- Produce a list that shows for each film in the Sakila database, the actor or actress who has acted in the greatest number of films, 
-- as well as the total number of films in which they have acted. Hint: Use temporary tables, CTEs, or Views when appropiate to 
-- simplify your queries. 

CREATE TEMPORARY TABLE actors_ranked
SELECT fa.film_id, f.title, a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS 'Actor Name',
RANK() OVER(ORDER BY 'Actor Name') AS 'rank'
FROM film AS f
JOIN film_actor AS fa
ON f.film_id = fa.film_id
JOIN actor AS a
ON fa.actor_id = a.actor_id;

SELECT *
FROM actors_ranked;

-- helped by bot
WITH actor_film_counts AS (
    SELECT 
        fa.actor_id,
        COUNT(*) AS num_films
    FROM film_actor AS fa
    GROUP BY fa.actor_id
),
max_actor_films AS (
    SELECT 
        actor_id,
        num_films,
        RANK() OVER(ORDER BY num_films DESC) AS actor_rank
    FROM actor_film_counts
)
SELECT 
    f.title AS film_title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    maf.num_films AS num_films_acted
FROM 
    film_actor AS fa
JOIN film AS f ON fa.film_id = f.film_id
JOIN actor AS a ON fa.actor_id = a.actor_id
JOIN max_actor_films AS maf ON a.actor_id = maf.actor_id AND maf.actor_rank = 1;
