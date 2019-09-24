
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS cities"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS geoplaces2"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS chefmoz"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS rating_final"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS users"




echo "Загружаем  cities.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE cities (
    city VARCHAR (255),
	population INTEGER,
	CONSTRAINT t_constraint UNIQUE (city)
 
  );'
  
 psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy cities FROM '/data/cities.csv' DELIMITER ';' CSV HEADER"
	
	
echo "Загружаем  geoplaces2.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE geoplaces2 (
    placeID	   INTEGER	,
	name	 VARCHAR (255)	,
	address	 VARCHAR (255)	,
	city	 VARCHAR (255)	,
	state_	 VARCHAR (255)	,
	alcohol	 VARCHAR (255)	,
	smoking_area	 VARCHAR (255)	,
	dress_code	 VARCHAR (255)	,
	price	 VARCHAR (255)	,
	area	 VARCHAR (255)	
 );'
  
 psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy geoplaces2 FROM '/data/geoplaces2.csv' DELIMITER ';' CSV HEADER"	

	
echo "Загружаем  chefmoz.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE chefmoz (
    placeID INTEGER,
	parking_lot VARCHAR (255),
	Restcuisine VARCHAR (255)
 
  );'
 psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy chefmoz FROM '/data/chefmoz.csv' DELIMITER ';' CSV HEADER"	
	
	
	
echo "Загружаем  rating_final.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE rating_final (
    userID  VARCHAR (255),
    placeID  INTEGER ,
	Rating  float(25),
	food_rating  float(25),
	service_rating  float(25)
	
  );'
 psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy rating_final FROM '/data/rating_final.csv' DELIMITER ',' CSV HEADER"		
	
	
	
	echo "Загружаем  user.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c ' 
 CREATE  TABLE  users (
     activity	  VARCHAR (255)	,
	 birth_year	  INTEGER	,
	 budget	      VARCHAR (255)	,
	 drink_level	  VARCHAR (255)	,
	 marital_status	 VARCHAR (255)	,
	 Rcuisine	   VARCHAR (255)	,
	 smoker	     boolean	,
	 transport	  VARCHAR (255)	,
	 Upayment	  VARCHAR (255)	,
	 userID  VARCHAR (255),
	 weight	  INTEGER		

 
  );'
  psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy users FROM '/data/users.csv' DELIMITER ';' CSV HEADER"		
	
