use foodDelivery;


drop procedure if exists create_reviews;
DELIMITER //
create procedure create_reviews(in cid int, in rid int, in review char (200))
begin
insert into Reviews(cid,rid,review)
values(cid,rid,review);
end //
DELIMITER ;

drop procedure if exists create_manager;
DELIMITER //
create procedure create_manager(in user_name char (50), in phone char(50), in email char(80), in user_password int8)
begin
insert into Managers(mname,mphone,memail,mpassword)
values(user_name, phone,email,user_password);
end //
DELIMITER ;

call create_manager('maomao','888888888','mao@mao.com',12345678);  

drop procedure if exists create_deliverymen;
DELIMITER //
create procedure create_deliverymen(in name char (50), in phone char(50), in email char(80), in password int8)
begin
insert into Deliverymen(dname,dphone,demail,dpassword)
values(name, phone,email,password);
end //
DELIMITER ;

call create_deliverymen('yuaiai','777777777','yu@yu.com',12345678);


drop procedure if exists create_restaurant;
DELIMITER //
create procedure create_restaurant(in name char (50), in address char(50), opentime char(30), in managerid int)
begin
insert into Restaurants(rname,address,opentime,managerid)
values(name,address,opentime,managerid);
end //
DELIMITER ;


call create_restaurant('qdoba', '393 huntington ave','10am to 10pm',1);  


drop procedure if exists create_food;
DELIMITER //
create procedure create_food(in rid int, in name char (50), in price double)
begin
insert into Food(rid,fname,price)
values(rid,name, price);
end //
DELIMITER ;

call create_food(1, 'pizza',20); 
call create_food(1, 'bowl',1.12);
call create_food(1, 'coke',1);
call create_food(1, 'chicken',3);
call create_food(1, 'rice',0.5); 


drop procedure if exists create_order;
DELIMITER //
create procedure create_order(in datecreated char(50),in cid int, in rid int, in address char(50), in status char(50))
begin
insert into Orders(datecreated, cid,rid,address,ostatus)
values(datecreated,cid,rid,address,status);
end //
DELIMITER ;

call create_order('2017-12-07 11:50pm',1,1,'407 huntington ave','in cart');



