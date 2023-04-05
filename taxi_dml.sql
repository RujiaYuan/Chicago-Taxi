USE taxi;


LOAD DATA INFILE '~/Desktop/completed_tables/fact_trips.csv' 
INTO TABLE fact_trips 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/dim_companies.csv' 
INTO TABLE dim_companies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/dim_payments.csv' 
INTO TABLE dim_payments 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/dim_census_tract.csv' 
INTO TABLE dim_census_tract 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/census_tract_has_gender.csv' 
INTO TABLE census_tract_has_gender 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/census_tract_has_race.csv' 
INTO TABLE census_tract_has_race 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/census_tract_has_age_group.csv' 
INTO TABLE census_tract_has_age_group 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/race.csv' 
INTO TABLE race 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/age_group.csv' 
INTO TABLE age_group 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/Desktop/completed_tables/gender.csv' 
INTO TABLE gender 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


INSERT INTO taxi.dim_payments (    
	idPayments,
    type,
    amount,
    trips_id)
(SELECT 
	idPayments,
    type,
    amount,
    idTrips
FROM
    dim_payments
    fact_trips
WHERE 
    dim_payments.trips_id = fact_trips.idTrips);
    
INSERT INTO taxi.dim_companies (    
	idCompanies,
    company_name,
    company_type)
(SELECT 
	idCompanies,
    company_name,
    company_type
FROM
    dim_companies);
    
INSERT INTO taxi.dim_census_tract (    
	idcensus_tract,
    name)
(SELECT 
	idcensus_tract,
    name
FROM
    dim_census_tract);
    
    