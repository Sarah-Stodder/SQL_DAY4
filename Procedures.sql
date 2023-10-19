-- Stored Procedures!

select *
from customer
WHERE customer_id = 87;


-- if you dont have loyalty member column excute the following:
ALTER TABLE customer
ADD COLUMN loyalty_member BOOLEAN;


-- reset all customers to be false on the LM column.
UPDATE customer 
SET loyalty_member = FALSE;

SELECT * 
FROM customer
WHERE loyalty_member = FALSE;

-- create a procedure to update our customers to be LM's if they have spent over $100

-- step1 : get id'ss of customers who've spent over $100
SELECT customer_id
FROM payment 
Group by customer_id 
HAVING sum(amount) >= 100;

-- use 87 for testing purposes

--step 2: set LM to True if the customer id is in the list of id's from step 1
Update customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
		SELECT customer_id
		FROM payment 
		Group by customer_id 
		HAVING sum(amount) >= 100
);

SELECT *
FROM customer 
WHERE loyalty_member = TRUE ;


-- We are going to take the above steps and convert to procedures

CREATE OR REPLACE PROCEDURE update_loyalty(loyalty_min NUMERIC(5,2) DEFAULT 100.00)
LANGUAGE plpgsql
AS $$
BEGIN
	Update customer 
    SET loyalty_member = TRUE 
    WHERE customer_id IN (
			SELECT customer_id
			FROM payment 
			Group by customer_id 
			HAVING sum(amount) >= loyalty_min
	);
END;
$$;

--Use a procedure, - use CALL
CALL update_loyalty();

SELECT *
FROM customer 
WHERE loyalty_member = TRUE;


-- mimic a customer making a purchase that will put them over the new threshhold

-- find a test customer: close to $100
SELECT customer_id ,SUM(amount)
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount)Between 95 AND 100;

-- 554 it's your lucky day, you are our tester!

SELECT *
FROM customer 
WHERE customer_id = 554;


-- check Dwayne out and give total:
INSERT INTO payment (customer_id, staff_id, rental_id, amount,payment_date)
VALUES(554,1,508,5.99,'2023-10-19 13:07:45');

-- Call the prcedure again!
CALL update_loyalty();

SELECT *
FROM customer 
WHERE customer_id = 554;

SELECT count(*)
FROM customer c
WHERE loyalty_member = TRUE; -- 297


-- lets say boss man said 75 is the new cap, so lets get more LM in!

CALL update_loyalty(75);

SELECT count(*)
FROM customer c
WHERE loyalty_member = TRUE; -- 521  

-- Prcedure to add an actor into our actor table!
SELECT *
FROM actor
WHERE last_name LIKE 'S%';

-- SELECT NOW();

INSERT INTO actor (first_name, last_name, last_update)
VALUES('Brian','Stanton', NOW());

INSERT INTO actor (first_name, last_name, last_update)
VALUES('Sarah','Stodder', NOW());

INSERT INTO actor(first_name,last_name)
VALUES('Kevin','Beier');

SELECT *
FROM actor 
ORDER BY actor_id DESC;


--- procedure time! (do we feel like doc's yet?)

CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR,last_name VARCHAR)
LANGUAGE plpgsql
AS $add_actor$
BEGIN 
	INSERT INTO actor(first_name,last_name)
	VALUES(first_name ,last_name);
END
$add_actor$

CALL add_actor('Alec', 'Guiennes');

CALL add_actor('Mark','Hammil');

SELECT *
FROM actor 
ORDER BY actor_id DESC;

-- to delete:
DROP PROCEDURE IF EXISTS add_actor;






























