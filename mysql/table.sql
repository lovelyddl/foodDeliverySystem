drop database if exists foodDelivery;
create database foodDelivery;
use foodDelivery;

-- ---------------------------------   Admin operations   ---------------------------------
drop table if exists  Admins;
create table Admins (
	aid int primary key auto_increment,
	aname char(100) not null unique,
	aphone char(15) not null unique,
	aemail char(80) default null unique,
	apassword char(40) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_admin;
DELIMITER //
create procedure create_admin(
	in user_name char (100), 
	in phone char(15), 
	in email char(80), 
	in user_password char(40)
)
begin
insert into Admins(aname, aphone, aemail, apassword)
values(user_name, phone, email, user_password);
end //
DELIMITER ;

call create_admin('cuteduo', 9999999999, 'cuteduo@duo.com', 'cuteduoduo');  
call create_admin('bestlei', 8888888888, 'bestlei@lei.com', 'bestleilei'); 

-- ---------------------------------   Customer operations   ---------------------------------
drop table if exists  Customers;
create table Customers (
	cid int primary key auto_increment,
	cname char(100) not null unique,
	cphone char(15) not null unique,
	cemail char(80) default null unique,
	cpassword char(40) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_customer;
DELIMITER //
create procedure create_customer(
	in user_name char (100), 
	in phone char(15), 
	in email char(80), 
	in user_password char(40)
)
begin
insert into Customers(cname, cphone, cemail, cpassword)
values(user_name, phone, email, user_password);
end //
DELIMITER ;

call create_customer('jingyi', 4444444444, 'jingyi@jy.com', '12345678');
call create_customer('houyi', 5555555555, 'houyi@hou.com', '12345678');

select * from Customers;
select * from Customers where cname = 'houyi';
select * from Customers where cphone = 5555555555;

-- ---------------------------------   Deliverymen operations   ---------------------------------
drop table if exists  Deliverymen;
create table Deliverymen(
	did int primary key auto_increment,
	dname char(100) not null unique,
	dphone char(15) not null unique,
	demail char(80) default null,
	dpassword char(40) not null,
	dstatus char(20) default 'available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop procedure if exists create_deliverymen;
DELIMITER //
create procedure create_deliverymen(in user_name char (100), in phone char(15), in email char(80), in user_password char(40))
begin
insert into Deliverymen(dname, dphone, demail, dpassword) values(user_name, phone, email, user_password);
end //
DELIMITER ;

call create_deliverymen('yuaiai', 3333333333, 'yu@yu.com', '12345678');

select * from Deliverymen;

-- ---------------------------------   logIn operations   ---------------------------------
drop function if exists logInCheckName;
DELIMITER //
create function logInCheckName
( 
  userName varchar(100),
  userPassword varchar(40),
  table_type varchar(20)
) returns boolean
begin
	DECLARE log_check boolean DEFAULT false;

	if (table_type = 'customer') 
	then 
		if (userName in (select cname from Customers) &&
		   userPassword = (select cpassword from Customers where cname = userName))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given customer name or password is incorrect.';
		end if;
	else 
		if (userName in (select dname from Deliverymen) &&
		   userPassword = (select dpassword from Deliverymen where dname = userName))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given deliveryMan name or password is incorrect.';
		end if;
	end if;

	return log_check;
end //
DELIMITER ;

select logInCheckName('houyi', '12345678', 'customer');
-- select logInCheckName('yuaiai', '12345678', 'deliveryMan');

drop function if exists logInCheckPhone;
DELIMITER //
create function logInCheckPhone
( 
  userPhone char(15),
  userPassword varchar(40),
  table_type varchar(20)
) returns boolean
begin
	DECLARE log_check boolean DEFAULT false;

	if (table_type = 'customer') 
	then 
		if (userPhone in (select cphone from Customers) &&
		   userPassword = (select cpassword from Customers where cphone = userPhone))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given customer phone or password is incorrect.';
		end if;
	else 
		if (userPhone in (select dphone from Deliverymen) &&
		   userPassword = (select dpassword from Deliverymen where dphone = userPhone))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given deliveryMan phone or password is incorrect.';
		end if;
	end if;

	return log_check;
end //
DELIMITER ;

select logInCheckPhone(4444444444, '12345678', 'customer');
-- select logInCheckPhone(3333333333, '12345678', 'deliveryMan');

drop function if exists logInCheckEmail;
DELIMITER //
create function logInCheckEmail
( 
  userEmail varchar(80),
  userPassword varchar(40),
  table_type varchar(20)
) returns boolean
begin
	DECLARE log_check boolean DEFAULT false;

	if (table_type = 'customer') 
	then 
		if (userEmail in (select cemail from Customers) &&
		   userPassword = (select cpassword from Customers where cemail = userEmail))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given customer email or password is incorrect.';
		end if;
	else 
		if (userEmail in (select demail from Deliverymen) &&
		   userPassword = (select dpassword from Deliverymen where demail = userEmail))
		then set log_check = true;
		else SIGNAL SQLSTATE 'ME001'
					SET MESSAGE_TEXT = 'Given deliveryMan email or password is incorrect.';
		end if;
	end if;

	return log_check;
end //
DELIMITER ;

select logInCheckEmail('houyi@hou.com', '12345678', 'customer');
-- select logInCheckEmail('yu@yu.com', '12345678', 'deliveryMan');


-- ---------------------------------   Mangagers operations   ---------------------------------

drop table if exists  Managers;
create table Managers(
managerid int primary key auto_increment,
mname char(30) not null unique,
mphone char(15) not null,
memail char(50) default null,
mpassword char(40) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_manager;
DELIMITER //
create procedure create_manager(in user_name char (30), in phone char(15), in email char(50), in user_password char(40) )
begin
insert into Managers(mname, mphone, memail, mpassword)
values(user_name, phone, email, user_password);
end //
DELIMITER ;

call create_manager('managerlei',7777777777,'managerlei@lei.com', 'managerlei');  
call create_manager('managerduo',6666666666,'managerduo@duo.com', 'managerduo');  


-- ---------------------------------   Restaurants operations   ---------------------------------

drop table if exists Restaurants;
create table Restaurants(
rid int primary key auto_increment,
rname char(50) not null,
address char(100) not null,
zipcode int not null,
restype char(30) not null,
opentime char(100) not null,
managerid int default null,
constraint mfk foreign key(managerid) references Managers(managerid) on delete set null on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop procedure if exists create_restaurant;
DELIMITER //
create procedure create_restaurant(in rname char (50), in address char(100), in zipcode int, in restype char(30), in opentime char(100), in managerid int)
begin
insert into Restaurants(rname, address, zipcode, restype, opentime, managerid)
values(rname, address, zipcode, restype, opentime, managerid);
end //
DELIMITER ;

select * from Restaurants;

call create_restaurant('Qdoba', '393 Huntington Ave, Boston, MA',02115, 'Mexican', '10am to 10pm', 2);  
call create_restaurant('Ginger Exchange', '250 Huntington Ave, Boston, MA',02115, 'Vietnamese', '11:30am to 11pm', 1);  
call create_restaurant('Ichiban Yakitori Sushi House', '14 Westland Ave, Boston, MA',02115, 'Yakitori, Japanese', '11:30am to 10pm', 1);  
call create_restaurant('Gyu-Kaku Japanese BBQ', '16-18 Eliot St, Cambridge, MA', 02138, 'Japanese', '11"30am to 10:30pm', 2);  
call create_restaurant('Hokkaido Santouka Ramen', '1 Bow St, Cambridge, MA',02138, 'Ramen', '11am to 9:30pm', 1);  
call create_restaurant('The Hourly Oyster House', '15 Dunster St, Cambridge, MA',02138, 'Seafood, Oyster, Bar', '11am to 12am', 2);  
call create_restaurant('Hanmaru', '168 Harvard Ave, Allston, MA', 02134, 'Korean', '11am to 10pm', 2);  
call create_restaurant('Kaju Tofu House', '56 Harvard Ave, Allston, MA',02134, 'Korean', '11am to 10pm', 2);  
call create_restaurant('FIve Spices House', '58 Beach St, Boston, MA',02111, 'Chinese', '11am to 10:45pm', 2);  
call create_restaurant('Hi B3ar Ice Cream Roll', '147 Brighton Ave, Allston, MA',02134, 'Ice Cream', '11:30am to 11pm', 2);  
call create_restaurant('Duoduo Fat foods', '920 Love St, Boston, MA', 94520, 'Fat Food', '24 Hours', 2);
call create_restaurant('Leilei Healthy foods', '226 Love St, Boston, MA', 94520, 'Healthy', '24 Hours', 1);

-- ---------------------------------   Menus operations   ---------------------------------

drop table if exists  Menus;
create table Menus(
menuid int primary key auto_increment,
menuname char(30) not null,
rid int not null,
constraint resfk foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_menu;
DELIMITER //
create procedure create_menu(in menuname char (30), in rid int)
begin
insert into Menus(menuname, rid)
values(menuname, rid);
end //
DELIMITER ;

call create_menu('Fast Foods', 11); 
call create_menu('Create your own bowl', 1);


-- ---------------------------------   Food operations   ---------------------------------

drop table if exists Food;
create table Food (
fid int primary key auto_increment,
menuid int not null,
fname char(50) not null,
price double not null,
constraint menufk foreign key(menuid) references Menus(menuid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_food;
DELIMITER //
create procedure create_food(in menuid int, in fname char (50), in price double)
begin
insert into Food(menuid, fname,price)
values(menuid, fname, price);
end //
DELIMITER ;

call create_food(1, 'pizza',10.99); 
call create_food(2, 'regular bowl',8.75);
call create_food(1, 'coke',1.59);
call create_food(1, 'fried chicken',7.99);
call create_food(2, 'rice noodle',6.95); 

-- ---------------------------------   the above code was changed by Frank   ---------------------------------
/*



drop table if exists Restaurants;
create table Restaurants(
rid int primary key auto_increment,
rname char(20) not null,
address char(30) not null,
opentime char(30) not null,
managerid int default null,
constraint mfk foreign key(managerid) references Managers(managerid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists Food;
create table Food (
fid int primary key auto_increment,
rid int not null,
fname char(50) not null,
price double not null,
constraint ridfk foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists Orders;
create table Orders(
oid int primary key auto_increment,
datecreated char(20) not null,
cid int default null,
rid int default null,
did int default null,
address char(50) not null,
price double default 0,
ostatus char(50) default 'in cart',
constraint cfk2 foreign key(cid) references Customers(cid) on delete set null on update cascade,
constraint rfk2 foreign key(rid) references Restaurants(rid) on delete set null on update cascade,
constraint dfk2 foreign key(did) references Deliverymen(did) on delete set null on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists food_ordered;
create table food_ordered(
oid int not null,
fid int not null,
quantity int default 1,
primary key(oid,fid),
constraint ofk foreign key(oid) references Orders(oid) on delete cascade on update cascade,
constraint ffk2 foreign key(fid) references Food(fid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists Reviews;
create table Reviews(
wid int primary key auto_increment,
cid int default null,
rid int not null,
review char(200) not null,
constraint cfk3 foreign key(cid) references Customers(cid) on delete set null on update cascade,
constraint rfk3 foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

*/