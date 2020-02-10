--Q1
SELECT title film_title, name category_name, COUNT(*) AS rental_count
FROM category ca
JOIN film_category fc
ON ca.category_id= fc.category_id
JOIN film fi
ON fc.film_id = fi.film_id
JOIN inventory inv
ON inv.film_id = fi.film_id
JOIN rental re
ON re.inventory_id = inv.inventory_id
WHERE name IN 
('Animation','Children','Classics','Comedy','Family ','Music')
GROUP BY 1,2
ORDER BY 2,1;
--Q1_method 2
WITH t1 AS(
	SELECT title film_title, name category_name
	FROM category ca
	JOIN film_category fc
	ON ca.category_id= fc.category_id
	JOIN film fi
	ON fc.film_id = fi.film_id
	JOIN inventory inv
	ON inv.film_id = fi.film_id
	JOIN rental re
	ON re.inventory_id = inv.inventory_id
	WHERE name IN 
	('Animation','Children','Classics','Comedy','Family ','Music'))
SELECT DISTINCT film_title, category_name,
COUNT(film_title)OVER(PARTITION BY film_title ORDER BY film_title)
FROM t1
ORDER BY 2,1;
--Q2
WITH t1 AS (
	SELECT title, name, rental_duration,
	CASE
		WHEN name IN ('Animation','Children','Classics','Comedy','Family ','Music') THEN 'YES'
		ELSE 'NO'
	END AS if_family_friendly
	FROM category ca
	JOIN film_category fc
	ON ca.category_id = fc.category_id
	JOIN film fi
	ON fi.film_id = fc.film_id)
SELECT *,
NTILE(4) OVER(ORDER BY rental_duration) AS standard_quartile
FROM t1
ORDER BY 4 DESC;