use sakila;

-- 1a display first and last name of all actors 
Select first_name, last_name from actor;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 1b display first and last name is one column
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----    
-- 2a find ID number, first name 
SELECT 
    actor_id 'ID number', first_name 'first name', last_name 'last name'
FROM
    actor
WHERE
    first_name = 'Joe';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 2b find all actors whose last name contain GEN
 SELECT *
FROM
    actor
WHERE 
    last_name LIKE '%GEN%';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----    
-- 2c find all actors whose last names contain LI
 SELECT *
FROM
    actor
WHERE 
    last_name LIKE '%LI%';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----    
-- 2d using IN display country_id and country
SELECT *
FROM country
Where country IN ('Afghanistan','Bangladesh','China');
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 3a insert description
ALTER TABLE actor 
ADD Description blob;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 3b delete description
ALTER TABLE actor
DROP Description;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 4a list actor last name and count
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 4c change actor name
UPDATE actor
Set first_name = 'Harpo'
Where first_name = 'Groucho';

SELECT * 
From actor
WHERE last_name = 'Williams';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 4d 
UPDATE actor
Set first_name = 'GROUCHO'
Where first_name = 'HARPER';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 5a locate schema address 
SHOW CREATE TABLE address;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 6a first and last name, address, and staff
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN staff ON
staff.staff_id = address.address_id;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 6b join staff names and payment in August 2005
SELECT staff.first_name, staff.last_name, payment.staff_id, SUM(payment.amount)
FROM payment
INNER JOIN staff ON
payment.staff_id = staff.staff_id
WHERE
DATE(payment_date) BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.first_name, staff.last_name;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 6c list each film and # of actors 
SELECT film.title, film_actor.actor_id
FROM film_actor
INNER JOIN film ON
film.film_id = film_actor.actor_id
GROUP BY film.title;
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 6d how many copies of the film Hunchback Impossible
SELECT title, COUNT(title)
FROM film
WHERE title = 'Hunchback Impossible';
-- -- -- -- -- --- ---- ------ ------ -------- ------ -----
-- 6e join payment and customer tables
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
INNER JOIN payment ON
customer.customer_id = payment.payment_id
ORDER BY last_name;
-- -- -- -- -- --- -- ------- ---- 
-- 7a subqueries on k and q
SELECT title
FROM film 
WHERE title LIKE 'Q%' AND 'K%';
-- -- -- -- -- --- -- ------- ---- 
-- 7b subqueries display all actors
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
)
);
-- -- -- -- -- --- -- ------- ---- 
-- 7c email marketing campaign 
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address ON
customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id=country.country_id
WHERE country.country = 'Canada';
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 7d families 
SELECT  film.title
FROM film
INNER JOIN film_category ON 
film.film_id=film_category.film_id
INNER JOIN category ON 
film_category.category_id=category.category_id
WHERE category.name = "Family";
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 7e. Display the most frequently rented movies in descending orde
SELECT inventory.film_id, film.title, COUNT(rental.inventory_id) AS Inventory
FROM inventory 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_text f ON inventory.film_id = film.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT (rental.inventory_id) DESC;
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 7f how much business bought by each store
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff ON
staff.store_id = store.store_id
INNER JOIN payment ON
payment.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 7g display each store id, city, country
SELECT store_id, store_id, city, country
FROM store
INNER JOIN city ON
store.store_id = city.city_id
INNER JOIN country ON
city.city_id = country.country_id
GROUP BY store.store_id;
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 7h List the top five genres in gross revenue in descending order.
SELECT category.name AS 'Genre', SUM(payment.amount) AS TOTAL
FROM category
JOIN film_category ON
category.category_id = film_category.category_id
JOIN inventory ON
film_category.film_id = inventory.film_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY TOTAL
LIMIT 5;
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 8a create view of top five genres by gross revenue
CREATE VIEW top_five AS
SELECT category.name AS 'Genre', SUM(payment.amount) AS TOTAL
FROM category
JOIN film_category ON
category.category_id = film_category.category_id
JOIN inventory ON
film_category.film_id = inventory.film_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY TOTAL
LIMIT 5;
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 8b display view
SELECT * FROM top_five;
-- -- -- -- -- --- -- ------- ---- --- ------ ------ -----
-- 8c delete view
DROP VIEW top_five;