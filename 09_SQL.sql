-- 1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.
use sakila;

select first_name, last_name 
from actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select CONCAT(first_name, ' ', last_name) as ' Actor Name'
from actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name 
from actor
where first_name = 'JOE';


-- 2b. Find all actors whose last name contain the letters GEN:

select actor_id, first_name, last_name 
from actor
where last_name like '%GEN%';



-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select actor_id, first_name, last_name 
from actor
where last_name like '%LI%'
order by last_name, first_name;



-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');



-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

select * from actor;
alter table actor
add column middle_name varchar(50) after first_name;



-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

alter table actor 
modify middle_name BLOB;



-- 3c. Now delete the middle_name column.

alter table actor
drop column middle_name;


-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*) as `Count`
from actor
group by last_name;



-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(*) as `Count`
from actor
group by last_name
having count > 2;



-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

update actor 
set first_name= 'HARPO'
where first_name='GROUCHO' and last_name='WILLIAMS';



-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

update actor 
set first_name= 'GROUCHO'
where first_name='HARPO' and last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

-- describe sakila.address


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select s.first_name, s.last_name, sum(p.amount) as 'TOTAL'
from staff s left join payment p on s.staff_id = p.staff_id
group by s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select f.title, count(a.actor_id) as 'TOTAL'
from film f left join film_actor a on f.film_id = a.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

-- 2


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

select c.first_name, c.last_name, sum(p.amount) as 'TOTAL'
from customer c left join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by c.last_name;



-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select title
from film
where (title like 'K%' or title LIKE 'Q%') 
and  language_id=(select language_id FROM language where name='English');



-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name, last_name
from actor 
where actor_id
in (select actor_id from film_actor where film_id 
in (select film_id from film where title='ALONE TRIP'));



-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select first_name, last_name, email 
from customer cu
join address a on (cu.address_id = a.address_id)
join city cit on (a.city_id=cit.city_id)
join country cntry on (cit.country_id=cntry.country_id);



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title 
from film f
join film_category fcat on (f.film_id=fcat.film_id)
join category c on (fcat.category_id=c.category_id);



-- 7e. Display the most frequently rented movies in descending order.

select title, count(f.film_id) as 'Count_of_Rented_Movies'
from film f
join inventory i on (f.film_id= i.film_id)
join  rental r on (i.inventory_id=r.inventory_id)
group by title order by Count_of_Rented_Movies desc;



-- 7f. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount) 
from payment p
join staff s on (p.staff_id=s.staff_id)
group by store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.

select store_id, city, country
from store s
join address a on (s.address_id=a.address_id)
join city c on (a.city_id=c.city_id)
join country cntry on (c.country_id=cntry.country_id);



-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.name as "Top Five", sum(p.amount) as "Gross" 
from category c
join film_category fc on (c.category_id=fc.category_id)
join inventory i on (fc.film_id=i.film_id)
join rental r on (i.inventory_id=r.inventory_id)
join payment p on (r.rental_id=p.rental_id)
group by c.name order by Gross limit 5;



-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

select c.name as "TopFive", sum(p.amount) as "Gross" 
from category c
join film_category fc on (c.category_id=fc.category_id)
join inventory i on (fc.film_id=i.film_id)
join rental r on (i.inventory_id=r.inventory_id)
join payment p on (r.rental_id=p.rental_id)
group by c.name order by Gross LIMIT 5;



-- 8b. How would you display the view that you created in 8a?

select * from TopFive;



-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW TopFive;

