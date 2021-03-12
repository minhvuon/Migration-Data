# Migration-Data
Demo backend database intern

- Load data từ csv vào dataframe.
- Deployment BackEnd (BE)using flask-api

+ Check NA  "price" column 
+ Check length  "drive-wheels", if >5 then remove
+ Check "Height, Width, Length, Engine-size, Bore, Stroke, Price" datatype, if not interger then remove
+ Check duplicate
+ Rename column "Fuel-type" to "type", "Num-of-cylinders" to  "Num_cylinders"
+ Anonimize "dayUpdate" column to "1"
+ insert Validated data into SQL(native table) and save bad record to csv in local.
- Chuẩn hóa dữ liệu và create table trên sql(portgreSQL).
+ Write store procedure and auto trigger Validated data into created table when inserted  Validated data into native table