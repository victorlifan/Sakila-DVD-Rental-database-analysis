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
