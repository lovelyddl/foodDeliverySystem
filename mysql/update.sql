use foodDelivery;

drop procedure if exists assign_deliveryman;
DELIMITER //
create procedure assign_deliveryman(in did int, in oid int)
begin

update Orders
set Orders.did = did,  Orders.ostatus = 'on the way'
where Orders.oid = oid;

end //
DELIMITER ;

drop trigger if exists change_status_after_assigned;
DELIMITER $$
create trigger change_status_after_assigned after update on Orders for each row  
begin
if (new.did is not null) then
update Deliverymen 
set dstatus = 'unavailable'
where Deliverymen.did = new.did;

end if;
end$$
DELIMITER ;

drop trigger if exists change_status_after_delivered;
DELIMITER $$
create trigger change_status_after_delivered after update on Orders for each row  
begin
if (new.ostatus = 'delivered') then
update Deliverymen 
set dstatus = 'available'
where Deliverymen.did = new.did;

end if;
end$$
DELIMITER ;

drop procedure if exists add_food;
DELIMITER //
create procedure add_food(in oid int, in fid int)
begin
insert into food_ordered(oid,fid)
values(oid,fid);
end //
DELIMITER ;

drop trigger if exists order_price_after_add_food;
DELIMITER $$
create trigger order_price_after_add_food after insert on food_ordered for each row  
begin

update Orders 
set price = (select sum(price) from Food join food_ordered using (fid))
where Orders.oid = new.oid;

end$$
 
DELIMITER ;


drop procedure if exists change_order_status;
DELIMITER //
create procedure change_order_status(in oid int, in status char(50))
begin

update Orders
set Orders.ostatus = status
where Orders.oid = oid;

end //
DELIMITER ;

drop procedure if exists update_manager;
DELIMITER //
create procedure update_manager(in id int, in phone int, in email char(30), in pw int8)
begin
update Managers m
set m.mphone = phone, memail=email, mpassword=pw
where m.managerid = id;
end //
DELIMITER ;


drop procedure if exists update_customer;
DELIMITER //
create procedure update_customer(in id int, in phone int, in email char(30), in pw int8)
begin
update Customers c
set c.cphone = phone, cemail=email, cpassword=pw
where c.cid = id;
end //
DELIMITER ;


drop procedure if exists update_deliveryman;
DELIMITER //
create procedure update_deliveryman(in id int, in phone int, in email char(30), in pw int8)
begin
update Deliverymen d
set d.dphone = phone, demail=email, dpassword=pw
where d.did = id;
end //
DELIMITER ;


drop procedure if exists update_restaurant;
DELIMITER //
create procedure update_restaurant(in rid int, in updated_opentime char(20))
begin
update Restaurants r
set r.opentime=updated_opentime
where r.rid = rid;
end //
DELIMITER ;


drop procedure if exists update_food;
DELIMITER //
create procedure update_food(in fid int, in new_price int)
begin
update Food f
set f.price = new_price
where f.fid = fid;
end //
DELIMITER ;
call update_food(1, 245);
select * from food;
select* from managers;
drop procedure if exists update_password;
DELIMITER //
create procedure update_password(in pw int8, in id int, in table_name char)
begin

if(table_name = 'Managers') then
update Managers m
set  password = pw
where m.managerid = id ;
end if;
if(table_name = 'Customers' ) then
update Customers c
set  password = pw
where c.cid = id ;
end if;
if(table_name = 'Deliverymen') then
update Deliverymen d
set  password = pw
where d.did = id ;
end if;

end //
DELIMITER ;


 