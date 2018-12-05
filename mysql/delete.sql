use foodDelivery;

drop procedure if exists delete_things;
DELIMITER //
create procedure delete_things(in id int, in table_name char(50))
begin
if (table_name = 'Customers') then
delete from Customers where customers.cid = id;
end if;

if (table_name = 'Deliverymen') then
delete from Deliverymen where deliverymen.did = id and deliverymen.dstatus ='available';
end if;

if (table_name = 'Food') then
delete from Food where Food.fid = id;
end if;

if (table_name = 'Managers') then
delete from Managers where Managers.managerid = id;
end if;

if (table_name = 'Restaurants') then
delete from Restaurants where Restaurants.rid = id;
end if;

end //
DELIMITER ;


drop trigger if exists change_status_after_delete_customers;
DELIMITER $$
create trigger change_status_after_delete_customers after delete on Customers for each row  
begin

update Orders
set ostatus = 'canceled'
where Orders.cid is null;

end$$
 
DELIMITER;


drop trigger if exists change_status_after_delete_restaurants;
DELIMITER $$
create trigger change_status_after_delete_restaurants after delete on restaurants for each row  
begin

update Orders
set ostatus = 'canceled'
where Orders.rid is null;


end$$
DELIMITER;

 
drop procedure if exists delete_food_ordered;
DELIMITER //
create procedure delete_food_ordered(in oid int, in fid int)
begin

delete from food_ordered
where food_ordered.oid = oid and food_ordered.fid = fid;

end //
DELIMITER ;


drop trigger if exists order_price_after_delete_food;
DELIMITER $$
create trigger order_price_after_delete_food after delete on food_ordered for each row  
begin

update Orders 
set price = (select sum(price) from Food join food_ordered using (fid))
where Orders.oid = old.oid;

end$$
 
DELIMITER ;
