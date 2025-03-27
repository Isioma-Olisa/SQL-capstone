--Display the customer names that share the same address (e.g., husband and wife)
SELECT 
    c1.first_name AS "First Name 1", 
    c1.last_name AS "Last Name 1", 
    c2.first_name AS "First Name 2", 
    c2.last_name AS "Last Name 2", 
    a.address
FROM 
    customer c1
JOIN 
    customer c2 ON c1.address_id = c2.address_id AND c1.customer_id != c2.customer_id
JOIN 
    address a ON c1.address_id = a.address_id
ORDER BY 
    a.address;

--What is the name of the customer who made the highest total payments?--
SELECT 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS Total_Payments
FROM 
    payment AS p
JOIN 
    customer AS c ON p.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    Total_Payments DESC
LIMIT 1;

--Movies that was rented most--
SELECT 
    f.title, 
    COUNT(r.rental_id) AS Rental_Count
FROM 
    rental AS r
JOIN 
    inventory AS i ON r.inventory_id = i.inventory_id
JOIN 
    film AS f ON i.film_id = f.film_id
GROUP BY 
    f.film_id, f.title
ORDER BY 
    Rental_Count DESC
LIMIT 1;

--Which movies have been rented so far--
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id =r.inventory_id;

--Which movies have not been rented so far--
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

--Which customers have not rented any movies so far--
SELECT 
    c.first_name, 
    c.last_name
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
WHERE 
    r.rental_id IS NULL;

--Display  each movie and the number of times it got rented--
SELECT f.title, COUNT(r.rental_id) AS rental_Count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_Count ASC;

--First name and last name and the number of films each actor acted--
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY num_films ASC;

--Names of actors that acted in more than 20 movies--
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id)>20;

--For all movies rated 'PG' show me the movie and number of times it got rented--
SELECT f.title, COUNT(r.rental_id) AS rental_Count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE f.rating = 'PG'
GROUP BY f.title
ORDER BY rental_Count ASC;

--Display the movies offered for rent in store_id 1 and not offered in store_id 2--
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
  AND f.film_id NOT IN (
      SELECT DISTINCT f2.film_id
      FROM film f2
      JOIN inventory i2 ON f2.film_id = i2.film_id
      WHERE i2.store_id = 2
  );

--Display movies offered for rent in any of the two store 1 and 2--
SELECT DISTINCT f.title
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE i.store_id IN (1, 2);

--Display movie titles of those movies offered in both store at the same time--
SELECT 
    f.title
FROM 
    inventory i1
JOIN 
    inventory i2 ON i1.film_id = i2.film_id
JOIN 
    film f ON i1.film_id = f.film_id
WHERE 
    i1.store_id = 1 AND i2.store_id = 2
GROUP BY 
    f.film_id, f.title;

--Display movie for the most rented movie in the store with store_id 1--
SELECT 
    f.title, 
    COUNT(r.rental_id) AS Rental_Count
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    i.store_id = 1
GROUP BY 
    f.film_id, f.title
ORDER BY 
    Rental_Count DESC
LIMIT 1;

--How many movies are not offered for rent in the stores yet. There are only two stores only 1 and 2--
SELECT 
    COUNT(*) AS "Movies Not Offered"
FROM 
    film f
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
WHERE 
    i.inventory_id IS NULL;

--Show the number of rented movies under each rating--
SELECT 
    f.rating, 
    COUNT(r.rental_id) AS "Rented Count"
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    f.rating
ORDER BY 
    "Rented Count" DESC;

--Show the profit of each of the stores 1 and 2--
SELECT 
    i.store_id, 
    SUM(p.amount) AS Total_Profit
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
GROUP BY 
    i.store_id
ORDER BY 
    i.store_id;
