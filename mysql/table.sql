drop database if exists foodDelivery;
create database foodDelivery;
use foodDelivery;

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

call create_customer('duoduo', 666666666, 'duoduo@duo.com', '12345678');  
call create_customer('duoduo211', 1234567811901, 'duod1hhuo@1duo.com', '12345678'); 

select * from Customers;
select * from Customers where cname = 'duoduo';
select * from Customers where cphone = 666666666;

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
create procedure create_deliverymen(in user_name char (100), in phone int(15), in email char(80), in user_password char(40))
begin
insert into Deliverymen(dname, dphone, demail, dpassword) values(user_name, phone, email, user_password);
end //
DELIMITER ;

call create_deliverymen('yuaiai', 777777777, 'yu@yu.com', '12345678');
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

select logInCheckName('duoduo', '12345678', 'customer');
select logInCheckName('yuaiai', '12345678', 'deliveryMan');

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

select logInCheckPhone(666666666, '12345678', 'customer');
select logInCheckPhone(777777777, '12345678', 'deliveryMan');

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

select logInCheckEmail('duoduo@duo.com', '12345678', 'customer');
select logInCheckEmail('yu@yu.com', '12345678', 'deliveryMan');


-- ---------------------------------   the above code was changed by Frank   ---------------------------------
/*
drop table if exists  Managers;
create table Managers(
managerid int primary key auto_increment,
mname char(30) not null unique,
mphone int not null,
memail char(30) default null,
mpassword int8 not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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