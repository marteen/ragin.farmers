-- Creation Date: Wed, 08 Aug 2012 08:27:11 -0300
-- Author: Fernando Canizo (aka conan) - http://conan.muriandre.com/


-- Note: Foreign key prefixed with 'fk_' + original name + optional clarifier name


-- define character sets for connection between client and server
-- however don't use crazy characters in table names, PHP will choke
set character_set_client = 'utf8';
set character_set_results = 'utf8';

set foreign_key_checks = 0; -- this recreates everything from scratch, so it's ok


-- Clean start
drop database if exists ragin_farmers_test;
create database ragin_farmers_test;
use ragin_farmers_test;


drop table if exists users;
create table users (
	use_id serial primary key,
	use_email varchar(255) not null unique,
	use_cool_name varchar(20) unique,
	use_password varchar(32) not null -- TODO: made for an md5sum, but I want to use bcrypt for this, I don't know which size should be
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Note: I'm not sure about this one right now, if we aim for simplicity there should be only one playground
-- but I think we should care about possible growth, define the table and use only one for now
drop table if exists playgrounds;
create table playgrounds (
	pla_id serial primary key,
	pla_name varchar(10) not null unique
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists locations;
create table locations (
	loc_id serial primary key,
	loc_x int unsigned not null,
	loc_y int unsigned not null,
	loc_fk_pla_id bigint unsigned not null,
	foreign key (loc_fk_pla_id) references playgrounds (pla_id),
	loc_fk_use_id bigint unsigned not null,
	foreign key (loc_fk_use_id) references users (use_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table if exists user_status (
	us_fk_use_id bigint unsigned not null,
	foreign key (us_fk_use_id) references users (use_id),
	us_life int unsigned not null, -- 1-100%
	us_ammo_left int unsigned not null, -- will have a refill wait
	us_logged_in bool not null default 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
