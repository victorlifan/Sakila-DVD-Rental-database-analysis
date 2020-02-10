--Q3
WITH t1 AS(
	SELECT title, name, rental_duration,
	NTILE(4)OVER(ORDER BY rental_duration) AS standard_quartile
	FROM category ca
	JOIN film_category fc
	ON ca.category_id= fc.category_id
	JOIN film fi
	ON fc.film_id = fi.film_id
	WHERE name IN
	('Animation','Children','Classics','Comedy','Family ','Music')
	ORDER BY 2,4)
SELECT DISTINCT name, standard_quartile, 
COUNT(*)OVER (PARTITION BY standard_quartile ORDER BY name) AS count
FROM t1
ORDER BY 1,2;