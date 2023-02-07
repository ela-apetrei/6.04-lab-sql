-- 1. Write a query to find what is the total business done by each store.
SELECT s.store_id as 'Store ID', SUM(p.amount) as 'Total Amount'
from staff s 
join payment p on s.staff_id = p.staff_id
group by store_id

-- 2. Convert the previous query into a stored procedure.
DELIMITER //
create procedure total_business()
begin
	SELECT s.store_id as 'Store ID', SUM(p.amount) as 'Total Amount'
	from staff s 
	join payment p on s.staff_id = p.staff_id
	group by store_id;
end //
DELIMITER ;

call total_business() 

-- 3. Convert the previous query into a stored procedure that takes the input for `store_id` and displays the *total sales for that store*.
DELIMITER //
create procedure total_business_input(IN store_id INT)
begin
	select s.store_id as 'Store ID', SUM(p.amount) as 'Total Amount'
	from staff s 
	join payment p on s.staff_id = p.staff_id
    where s.store_id = store_id
	group by store_id;
end //
DELIMITER ;

call total_business_input(1);

-- 4. Update the previous query. Declare a variable `total_sales_value` of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
drop procedure if exists total_business_by_store;

DELIMITER //
create procedure total_business_by_store(in param_store int, out param_sales float)
begin
declare total_sales_value float default 0.0;
	select SUM(p.amount) as total_sales into total_sales_value
	from payment p
	join staff s on s.staff_id = p.staff_id
	where s.store_id = param_store;
    
	select total_sales_value into param_sales;
end //
DELIMITER ;

-- printing the results:
set @total_sales_value = 0;
call total_business_by_store(1, @total_sales);
select @total_sales AS 'Total Sales Amount';

-- 5. In the previous query, add another variable `flag`. If the total sales value for the store is over 30.000, then label it as `green_flag`, otherwise label is as `red_flag`. Update the stored procedure that takes an input as the `store_id` and returns total sales value for that store and flag value.
drop procedure if exists total_business_flag;

DELIMITER //
create procedure total_business_flag(in param_store int, out param_sales float, out param_flag varchar(20))
begin
declare total_sales_value float default 0.0;
declare flag varchar(20) default "";

	select SUM(p.amount) as total_sales into total_sales_value
	from payment p
	join staff s on s.staff_id = p.staff_id
	where s.store_id = param_store;
    
    case 
    when total_sales_value >= 30000 then
    set flag = 'green_flag';
    else
    set flag = 'red_flag';
    end case;
    
    select total_sales_value into param_sales;
    select flag into param_flag;

end //
DELIMITER ;

-- printing the results:
set @total_sales_value = 0; -- set @param_sales = 0;
set @flag = ""; -- set @param_flag ='';
call total_business_flag(1, @total_sales, @flag);
select @total_sales AS 'Total Sales Amount', @flag AS 'Flag';
