--QS1_q2
WITH t1 AS (
	SELECT title, name, rental_duration,
    NTILE(4) OVER(ORDER BY rental_duration) AS standard_quartile
	FROM category ca
	JOIN film_category fc
	ON ca.category_id = fc.category_id
	JOIN film fi
	ON fi.film_id = fc.film_id)
SELECT *
FROM t1
WHERE name IN 
	('Animation','Children','Classics','Comedy','Family','Music')
ORDER BY 4;