drop schema if exists fooddelivery;
create schema FoodDelivery;
use foodDelivery;


drop table if exists  Customers;
create table Customers (
cid int primary key auto_increment,
cname char(100) not null unique,
cphone int(15) not null,
cemail char(30) default null,
cpassword int8 not null
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists  Deliverymen;
create table Deliverymen(
did int primary key auto_increment,
dname char(30) not null unique,
dphone int not null,
demail char(30) default null,
dpassword int8 not null,
dstatus char(20) default 'available'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists  Managers;
create table Managers(
managerid int primary key auto_increment,
mname char(30) not null unique,
mphone int not null,
memail char(30) default null,
mpassword int8 not null
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists Restaurants;
create table Restaurants(
rid int primary key auto_increment,
rname char(20) not null,
address char(30) not null,
opentime char(30) not null,
managerid int default null,
constraint mfk foreign key(managerid) references Managers(managerid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists Food;
create table Food (
fid int primary key auto_increment,
rid int not null,
fname char(50) not null,
price double not null,
constraint ridfk foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists food_ordered;
create table food_ordered(
oid int not null,
fid int not null,
quantity int default 1,
primary key(oid,fid),
constraint ofk foreign key(oid) references Orders(oid) on delete cascade on update cascade,
constraint ffk2 foreign key(fid) references Food(fid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


drop table if exists Reviews;
create table Reviews(
wid int primary key auto_increment,
cid int default null,
rid int not null,
review char(200) not null,
constraint cfk3 foreign key(cid) references Customers(cid) on delete set null on update cascade,
constraint rfk3 foreign key(rid) references Restaurants(rid) on delete cascade on update cascade
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

