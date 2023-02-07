--  Write the SQL queries to answer the following questions:
-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
select c.first_name, c.last_name, p.rental_id, p.payment_id
from customer c
join payment p on c.customer_id = p.customer_id
where payment_id is not null
group by c.customer_id;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS 'Customer Name', avg(p.amount) AS 'Average Payment'
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id;

-- 3 Select the name and email address of all the customers who have rented the "Action" movies.
	-- 3.01. Write the query using multiple join statements
    select email 
	from customer c
	join store s on s.address_id = c.address_id
	join inventory i on i.store_id = s.store_id
	join film f on f.film_id = i.film_id
	join film_category fc on fc.film_id = f.film_id
	join category ca on ca.category_id = fc.category_id
	where ca.name = "Action";
    
	-- 3.02. Write the query using sub queries with multiple WHERE clause and IN condition
select c.first_name, c.last_name, c.email
from customer c
where c.customer_id in (
  select r.customer_id
  from rental r
  where r.inventory_id in (
    select i.inventory_id
    from inventory i
    where i.film_id in (
      select f.film_id
      from film f
      where f.film_id in (
		select fc.film_id
        from film_category fc
      where fc.category_id = 
      (
        select c.category_id
        from category c
        where c.name = 'Action'
      )
    )
  )
)
);
	-- 3.03. Verify if the above two queries produce the same results or not
    -- A: the first query returns empty rows while the second one does return something
    
-- 7. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
SELECT p.payment_id, p.amount, 
  CASE 
    WHEN p.amount BETWEEN 0 AND 2 THEN 'Low'
    WHEN p.amount BETWEEN 2 AND 4 THEN 'Medium'
    ELSE 'High'
  END AS payment_class
FROM payment p;