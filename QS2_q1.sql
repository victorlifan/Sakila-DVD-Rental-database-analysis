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
ORDER BY 2,1