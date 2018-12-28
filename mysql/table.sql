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
call create_restaurant('Duoduo Fat Foods', '920 Love St, Boston, MA', 94520, 'Fat Food', '24 Hours', 2);
call create_restaurant('Leilei Healthy Foods', '226 Love St, Boston, MA', 94520, 'Healthy', '24 Hours', 1);
call create_restaurant('The Q', '660 Washington St, Boston, MA', 02111, 'Hot Pot, Chinese', '11:30am to 11pm', 2);

-- ---------------------------------   Menus operations   ---------------------------------

drop table if exists Menus;
create table Menus(
menuid int primary key auto_increment,
menuname char(50) not null,
rid int not null,
constraint resfk foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop procedure if exists create_menu;
DELIMITER //
create procedure create_menu(in menuname char (50), in rid int)
begin
insert into Menus(menuname, rid)
values(menuname, rid);
end //
DELIMITER ;

call create_menu('Qdoba Mexican Eats', 1);
call create_menu('Ginger Exchange Menu', 2); 
call create_menu('Ichiban Yakitori Sushi House Menu', 3); 
call create_menu('Gyu-Kaku Happy Hour Menu', 4); 
call create_menu('Hokkaido Santouka Ramen', 5); 
call create_menu('The Hourly Oyster House', 6); 
call create_menu('Hanmaru Menu', 7); 
call create_menu('Kaju Tofu House', 8); 
call create_menu('FIve Spices House', 9); 
call create_menu('Hi B3ar Ice Cream Roll', 10); 
call create_menu('Duoduo Fat Foods Collection', 11); 
call create_menu('Leilei Healthy Foods Collection', 12); 
call create_menu('The Q Hot Pot Menu', 13); 



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
create procedure create_food(in menuid int, in fname char(50), in price double)
begin
insert into Food(menuid, fname,price)
values(menuid, fname, price);
end //
DELIMITER ;

-- for 1 - Qdoba
call create_food(1, 'Knockout Tacos',3.50); 
call create_food(1, 'Burrito-Vegetarian',7.20);
call create_food(1, 'Burrito-Grilled Steak',8.70);
call create_food(1, 'Burrito-Brisket',8.70);
call create_food(1, 'Burrito-Pork',8.70);
call create_food(1, 'Quesadilla-Chicken',8.10);
call create_food(1, 'Quesadilla-Steak',8.70);
call create_food(1, 'Quesadilla-Ground Beef',8.10); 
call create_food(1, 'Taco Salad',7.20); 
call create_food(1, 'Chips & Guacamole',3.00); 
call create_food(1, 'A Cup of Drink',1.89);

-- for 2 - Ginger Exchange
call create_food(2, 'WOW Wings - 8 Wings',11.95); 
call create_food(2, 'Korean Loaded Fries!',9.95);
call create_food(2, 'Bibimbap - Beef',15.25);
call create_food(2, 'Bibimbap - Chicken',13.25);
call create_food(2, 'Pineapple Fried Rice',13.70);
call create_food(2, 'Orange Chicken',12.70);
call create_food(2, 'Drunkard Noodles',11.95);
call create_food(2, 'Sushi Dinner',22.95);
call create_food(2, 'Sushi & Sashimi Dinner',12.95);
call create_food(2, 'Thai Iced Tear',3.75);

-- for 3 - Ichiban
call create_food(3, 'Chicken Teriyaki',9.00); 
call create_food(3, 'Pork Katsu',9.00);
call create_food(3, 'Salmon Teriyaki ',9.00);
call create_food(3, 'Tempura',9.00);
call create_food(3, 'Kalbi',10.00);
call create_food(3, 'Bulgogi',10.00);
call create_food(3, 'Sake Lunch Set ',12.95);
call create_food(3, 'Super Ichiban Set',15.00);
call create_food(3, 'Yaki Udon (choice)',9.25);
call create_food(3, 'Soda',1.25);

-- for 4 - GYU-kaku
call create_food(4, 'Spicy Cold Tofu',4.00); 
call create_food(4, 'Iced Tea',2.25); 
call create_food(4, 'Shrimp & Mushroom Ahijo',8.00);
call create_food(4, 'Japanese Fried Chicken',6.50);
call create_food(4, 'Chili Shrimp Shumai',7.00);
call create_food(4, 'Kobe Style Kalbi Short Rib',26.00);
call create_food(4, 'Beef Tongue',10.00);
call create_food(4, 'Harami In Secret Pot ',26.95);
call create_food(4, 'Garlic Shoyu Ribeye',6.00);
call create_food(4, 'Lady M Green Tea Mille w/ Ice Cream',11.00);

-- for 5 - Santouka Ramen 
call create_food(5, 'Shio ramen',12.95); 
call create_food(5, 'Shoyu ramen',11.80);
call create_food(5, 'Miso ramen',12.50);
call create_food(5, 'Spicy miso ramen',13.24);
call create_food(5, 'Char siu ramen',11.85);
call create_food(5, 'Tokusen toroniku ramen',12.35);
call create_food(5, 'Tokusen toroniku ',6.95);
call create_food(5, 'Hanjuku tamago',3.00);
call create_food(5, 'Yaki gyoza',8.95);

-- for 6 - Hourly Oyster House
call create_food(6, 'CLAM CHOWDER',9.00); 
call create_food(6, 'LOBSTER BISQUE',10.00);
call create_food(6, 'BAKED OYSTERS',14.50);
call create_food(6, 'FRIED CALAMARI',13.25);
call create_food(6, 'LOBSTER ROLL',28);
call create_food(6, 'THE HOURLY BURGER',14);
call create_food(6, 'SEAFOOD PASTA ',16.25);
call create_food(6, 'PAN ROASTED CHILI LOBSTER',30.00);
call create_food(6, 'CLASSIC CAESAR SALAD',10.95);

-- for 7 - Hanmaru
call create_food(7, 'Kimchi Pancake',10.95); 
call create_food(7, 'Ramen Salad',9.95);
call create_food(7, 'Kimchi Chigae',11.95);
call create_food(7, 'Jampong',12.25);
call create_food(7, 'Gamjatang - Set A',34.95);
call create_food(7, 'Gamjatang - Set A',28.95);
call create_food(7, 'Budae Jungol ',28.95);
call create_food(7, 'Soft Tofu Jungol',29.95);
call create_food(7, 'Bulgogi Jungol',33.95);
call create_food(7, 'Juice',2.95);

-- for 8 - Kaju Tofu
call create_food(8, 'Seafood & Beef Tofu',11.95); 
call create_food(8, 'Kimchi & Beef Tofu',12.95);
call create_food(8, 'Vegetable Tofu',10.95);
call create_food(8, 'Galbi (4 Strips)',19.25);
call create_food(8, 'Hot - Stone Bulgogi',19.95);
call create_food(8, 'Tofu & Beef B.B.Q Ribs',17.99);
call create_food(8, 'Tofu & Pork Belly ',17.95);
call create_food(8, 'Short Rib Meat Clay Pot',19.95);
call create_food(8, 'Seafood Clay Pot',12.95);
call create_food(8, 'Soda',1.95);

-- for 9 - FIve Spices House
call create_food(9, 'Szechuan Spicy Pork Dumpling',7.95); 
call create_food(9, 'Dan Dan Noodle',7.95);
call create_food(9, 'Tomato and Fried Stirred Egg Soup',8.95);
call create_food(9, 'White Rice',1.50);
call create_food(9, 'Soy Milk',2.50);
call create_food(9, 'Lo Mein',8.95);
call create_food(9, 'Scallion Pancakes ',5.95);
call create_food(9, 'Salt and Pepper Shrimp',19.95);
call create_food(9, 'Mo Po Tofu',10.95);
call create_food(9, 'Shredded Potato with Spicy Green Peppers',9.95);

-- for 10 - Ice Cream Roll
call create_food(10, 'Key Lime Pie',6.95); 
call create_food(10, 'Cookie Monster',6.95);
call create_food(10, 'Morning Call',6.95);
call create_food(10, 'Evil Berry ',6.95);
call create_food(10, 'Mango Tango',6.95);
call create_food(10, 'Pina Colada',6.95);
call create_food(10, 'Matcha Lady ',6.95);
call create_food(10, 'Monkey Lover',6.95);
call create_food(10, 'First Kiss',6.95);
call create_food(10, 'Sweet Heart',6.95);

-- for 11 - Duoduo fat food
call create_food(11, 'Pizza',6.95); 
call create_food(11, 'Beef Burger',9.95);
call create_food(11, 'Fries',4.95);
call create_food(11, 'Instant Noodle',7.95);
call create_food(11, 'Coke Cola',1.95);
call create_food(11, 'Doritos',1.89);
call create_food(11, 'Chocolate Cookie',3.95);
call create_food(11, 'Burble Tea',5.95);
call create_food(11, 'Chocolate Ice Cream',5.95);
call create_food(11, 'Lobster and Crab Roll',19.95);

-- for 12 - Leilei Healthy food
call create_food(12, 'Rice Bowl',6.95); 
call create_food(12, 'Boiled Vegetable',9.95);
call create_food(12, 'Wheat Toast',3.95);
call create_food(12, 'Green Tea',2.95);
call create_food(12, 'Chicken Salad',8.95);
call create_food(12, 'Boiled Eggs',2.50);
call create_food(12, 'Plain Yogurt',1.95);
call create_food(12, 'Vegetable soup',5.95);
call create_food(12, 'Non-fat Milk',5.95);
call create_food(12, 'Low-Calories Cereal ',4.95);

-- for 13 - The Q
call create_food(13, 'Szechuan Chili Broth',8.00); 
call create_food(13, 'Creazy Mala Broth',8.00);
call create_food(13, 'Tomato Broth',5.00);
call create_food(13, 'Black Bone Chicken Broth',3.00);
call create_food(13, 'Beef and Lamb',22.50);
call create_food(13, 'Supreme Seafood',20.95);
call create_food(13, 'Angus Sirloin ',17.95);
call create_food(13, 'High Chioce Lamb',17.95);
call create_food(13, 'S.T. Noodles',2.95);
call create_food(13, 'Cellophane Noodles',2.95);
call create_food(13, 'Fish Cake',3.50);
call create_food(13, 'Tongho',4.95);
call create_food(13, 'A Choy',4.00);
call create_food(13, 'Potatoes',3.00);
call create_food(13, 'Corns On The Cob',2.95);
call create_food(13, 'Fried Gluten Balls',2.95);
call create_food(13, 'Mushroom',6.50);
call create_food(13, 'Tofu Platter',6.95);
call create_food(13, 'Fried Tofu Skin',6.00);
call create_food(13, 'Dried Bean Curd',4.00);
call create_food(13, 'Iced Bean Curd',4.00);
call create_food(13, 'Udon',2.95);

select * from Food;

drop table if exists Orders;
create table Orders(
oid int primary key auto_increment,
datecreated timestamp default CURRENT_TIMESTAMP,
cid int default null,
rid int default null,
did int default null,
address char(100) not null,
price double default 0.0,
ostatus char(50) default 'inCart', -- inCart, submitted, waitAllocate, delivering, finished
constraint customer_foreign_key foreign key(cid) references Customers(cid) on delete set null on update cascade,
constraint restaurant_foreign_key foreign key(rid) references Restaurants(rid) on delete set null on update cascade,
constraint deliveryMan_foreign_key foreign key(did) references Deliverymen(did) on delete set null on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists food_ordered;
create table food_ordered(
oid int not null,
fid int not null,
quantity int default 1,
primary key(oid,fid),
constraint order_foreign_key foreign key(oid) references Orders(oid) on delete cascade on update cascade,
constraint food_foreign_key foreign key(fid) references Food(fid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ---------------------------------   the above code was changed by Frank and his bunny  ---------------------------------
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