CREATE SEQUENCE public.id_seq
	INCREMENT 1
	MINVALUE 1
  	MAXVALUE 9223372036854775807
  	START 10000
  	CACHE 1;
ALTER TABLE public.id_seq
  	OWNER TO postgres;
-------
drop table tbl_fuel_type;
----
CREATE TABLE public.tbl_fuel_type
(
  	fuel_type_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	fuel_type VARCHAR(40),
  	CONSTRAINT pk_fuel_type_id PRIMARY KEY (fuel_type_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_fuel_type
  	OWNER TO postgres;
------
drop table make;
---
CREATE TABLE public.tbl_make
(
  	make_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	make VARCHAR(40),
  	CONSTRAINT pk_make_id PRIMARY KEY (make_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_make
  	OWNER TO postgres;
	
---
drop table engine_type;
---
CREATE TABLE public.tbl_engine_type
(
  	engine_type_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	engine_type VARCHAR(40),
  	CONSTRAINT pk_engine_type_id PRIMARY KEY (engine_type_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_engine_type
  	OWNER TO postgres;
----
drop table engine_location;
---
CREATE TABLE public.tbl_engine_location
(
  	engine_location_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	engine_location VARCHAR(40),
  	CONSTRAINT pk_engine_location_id PRIMARY KEY (engine_location_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_engine_location
  	OWNER TO postgres;
----
drop table drive_wheel;
---
CREATE TABLE public.tbl_drive_wheel
(
  	drive_wheel_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	drive_wheel VARCHAR(40),
  	CONSTRAINT pk_drive_wheel_id PRIMARY KEY (drive_wheel_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_drive_wheel
  	OWNER TO postgres;
----	
drop table doors;
---
CREATE TABLE public.tbl_doors
(
  	num_of_doors_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	num_of_doors VARCHAR(40),
  	CONSTRAINT pk_num_of_doors_id PRIMARY KEY (num_of_doors_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_doors
  	OWNER TO postgres;
----	
drop table cylinders;
---
CREATE TABLE public.tbl_cylinders
(
  	num_of_cylinders_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	num_of_cylinders integer,
  	CONSTRAINT pk_num_of_cylinders_id PRIMARY KEY (num_of_cylinders_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_cylinders
  	OWNER TO postgres;
----	
drop table body_style;
---
CREATE TABLE public.tbl_body_style
(
  	body_style_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	body_style varchar(40),
  	CONSTRAINT pk_body_style_id PRIMARY KEY (body_style_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_body_style
  	OWNER TO postgres;
----
drop table aspiration;
---
CREATE TABLE public.tbl_aspiration
(
  	aspiration_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	aspiration varchar(40),
  	CONSTRAINT pk_aspiration_id PRIMARY KEY (aspiration_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_aspiration
  	OWNER TO postgres;
----
CREATE TABLE public.tbl_fuel_system
(
  	fuel_system_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	fuel_system varchar(40),
  	CONSTRAINT pk_fuel_system_id PRIMARY KEY (fuel_system_id)
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_fuel_system
  	OWNER TO postgres;
----
CREATE TABLE public.tbl_fuel
(
  	fuel_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	fuel_system_id bigint NOT NULL,
	fuel_type_id bigint NOT NULL,
  	CONSTRAINT pk_fuel_id PRIMARY KEY (fuel_id),
	CONSTRAINT fk_fuel_system_id FOREIGN KEY (fuel_system_id)
		REFERENCES public.tbl_fuel_system (fuel_system_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_fuel_type_id FOREIGN KEY (fuel_type_id)
		REFERENCES public.tbl_fuel_type (fuel_type_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_fuel
  	OWNER TO postgres;
----
CREATE TABLE public.tbl_engine
(
  	engine_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	engine_location_id bigint NOT NULL,
	engine_type_id bigint NOT NULL,
	drive_wheel_id bigint NOT NULL,
	aspiration_id bigint NOT NULL,
	engine_size text,
	stroke float,
	horsepower integer,
	peak_rpm integer,
	wheel_base float,
	city_mpg integer,
	highway_mpg integer,
  	CONSTRAINT pk_engine_id PRIMARY KEY (engine_id),
	CONSTRAINT fk_engine_location_id FOREIGN KEY (engine_location_id)
		REFERENCES public.tbl_engine_location (engine_location_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_engine_type_id FOREIGN KEY (engine_type_id)
		REFERENCES public.tbl_engine_type (engine_type_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_drive_wheel_id FOREIGN KEY (drive_wheel_id)
		REFERENCES public.tbl_drive_wheel (drive_wheel_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_aspiration_id FOREIGN KEY (aspiration_id)
		REFERENCES public.tbl_aspiration (aspiration_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_engine
  	OWNER TO postgres;
----
ALTER TABLE tbl_engine ADD COLUMN wheel_base float;
------
CREATE TABLE public.tbl_body
(
  	body_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	body_style_id bigint NOT NULL,
	num_of_doors_id bigint NOT NULL,
	length float,
	width float,
	height float,
  	CONSTRAINT pk_body_id PRIMARY KEY (body_id),
	CONSTRAINT fk_body_style_id FOREIGN KEY (body_style_id)
		REFERENCES public.tbl_body_style (body_style_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_num_of_doors_id FOREIGN KEY (num_of_doors_id)
		REFERENCES public.tbl_doors (num_of_doors_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_body
  	OWNER TO postgres;
----
CREATE TABLE public.tbl_cylinder
(
  	cylinder_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	num_of_cylinders_id bigint NOT NULL,
	bore float,
	compression_ratio float,
  	CONSTRAINT pk_cylinder_id PRIMARY KEY (cylinder_id),
	CONSTRAINT fk_num_of_cylinders_id FOREIGN KEY (num_of_cylinders_id)
		REFERENCES public.tbl_cylinders (num_of_cylinders_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_cylinder
  	OWNER TO postgres;
----
----
CREATE TABLE public.tbl_car
(
  	car_id bigint NOT NULL DEFAULT nextval('id_seq'::regclass),
	body_id bigint NOT NULL,
	cylinder_id bigint NOT NULL,
	make_id bigint NOT NULL,
	engine_id bigint NOT NULL,
	fuel_id bigint NOT NULL,
	symboling integer,
	normalized_losses integer,
	price integer,
	load_date text,
	curb_weight integer,
  	CONSTRAINT pk_car_id PRIMARY KEY (car_id),
	CONSTRAINT fk_body_id FOREIGN KEY (body_id)
		REFERENCES public.tbl_body (body_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_cylinder_id FOREIGN KEY (cylinder_id)
		REFERENCES public.tbl_cylinder (cylinder_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_make_id FOREIGN KEY (make_id)
		REFERENCES public.tbl_make (make_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_engine_id FOREIGN KEY (engine_id)
		REFERENCES public.tbl_engine (engine_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_fuel_id FOREIGN KEY (fuel_id)
		REFERENCES public.tbl_fuel (fuel_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
 	OIDS=FALSE
);
ALTER TABLE public.tbl_car
  	OWNER TO postgres;
----
ALTER TABLE tbl_car ADD COLUMN curb_weight integer;
-----