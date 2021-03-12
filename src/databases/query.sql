select * from tbl_aspiration;
select * from tbl_make;
select * from tbl_body_style;
select * from tbl_cylinders;
select * from tbl_doors;
select * from tbl_drive_wheel;
select * from tbl_engine_location;
select * from tbl_engine_type;
select * from tbl_fuel_type;
select * from tbl_fuel_system;
select * from tbl_car;
select * from tbl_body;
select * from tbl_cylinder;
select * from tbl_engine;
select * from tbl_fuel;


select * from car;

delete from tbl_aspiration;
delete from tbl_make;
delete from tbl_body_style;
delete from tbl_cylinders;
delete from tbl_doors;
delete from tbl_drive_wheel;
delete from tbl_engine_location;
delete from tbl_engine_type;
delete from tbl_fuel_type;
delete from tbl_fuel_system;
delete from tbl_make;
delete from car;

----
DROP TABLE IF EXISTS fuel_temp;
-------------------
drop trigger if exists auto_insert_tbl_body on car;
drop trigger if exists auto_insert_tbl_fuel on car;
drop trigger if exists auto_insert_tbl_cylinder on car;
drop trigger if exists auto_insert_tbl_engine on car;
drop trigger if exists auto_insert_tbl_car on car;
drop trigger if exists auto_insert on car;

insert into car values (300, 0, 120, 'peugot', 'gas', 'std', 'four', 'merc', 'rwd', 'front', 107.4, 111111, 11111, 2222, 3025, 'ohc', 'four', 222, 'idi', 222, 3.19, 8.4, 22, 2222, 22, 22, 22222, '5/01/2001');
insert into car values (301, 5, 120, 'peugot', 'xang', 'std', 'four', 'sedan', 'rwd', 'inside', 107.4, 111111, 11111, 2222, 3025, 'ddp', 'four', 222, 'idi', 222, 3.19, 8.4, 22, 2222, 22, 22, 22222, '5/01/2001');
insert into car values (302, 2, 120, 'peugot', 'gas', 'std', 'tow', 'bmw', 'rwd', 'inside', 107.4, 111111, 11111, 2222, 3025, 'ddp', 'three', 222, 'idi', 222, 3.19, 8.4, 22, 2222, 22, 22, 22222, '5/01/2001');
insert into car values (303, 1, 120, 'peugot', 'dau', 'std', 'one', 'bmw', 'rwd', 'front', 107.4, 111111, 11111, 2222, 3025, 'ohc', 'four', 222, 'idi', 222, 3.19, 8.4, 22, 2222, 22, 22, 22222, '5/01/2001');
insert into car values (304,10, 120, 'peugot', 'gas', 'std', 'four', 'sedan', 'rwd', 'front', 107.4, 111111, 11111, 2222, 3025, 'ohc', 'three', 222, 'idi', 222, 3.19, 8.4, 22, 2222, 22, 22, 22222, '5/01/2001');

---
select distinct body_id, cylinder_id, make_id, engine_id, fuel_id, symboling, 
				normalized_losses, price, load_date, curb_weight from tbl_car;
-----
select distinct  symboling, normalized_losses, make, fuel_type, aspiration, num_of_doors, body_style,
		drive_wheel, engine_location, wheel_base, length, width, height, curb_weight,
		engine_type, num_of_cylinders, engine_size, fuel_system, bore, stroke, compression_ratio,
		horsepower, peak_rpm, city_mpg, highway_mpg, price, load_date from car;

---------------------------
SELECT
    symboling, normalized_losses, make, fuel_type, aspiration, num_of_doors, body_style,
		drive_wheel, engine_location, wheel_base, length, width, height, curb_weight,
		engine_type, num_of_cylinders, engine_size, fuel_system, bore, stroke, compression_ratio,
		horsepower, peak_rpm, city_mpg, highway_mpg, price, load_date, COUNT(*) AS CountOf
    FROM car
    GROUP BY symboling, normalized_losses, make, fuel_type, aspiration, num_of_doors, body_style,
		drive_wheel, engine_location, wheel_base, length, width, height, curb_weight,
		engine_type, num_of_cylinders, engine_size, fuel_system, bore, stroke, compression_ratio,
		horsepower, peak_rpm, city_mpg, highway_mpg, price, load_date
    HAVING COUNT(*)>1
