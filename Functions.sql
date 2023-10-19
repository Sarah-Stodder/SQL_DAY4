-- Stored functions!

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'S%';

SELECT COUNT(*)
FROM actor 
WHERE last_name ILIKE 'a%';

-- create a function that counts the actors by there last name that starts with a certin *letter*
CREATE OR REPLACE FUNCTION  get_actor_count(letter VARCHAR)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN 
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;


SELECT get_actor_count('S');
SELECT get_actor_count('T');
SELECT get_actor_count('A');
SELECT get_actor_count('R');
SELECT get_actor_count('a');


-- Deleteing from database:
DROP FUNCTION IF EXISTS get_actor_count(VARCHAR)


--create a function that will return the employee witht he most transactions



SELECT CONCAT(first_name,' ',last_name) as employee
FROM staff 
WHERE staff_id = (
	SELECT staff_id 
	from payment 
	group by staff_id 
	order by count(*) DESC 
	LIMIT 1
);

-- same as above function

CREATE OR REPLACE FUNCTION top_sales_employee()
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR;
BEGIN
	SELECT CONCAT(first_name,' ',last_name) INTO employee
	FROM staff 
	WHERE staff_id = (
		SELECT staff_id 
		from payment 
		group by staff_id 
		order by count(*) DESC 
		LIMIT 1);
	RETURN employee;
END;
$$;


SELECT top_sales_employee();

-- create a function that returns a table!
SELECT c.first_name, c.last_name, a.address, ci.city, a.district,co.country
FROM customer c 
JOIN address a 
on c.address_id = a.address_id 
JOIN city ci
on a.city_id =ci.city_id 
JOIN country co 
ON ci.country_id = co.country_id
WHERE co.country = 'India';


-- when we return a table, you need to specify the what the table will look like.(col name, datatype)

CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE (
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	district VARCHAR(50),
	country VARCHAR(50)
	)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district,co.country
	FROM customer c 
	JOIN address a 
	on c.address_id = a.address_id 
	JOIN city ci
	on a.city_id =ci.city_id 
	JOIN country co 
	ON ci.country_id = co.country_id
	WHERE co.country = country_name;
END;
$$;
-- executing a funtion that returns a table
SELECT *
FROM customers_in_country('United States');
SELECT *
FROM customers_in_country('Nepal'); 

SELECT district, count(*)
FROM customers_in_country('United States')
Group BY district; 




































