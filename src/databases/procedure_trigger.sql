drop function if exists auto_insert_body();
-------
CREATE OR REPLACE FUNCTION auto_insert_body() 
	RETURNS trigger 
AS $$
BEGIN
DROP TABLE IF EXISTS body_temp;
CREATE TEMP TABLE IF NOT EXISTS body_temp AS
    SELECT DISTINCT
		body_style, 
		num_of_doors,
		length, 
		width,
		height
	FROM car;
--------------
UPDATE body_temp SET body_style=tbl_body_style.body_style_id, num_of_doors=tbl_doors.num_of_doors_id
	FROM tbl_body_style, tbl_doors 
	WHERE tbl_body_style.body_style=body_temp.body_style and tbl_doors.num_of_doors=body_temp.num_of_doors;
--------------------
--------------------
alter table body_temp
	alter column body_style type bigint USING body_style::bigint,
	alter column num_of_doors type bigint USING num_of_doors::bigint;
------------
INSERT INTO tbl_body(body_style_id, num_of_doors_id, length, width, height) SELECT distinct * FROM body_temp;
-----------------------------
DROP TABLE IF EXISTS body_temp;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
----------------
-----------------
CREATE TRIGGER auto_insert_tbl_body
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert_body();
----
-------
drop function if exists auto_insert_fuel();
----------
CREATE OR REPLACE FUNCTION auto_insert_fuel() 
	RETURNS trigger 
AS $$
BEGIN
DROP TABLE IF EXISTS fuel_temp;
CREATE TEMP TABLE IF NOT EXISTS fuel_temp AS
    SELECT DISTINCT
		fuel_system, 
		fuel_type
	FROM car;
--------------
UPDATE fuel_temp SET fuel_system=tbl_fuel_system.fuel_system_id, fuel_type=tbl_fuel_type.fuel_type_id
	FROM tbl_fuel_system, tbl_fuel_type 
	WHERE tbl_fuel_system.fuel_system=fuel_temp.fuel_system and tbl_fuel_type.fuel_type=fuel_temp.fuel_type;
--------------------
--------------------
alter table fuel_temp
	alter column fuel_system type bigint USING fuel_system::bigint,
	alter column fuel_type type bigint USING fuel_type::bigint;
------------
INSERT INTO tbl_fuel(fuel_system_id, fuel_type_id) SELECT distinct * FROM fuel_temp;
-----------------------------
DROP TABLE IF EXISTS fuel_temp;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
----------------
CREATE TRIGGER auto_insert_tbl_fuel
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert_fuel();
----

drop function if exists auto_insert_cylinder();
-------------------
CREATE OR REPLACE FUNCTION auto_insert_cylinder() 
	RETURNS trigger 
AS $$
BEGIN
DROP TABLE IF EXISTS cylinder_temp;
CREATE TEMP TABLE IF NOT EXISTS cylinder_temp AS
    SELECT DISTINCT
		num_of_cylinders, 
		bore,
		compression_ratio
	FROM car;
--------------
UPDATE cylinder_temp SET num_of_cylinders=tbl_cylinders.num_of_cylinders_id
	FROM tbl_cylinders
	WHERE tbl_cylinders.num_of_cylinders=cylinder_temp.num_of_cylinders;
--------------------
--------------------
alter table cylinder_temp
	alter column num_of_cylinders type bigint USING num_of_cylinders::bigint;
------------
INSERT INTO tbl_cylinder(num_of_cylinders_id, bore, compression_ratio) SELECT distinct * FROM cylinder_temp;
-----------------------------
DROP TABLE IF EXISTS cylinder_temp;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
----------------
CREATE TRIGGER auto_insert_tbl_cylinder
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert_cylinder();
----
--------
drop function if exists auto_insert_engine();
-------------------
CREATE OR REPLACE FUNCTION auto_insert_engine() 
	RETURNS trigger 
AS $$
BEGIN
DROP TABLE IF EXISTS engine_temp;
CREATE TEMP TABLE IF NOT EXISTS engine_temp AS
    SELECT DISTINCT
		engine_location, 
		engine_type,
		drive_wheel,
		aspiration,
		engine_size,
		stroke,
		horsepower,
		peak_rpm,
		wheel_base,
		city_mpg,
		highway_mpg
	FROM car;
--------------
UPDATE engine_temp 
	SET engine_location=tbl_engine_location.engine_location_id, 
		engine_type = tbl_engine_type.engine_type_id,
		drive_wheel = tbl_drive_wheel.drive_wheel_id,
		aspiration = tbl_aspiration.aspiration_id
	FROM tbl_engine_location, tbl_engine_type, tbl_drive_wheel, tbl_aspiration
	WHERE tbl_engine_location.engine_location=engine_temp.engine_location and
		tbl_engine_type.engine_type=engine_temp.engine_type and
		tbl_drive_wheel.drive_wheel=engine_temp.drive_wheel and
		tbl_aspiration.aspiration=engine_temp.aspiration;
--------------------
--------------------
alter table engine_temp
	alter column engine_location type bigint USING engine_location::bigint,
	alter column engine_type type bigint USING engine_type::bigint,
	alter column drive_wheel type bigint USING drive_wheel::bigint,
	alter column aspiration type bigint USING aspiration::bigint;
------------
INSERT INTO tbl_engine(
	engine_location_id, 
	engine_type_id, 
	drive_wheel_id, 
	aspiration_id, 
	engine_size,
	stroke,
	horsepower,
	peak_rpm,
	wheel_base,
	city_mpg,
	highway_mpg) 
	SELECT distinct * FROM engine_temp;
-----------------------------
DROP TABLE IF EXISTS engine_temp;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
----------------
CREATE TRIGGER auto_insert_tbl_engine
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert_engine();
----
--------
drop function if exists auto_insert_car();
-------------------
CREATE OR REPLACE FUNCTION auto_insert_car() 
	RETURNS trigger 
AS $$
BEGIN
DROP TABLE IF EXISTS car_temp;
CREATE TEMP TABLE IF NOT EXISTS car_temp AS
    SELECT DISTINCT
		symboling, normalized_losses, make, fuel_type, aspiration, num_of_doors, body_style,
		drive_wheel, engine_location, wheel_base, length, width, height, curb_weight,
		engine_type, num_of_cylinders, engine_size, fuel_system, bore, stroke, compression_ratio,
		horsepower, peak_rpm, city_mpg, highway_mpg, price, load_date
	FROM car;
--------------
UPDATE car_temp 
	SET body_style=tbl_body.body_id, 
		num_of_cylinders = tbl_cylinder.cylinder_id,
		make = tbl_make.make_id,
		engine_type = tbl_engine.engine_id,
		fuel_type = tbl_fuel.fuel_id
	FROM tbl_body, tbl_body_style, tbl_doors, tbl_cylinder, tbl_cylinders, tbl_make, tbl_engine, 
		tbl_engine_location, tbl_engine_type, tbl_drive_wheel, tbl_aspiration, tbl_fuel, 
		tbl_fuel_system, tbl_fuel_type
	WHERE tbl_body.body_style_id=tbl_body_style.body_style_id and
		tbl_body.num_of_doors_id=tbl_doors.num_of_doors_id and
		tbl_body_style.body_style=car_temp.body_style and
		tbl_doors.num_of_doors=car_temp.num_of_doors and
		tbl_body.length=car_temp.length and
		tbl_body.width=car_temp.width and
		tbl_body.height=car_temp.height and
		tbl_cylinder.num_of_cylinders_id=tbl_cylinders.num_of_cylinders_id and
		tbl_cylinders.num_of_cylinders=car_temp.num_of_cylinders and
		tbl_cylinder.bore=car_temp.bore and
		tbl_cylinder.compression_ratio=car_temp.compression_ratio and
		tbl_make.make=car_temp.make and
		tbl_engine.engine_location_id=tbl_engine_location.engine_location_id and
		tbl_engine_location.engine_location=car_temp.engine_location and
		tbl_engine.engine_type_id=tbl_engine_type.engine_type_id and
		tbl_engine_type.engine_type=car_temp.engine_type and
		tbl_engine.aspiration_id=tbl_aspiration.aspiration_id and
		tbl_aspiration.aspiration=car_temp.aspiration and
		tbl_engine.drive_wheel_id=tbl_drive_wheel.drive_wheel_id and
		tbl_drive_wheel.drive_wheel=car_temp.drive_wheel and
		tbl_engine.stroke=car_temp.stroke and
		tbl_engine.horsepower=car_temp.horsepower and
		tbl_engine.peak_rpm=car_temp.peak_rpm and
		tbl_engine.wheel_base=car_temp.wheel_base and
		tbl_engine.city_mpg=car_temp.city_mpg and
		tbl_engine.highway_mpg=car_temp.highway_mpg and
		tbl_fuel.fuel_system_id=tbl_fuel_system.fuel_system_id and
		tbl_fuel_system.fuel_system=car_temp.fuel_system and
		tbl_fuel.fuel_type_id=tbl_fuel_type.fuel_type_id and
		tbl_fuel_type.fuel_type=car_temp.fuel_type;
--------------------
--------------------
alter table car_temp
	alter column body_style type bigint USING body_style::bigint,
	alter column num_of_cylinders type bigint USING num_of_cylinders::bigint,
	alter column make type bigint USING make::bigint,
	alter column engine_type type bigint USING engine_type::bigint,
	alter column fuel_type type bigint USING fuel_type::bigint;
------------
INSERT INTO tbl_car(
	body_id, 
	cylinder_id, 
	make_id, 
	engine_id, 
	fuel_id,
	symboling,
	normalized_losses,
	price,
	load_date,
	curb_weight) 
	SELECT distinct 
		body_style,
		num_of_cylinders,
		make,
		engine_type,
		fuel_type,
		symboling,
		normalized_losses,
		price,
		load_date,
		curb_weight FROM car_temp;
-----------------------------
DROP TABLE IF EXISTS car_temp;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
----------------
CREATE TRIGGER auto_insert_tbl_gcar
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert_car();
----
-----
DROP PROCEDURE IF EXISTS auto_insert;
-----
CREATE OR REPLACE FUNCTION auto_insert() 
	RETURNS trigger 
AS $$
BEGIN
INSERT INTO tbl_aspiration(aspiration) SELECT distinct aspiration FROM car;
INSERT INTO tbl_cylinders(num_of_cylinders) SELECT distinct num_of_cylinders FROM car;
INSERT INTO tbl_drive_wheel(drive_wheel) SELECT distinct drive_wheel FROM car;
INSERT INTO tbl_engine_location(engine_location) SELECT distinct engine_location FROM car;
INSERT INTO tbl_engine_type(engine_type) SELECT distinct engine_type FROM car;
INSERT INTO tbl_fuel_system(fuel_system) SELECT distinct fuel_system FROM car;
INSERT INTO tbl_make(make) SELECT distinct make FROM car;
INSERT INTO tbl_fuel_type(fuel_type) SELECT distinct fuel_type FROM car;
INSERT INTO tbl_body_style(body_style) SELECT distinct body_style FROM car;
INSERT INTO tbl_doors(num_of_doors) SELECT distinct num_of_doors FROM car;
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
----
-----------------
CREATE TRIGGER auto_insert
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE auto_insert();
---