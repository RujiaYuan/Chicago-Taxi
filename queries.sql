
# 1.Find the taxi company which is ordered most 

SELECT 
     company_name, count(ft.Companies_id) 
FROM 
     dim_companies dc
         INNER JOIN fact_trips ft ON ft.Companies_id = dc.idCompanies
GROUP BY ft.Companies_id
ORDER BY count(ft.idTrips) DESC
LIMIT 1;


# 2.Find the floor of the maximum, minimum and average payment total 

SELECT 
    (SELECT 
            floor(MAX(payment_total))
        FROM
            fact_trips
        ) maxPaymentTotal,
     (SELECT 
            floor(MIN(payment_total))
        FROM
            fact_trips
        ) minPaymentTotal,
     (SELECT 
            floor(AVG(payment_total))
        FROM
            fact_trips
        ) avgPaymentTotal;
      
# 3.Report all trips greater than and equal to $8 and Less than equal to $20 ? 

SELECT 
    *
FROM
    fact_trips
WHERE
    payment_total >= 8 AND payment_total <=20;  
    
    
# 4.List the trips which likely be taken by females (>50%percentage)

SELECT
	*
FROM
	fact_trips ft
WHERE 
    EXISTS( SELECT 
            *
        FROM
            census_tract_has_gender dg
        WHERE
            ft.from_tract_id = dg.census_tract_id
			OR ft.to_tract_id = dg.census_tract_id
                AND dg.gender_gender_id IN ('1')
                AND dg.percentage > 50);
                
                
# 5. list the trips with tips greater than average tips, sorted by the amount of total payments from high to low

SELECT
	*
FROM
	fact_trips ft
	INNER JOIN dim_payments dp ON ft.idTrips = dp.idTrips
WHERE dp.category IN ('Tips') 
AND dp.amount > (SELECT AVG(amount) FROM dim_payments WHERE category In ('Tips'))
ORDER BY dp.amount DESC;


# 6. list all trips with tips that are more than average percent

WITH temp AS(
  SELECT
	 ft.idTrips,
     amount amt_tips,
    (SELECT 
       AVG(amount) 
	 FROM dim_payments 
     WHERE category In ('Tips')) / (SELECT 
                                       AVG(amount) 
									FROM dim_payments 
                                    WHERE category In ('Fare')) AS avg_perc
  FROM
	  fact_trips ft
	INNER JOIN dim_payments dp ON ft.idTrips = dp.idTrips
  WHERE dp.category IN ('Tips'))


SELECT 
   ft.idTrips,
   amount amt_fare,
   amt_tips,
   amt_tips/dp.amount * 100 tip_percentage
FROM temp
  INNER JOIN dim_payments dp ON temp.idTrips = dp.idTrips
  INNER JOIN fact_trips ft ON ft.idTrips = dp.idTrips
WHERE (dp.category IN ('Fare'))
   AND amt_tips/dp.amount >= avg_perc
ORDER BY amt_tips/dp.amount DESC;
