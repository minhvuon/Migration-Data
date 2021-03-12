drop function if exists remove_dup_all();
--------------
CREATE OR REPLACE FUNCTION remove_dup_all()
  RETURNS trigger AS
$$
BEGIN
 EXECUTE 'DELETE FROM ' ||TG_ARGV[0]||
 ' WHERE ' ||TG_ARGV[1]|| ' IN
    (SELECT ' ||TG_ARGV[1]||
    ' FROM 
        (SELECT ' ||TG_ARGV[1]|| ' ,
         ROW_NUMBER() OVER( PARTITION BY ' ||TG_ARGV[2]||
        ' ORDER BY '  ||TG_ARGV[1]|| ' ) AS row_num
        FROM ' ||TG_ARGV[0]|| ' ) t
        WHERE t.row_num > 1 ) ';
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
-----
-----------------
CREATE TRIGGER check_dup_tbl_make
  AFTER INSERT
  ON tbl_make
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_make', 'make_id', 'make');
----
-----
CREATE TRIGGER check_dup_tbl_body
  AFTER INSERT
  ON tbl_body
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_body', 'body_id', 'body_style_id, num_of_doors_id, length, width, height');
----
-----
CREATE TRIGGER check_dup_tbl_doors
  AFTER INSERT
  ON tbl_doors
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_doors', 'num_of_doors_id', 'num_of_doors');
----
-----
CREATE TRIGGER check_dup_tbl_aspiration
  AFTER INSERT
  ON tbl_aspiration
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_aspiration', 'aspiration_id', 'aspiration');
----
-----
CREATE TRIGGER check_dup_tbl_cylinders
  AFTER INSERT
  ON tbl_cylinders
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_cylinders', 'num_of_cylinders_id', 'num_of_cylinders');
----
-----
CREATE TRIGGER check_dup_tbl_drive_wheel
  AFTER INSERT
  ON tbl_drive_wheel
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_drive_wheel', 'drive_wheel_id', 'drive_wheel');
----
-----
CREATE TRIGGER check_dup_tbl_engine_location
  AFTER INSERT
  ON tbl_engine_location
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_engine_location', 'engine_location_id', 'engine_location');
----
-----
CREATE TRIGGER check_dup_tbl_engine_type
  AFTER INSERT
  ON tbl_engine_type
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_engine_type', 'engine_type_id', 'engine_type');
----
-----
CREATE TRIGGER check_dup_tbl_fuel_system
  AFTER INSERT
  ON tbl_fuel_system
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_fuel_system', 'fuel_system_id', 'fuel_system');
----
-----
CREATE TRIGGER check_dup_tbl_fuel_type
  AFTER INSERT
  ON tbl_fuel_type
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_fuel_type', 'fuel_type_id', 'fuel_type');
----
-----
CREATE TRIGGER check_dup_tbl_make
  AFTER INSERT
  ON tbl_make
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_make', 'make_id', 'make');
----
-----
CREATE TRIGGER check_dup_tbl_fuel
  AFTER INSERT
  ON tbl_fuel
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_fuel', 'fuel_id', 'fuel_system_id, fuel_type_id');
----
CREATE TRIGGER check_dup_tbl_cylinder
  AFTER INSERT
  ON tbl_cylinder
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_cylinder', 'cylinder_id', 'num_of_cylinders_id, bore, compression_ratio');
----
----
CREATE TRIGGER check_dup_tbl_car
  AFTER INSERT
  ON tbl_car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_car', 'car_id', 
								   'body_id, cylinder_id, make_id, engine_id, fuel_id, symboling, 
								   normalized_losses, price, load_date, curb_weight');
----
----
CREATE TRIGGER check_dup_tbl_engine
  AFTER INSERT
  ON tbl_engine
  FOR EACH STATEMENT
  EXECUTE PROCEDURE remove_dup_all('tbl_engine', 'engine_id', 
								   'engine_location_id, engine_type_id, drive_wheel_id, 
								   aspiration_id, engine_size, stroke, horsepower, peak_rpm, 
								   wheel_base, city_mpg, highway_mpg');
----
-------------