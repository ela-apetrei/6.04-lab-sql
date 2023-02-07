-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the given query
DELIMITER //
create procedure customer_emails ()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end //
DELIMITER ; 

call customer_emails();

-- 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
DELIMITER //
create procedure customer_emails_by_cat (in category_name varchar(50))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = category_name
  group by first_name, last_name, email;
end //
DELIMITER ; 

call customer_emails_by_cat("Action");

-- 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
DELIMITER //
CREATE PROCEDURE num_movies_by_category(IN min_movies INT)
BEGIN
  SELECT category.name, COUNT(*) as num_movies
  FROM film
  JOIN film_category ON film.film_id = film_category.film_id
  JOIN category ON category.category_id = film_category.category_id
  GROUP BY category.name
  HAVING COUNT(*) >= min_movies;
END //
DELIMITER ;

CALL num_movies_by_category(70);
