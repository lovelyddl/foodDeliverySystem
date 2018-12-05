use foodDelivery;


drop procedure if exists show_food;
DELIMITER //
create procedure show_food(in name char (50))
begin
select fname,price from Food join Restaurants r using (rid)
where r.rname = name;
end //
DELIMITER ;

call show_food('qdoba');

drop procedure if exists show_food_by_id;
DELIMITER //
create procedure show_food_by_id(in id int)
begin
select fname,price from Food join Restaurants r using (rid)
where r.rid = id;
end //
DELIMITER ;

call show_food_by_id(1);


drop procedure if exists find_manager_by_name;
DELIMITER //
create procedure find_manager_by_name(in name char (50))
begin
select * from Managers m where m.mname = name;
end //
DELIMITER ;

call find_manager_by_name('maomao');



drop procedure if exists find_manager_by_id;
DELIMITER //
create procedure find_manager_by_id(in id int)
begin
select * from Managers m where m.managerid = id;
end //
DELIMITER ;

call find_manager_by_id(1);

drop procedure if exists find_manager_by_id_pw;
DELIMITER //
create procedure find_manager_by_id_pw(in id int, in pw int8)
begin
select * from Managers m where m.managerid = id and m.mpassword = pw;
end //
DELIMITER ;


drop procedure if exists find_deliveryman_by_name;
DELIMITER //
create procedure find_deliveryman_by_name(in name char (50))
begin
select * from Deliverymen d where d.dname = name;
end //
DELIMITER ;

drop procedure if exists find_deliveryman_by_id;
DELIMITER //
create procedure find_deliveryman_by_id(in id int)
begin
select * from Deliverymen d where d.did = id;
end //
DELIMITER ;

drop procedure if exists find_deliveryman_by_id_pw;
DELIMITER //
create procedure find_deliveryman_by_id_pw(in id int, in pw int8)
begin
select * from Deliverymen d where d.did = id and d.dpassword = pw;
end //
DELIMITER ;



drop procedure if exists find_customer_by_name;
DELIMITER //
create procedure find_customer_by_name(in name char (50))
begin
select * from Customers c where c.cname = name;
end //
DELIMITER ;

drop procedure if exists find_customer_by_id;
DELIMITER //
create procedure find_customer_by_id(in id int)
begin
select * from Customers c where c.cid = id;
end //
DELIMITER ;

drop procedure if exists find_customer_by_id_pw;
DELIMITER //
create procedure find_customer_by_id_pw(in id int, in pw int8)
begin
select * from Customers where c.cid = id and c.cpassword = pw;
end //
DELIMITER ;

drop procedure if exists find_restaurant_by_name;
DELIMITER //
create procedure find_restaurant_by_name(in name char (50))
begin
select rname,address,opentime from Restaurants r where r.rname = name;
end //
DELIMITER ;



drop procedure if exists find_restaurant_by_rid;
DELIMITER //
create procedure find_restaurant_by_rid(in id int)
begin
select rname,address,opentime from Restaurants r where r.rid = id;
end //
DELIMITER ;

drop procedure if exists find_restaurant_by_mid;
DELIMITER //
create procedure find_restaurant_by_mid(in id int)
begin
select rname,address,opentime from Restaurants r where r.managerid = id;
end //
DELIMITER ;



drop procedure if exists find_ava_deliverymen;
DELIMITER //
create procedure find_ava_deliverymen()
begin
select dname,dphone from Deliverymen d where d.dstatus = 'available';
end //
DELIMITER ;



drop procedure if exists find_review;
DELIMITER //
create procedure find_review(in id int)
begin
select review from Reviews join Restaurants using(rid)
where Restaurants.rid = rid;
end //
DELIMITER ;

drop procedure if exists deliveryman_view;
DELIMITER //
create procedure deliveryman_view(in name char (50))
begin
select oid, datecreated, price, address, cphone, cname from Orders join Deliverymen using (did)
join Customers using (cid)
where name =  Deliverymen.dname;
end //
DELIMITER ;


drop procedure if exists find_order_by_user_id;
DELIMITER //
create procedure find_order_by_user_id(in id int, in table_name char(50))
begin
if(table_name = 'Managers') then
select oid, cname, o.address,price,datecreated,ostatus,dname from Orders o join Restaurants r using (rid)
join Managers m using (managerid)
join Deliverymen d using (did)
join Customers c using (cid)
where m.managerid= id;
end if;
if(table_name = 'Customers' ) then
select oid,rname,o.address,price,datecreated,ostatus,dname from Orders o join Customers c using (cid)
 join Deliverymen d using (did)
 join Restaurants r using (rid)
where c.cid = id;
end if;
if(table_name = 'Deliverymen') then
select oid, cname, rname, r.address, o.address,price,datecreated,ostatus from Orders o join Deliverymen d using (did) 
join Restaurants r using (rid)
join Customers c using (cid)
where d.did=id ;
end if;
end //
DELIMITER ;


