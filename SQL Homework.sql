-- Choose Sakila DB

use Sakila

-- 1a. Display the first and last names of all actors from the table actor.
Select first_name, last_name from actor

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select Upper(Concat(first_name,' ',last_name)) As "Actor Name"
from actor;

/* 2a. You need to find the ID number, first name, 
 and last name of an actor, of whom you know only the first name, 
 "Joe." What is one query would you use to obtain this information */

Select first_name, last_name, actor_id from actor
where first_name="Joe"

-- 2b.  Find all actors whose last name contain the letters `GEN`
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';

-- * 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
select * from actor
where last_name like "%LI%"
order by last_name, first_name;

--  * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:

select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");

-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, 
-- as the difference between it and `VARCHAR` are significant).

alter table actor
add column description blob after last_name;

select * from actor;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

alter table actor
drop column description

select * from actor;

-- * 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*) as count_of_actors
from actor
group by last_name;

-- * 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

select last_name, count(*) as count_of_actors
from actor
group by last_name
having count_of_actors >= 2;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`.
--  Write a query to fix the record.

update actor
set first_name = "HARPO"
where last_name = "WILLIAMS" and first_name = "GROUCHO";

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`.
-- It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

update actor
set first_name = "GROUCHO"
where last_name = "WILLIAMS" and first_name = "HARPO";

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

show create table address;

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select * from address
select * from staff

select first_name, last_name, address from staff 
left join address using(address_id);

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select * from payment

select first_name, last_name, sum(amount) from staff
join payment using(staff_id)
where payment_date between "2005-08-01" and "2005-08-31"
group by staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select title, count(*) as num_actors from film
join film_actor fa using (film_id)
group by film_id

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select title, count(*) from inventory
join film using(film_id)
where title = "HUNCHBACK IMPOSSIBLE";

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

select first_name, last_name, sum(amount) as "Total Amount Paid"
from customer
join payment using(customer_id)
group by customer_id
order by last_name, first_name;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
-- films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies 
-- starting with the letters `K` and `Q` whose language is English.

select title from film
join language using(language_id)
where name = "English"
and (title like "Q%" or title like "K%");

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select first_name, last_name from film_actor
join film using(film_id)
join actor using(actor_id)
where title = "ALONE TRIP";

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.

select first_name, last_name, email from customer
join address using(address_id)
join city using (city_id)
join country using (country_id)
where country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as _family_ films.

select * from film_list

 select title, description, rating from film_list
 where category = "Family";
 
 -- * 7e. Display the most frequently rented movies in descending order.
 
select title, count(*) as rental_count from film
join inventory using(film_id)
join rental using(inventory_id)
group by film_id having rental_count > 10
order by rental_count desc;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.

select * from sales_by_store;

-- * 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country from store
join address using(address_id)
join city using(city_id)
join country using(country_id);

-- * 7h. List the top five genres in gross revenue in descending order.
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select * from sales_by_film_category
order by total_sales desc;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

drop view if exists top_five_genres;
create view top_five_genres (category, total_sales) as

select * from sales_by_film_category
order by total_sales desc
limit 5;

-- * 8b. How would you display the view that you created in 8a?

select * from top_five_genres;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.drop view top_five_genres;
drop view top_five_genres;