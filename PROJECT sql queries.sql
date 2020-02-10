--QS1_q1
SELECT title film_title, name category_name, COUNT(rental_id) AS rental_count
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
('Animation','Children','Classics','Comedy','Family','Music')
GROUP BY 1,2
ORDER BY 2,1;
--QS1_q1_method 2
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
	('Animation','Children','Classics','Comedy','Family','Music'))
SELECT DISTINCT film_title, category_name,
COUNT(film_title)OVER(PARTITION BY film_title ORDER BY film_title)
FROM t1
ORDER BY 2,1;
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
--QS1_q3
WITH t1 AS (
		SELECT title, name, rental_duration
		FROM category ca
		JOIN film_category fc
		ON ca.category_id = fc.category_id
		JOIN film fi
		ON fi.film_id = fc.film_id
		WHERE name IN 
		('Animation','Children','Classics','Comedy','Family','Music')),
	t2 AS (
        SELECT name,
        NTILE(4)OVER(ORDER BY rental_duration) AS standard_quetile
        FROM t1)
SELECT *, COUNT(*) AS count
FROM t2
GROUP BY 1,2
ORDER BY 1,2;
--QS2_q1
SELECT
DATE_PART('month' ,rental_date) AS Rental_month,
DATE_PART('year' ,rental_date) AS Rental_year,
sto.store_id, COUNT(*)
FROM store sto
JOIN staff sta
ON sta.store_id = sto.store_id
JOIN payment pay
ON pay.staff_id = sta.staff_id
JOIN rental ren
ON ren.rental_id = pay.rental_id
GROUP BY 1,2,3
ORDER BY 2,1;
--QS2_q2
WITH t1 AS(
	SELECT CONCAT(first_name,' ',last_name) AS fullname,
	SUM(amount) total
	FROM customer cus
		JOIN payment pay
		ON cus.customer_id = pay.customer_id
	GROUP BY 1
	ORDER BY total DESC
	LIMIT 10),
	t2 AS(
	SELECT DATE_TRUNC('month', payment_date) AS pay_mon,
	CONCAT(first_name,' ',last_name) AS fullname,
	amount pay_amount
	FROM customer cus
	JOIN payment pay
	ON cus.customer_id = pay.customer_id
	WHERE CONCAT(first_name,' ',last_name) IN (SELECT fullname FROM t1))
SELECT pay_mon, fullname, 
COUNT(*) AS pay_countpermon,
SUM(pay_amount) AS pay_amount
FROM t2
GROUP BY 1,2
ORDER BY 2,1;
--QS2_q3
WITH t3 AS(
	WITH t1 AS(
			SELECT CONCAT(first_name,' ',last_name) AS fullname,
			SUM(amount) total
			FROM customer cus
			JOIN payment pay
			ON cus.customer_id = pay.customer_id
			GROUP BY 1
			ORDER BY total DESC
			LIMIT 10),
		t2 AS(
			SELECT DATE_TRUNC('month', payment_date) AS pay_mon,
			CONCAT(first_name,' ',last_name) AS fullname,
			amount pay_amount
			FROM customer cus
			JOIN payment pay
			ON cus.customer_id = pay.customer_id
			WHERE CONCAT(first_name,' ',last_name) IN (SELECT fullname FROM t1))
	SELECT pay_mon, fullname, 
	COUNT(*) AS pay_countpermon,
	SUM(pay_amount) AS pay_amount
	FROM t2
	GROUP BY 1,2
	ORDER BY 2,1)
SELECT t3.*,
LAG(pay_amount, 1)OVER(PARTITION BY fullname ORDER BY pay_mon) AS lag_one_month,
COALESCE(
	pay_amount-LAG(pay_amount, 1)OVER(PARTITION BY fullname ORDER BY pay_mon), 0)AS lag_difference
FROM t3;
--to identify the customer name who paid the most difference in terms of payments, delete ';' above and add ORDER BY query below
ORDER BY lag_difference DESC;




