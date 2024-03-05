use sakila;

-- 1 Write a query to find what is the total business done by each store.
SELECT s.store_id, SUM(p.amount) AS total_business
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;

-- 2 Convert the previous query into a stored procedure.
DELIMITER //
CREATE PROCEDURE total_business (OUT total_business_by_store INT)
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_business
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    GROUP BY s.store_id
    INTO total_business_by_store;
END //
DELIMITER ;

-- 3 Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DELIMITER //
CREATE PROCEDURE total_business (IN store_input INT, OUT total_sales_by_store DECIMAL(10, 2))
BEGIN
    SELECT SUM(p.amount) AS total_sales
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.store_id = store_input
    INTO total_sales_by_store;
END //
DELIMITER ;

-- 4 Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result
  -- (of the total sales amount for the store). Call the stored procedure and print the results.
DELIMITER //

CREATE PROCEDURE total_business_new (IN store_input INT, OUT total_sales_by_store DECIMAL(10, 2))  
BEGIN      
    SELECT SUM(p.amount) AS total_sales      
    INTO total_sales_by_store
    FROM payment p      
    JOIN rental r ON p.rental_id = r.rental_id      
    JOIN inventory i ON r.inventory_id = i.inventory_id      
    WHERE i.store_id = store_input;      
END//

DELIMITER ;

-- 5 In the previous query, add another variable flag. If the total sales value for the store is over 30.000, 
  -- then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id
  -- and returns total sales value for that store and flag value.
DELIMITER //

CREATE PROCEDURE total_business_new (
    IN store_input INT, 
    OUT total_sales_by_store DECIMAL(10, 2),
    OUT flag VARCHAR(20)
)  
BEGIN      
    SELECT SUM(p.amount) AS total_sales      
    INTO total_sales_by_store
    FROM payment p      
    JOIN rental r ON p.rental_id = r.rental_id      
    JOIN inventory i ON r.inventory_id = i.inventory_id      
    WHERE i.store_id = store_input;      
    
    IF total_sales_by_store > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
    
END//

DELIMITER ;
