Use Sakila;

-- Create these queries to develop greater fluency in SQL, an important database language.
-- 1a. Display the first and last names of all actors from the table actor.

SELECT first_name,
last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

ALTER TABLE actor
Add Actor_Name varchar(255);
Insert into Actor_Name (Actor_Name)
Values (first_name and last_name);

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

Select *
from actor
where first_name like 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

Select *
from actor
where last_name like '%GEN%';



-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

Select last_name, first_name
from actor
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

Select country id,
country
from country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD Description Blob;

-- Values in VARCHAR columns are variable-length strings. ... For this reason varchar is fetched much faster. If you have a large blob that you access infrequently, than a blob makes more sense. Storing the blob data in a separate (part of the) file allows your core data file to be smaller and thus be fetched quicker.Oct 24, 2011
-- varchar(255) vs tinytext/tinyblob and varchar(65535) vs blob/text ...

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor
Drop Description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name,
count(last_name) as 'Count'
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
Select last_name,
count(last_name) as 'Count'
from actor
group by last_name
HAVING count >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

SELECT actor_id,
first_name,
last_name
from actor
where first_name = 'Groucho' and last_name = 'Williams';

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    actor_id = 172;
    
SELECT first_name,
last_name
from actor
where actor_id = 172;
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    actor_id = 172;
    
SELECT first_name,
last_name
from actor
where actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
Describe sakila.address;

-- Create table with table with the below attributes

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

Select payment.staff_id, staff.first_name, staff.last_name, payment.payment_date,
sum(payment.amount) as 'Total_Amount'
from staff
inner join payment on
staff.staff_id = payment.staff_id
WHERE
    payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;




-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Select film.title, 
count(actor_id) as 'Number of Actors'
from film
inner join film_actor on
film_actor.film_id = film.film_id
group by film.film_id;


-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

Select *
from inventory
where film_id = 439

SELECT film_id,
title
from film
where title = 'Hunchback Impossible'

Select film.title,
count(inventory.inventory_id) as 'Copies'
from film
inner join inventory on
film.film_id = inventory.film_id
where film.film_id = 439;


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
Select customer.first_name, customer.last_name,
Sum(Amount) as 'Total Amount'
from customer
inner join payment on
customer.customer_id = payment.customer_id
group by customer.customer_id
Order by last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title 
FROM film
WHERE language_id IN
	(SELECT language_id 
	FROM language
	WHERE name = "English" ) 
AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE title IN
	(SELECT title
	FROM film
	WHERE title = "Alone Trip" ) 
;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT customer.first_name, customer.last_name, address.address_id, customer.email
FROM customer
INNER JOIN address ON
customer.address_id=address.address_id
Where city_id in
	(Select city_id
    from city
    Where country_id in
		(Select country_id
		from country
		where country = 'Canada')
	);
	
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
    SELECT category_id
    FROM category 
    WHERE name = 'Family'
  ) 
);

-- 7e. Display the most frequently rented movies in descending order.


SELECT 
    film.title, COUNT(*) AS 'Rental Count'
FROM
    film,
    inventory,
    rental
WHERE
    film.film_id = inventory.film_id
        AND rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id
ORDER BY COUNT(*) DESC, film.title ASC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, city.city, co.country
FROM store s
JOIN address a
ON (s.address_id = a.address_id)
JOIN city
ON (a.city_id = city.city_id)
JOIN country co
ON (city.country_id = co.country_id)

	


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
Select c.Name, sum(amount) as 'Gross Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
join film_category fc
On i.film_id = fc.film_id
JOIN category c
On fc.category_id = c.category_id
group by c.name desc;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
Create View VW_Top_Five_Genres AS
Select c.Name, sum(amount) as 'Gross Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
join film_category fc
On i.film_id = fc.film_id
JOIN category c
On fc.category_id = c.category_id
group by c.name asc
limit 5;
-- 8b. How would you display the view that you created in 8a?

Select * 
From VW_Top_Five_Genres
limit 5;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

Drop View vw_top_five_genres;

Drop View top_five_genres;
