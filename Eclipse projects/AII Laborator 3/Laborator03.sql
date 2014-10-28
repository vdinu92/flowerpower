CREATE DATABASE IF NOT EXISTS bookstore;

USE bookstore;

CREATE TABLE IF NOT EXISTS publishing_house (
	id                INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	name              VARCHAR(50) NOT NULL,
	registered_number INT(10) NOT NULL,			
	description       VARCHAR(1000),
	town              VARCHAR(50) NOT NULL,
	region            VARCHAR(50) NOT NULL,
	country           VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS series (
	id          INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	name        VARCHAR(100) NOT NULL,
	description VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS genre (
	id          INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	name        VARCHAR(50) NOT NULL,
	description VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS book (
	id                  INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	title               VARCHAR(50) NOT NULL,
	description         VARCHAR(1000),
	publishing_house_id INT(10) UNSIGNED NOT NULL,
	printing_year       INT(4) NOT NULL,
	edition             INT(2) NOT NULL,
	series_id           INT(10) UNSIGNED NOT NULL,
	genre_id            INT(10) UNSIGNED NOT NULL,
	stockpile           INT(4) UNSIGNED NOT NULL,
	price               FLOAT(6,2) UNSIGNED NOT NULL,
	FOREIGN KEY (publishing_house_id) REFERENCES publishing_house(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (series_id) REFERENCES series(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES genre(id) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE book ADD CONSTRAINT book_ck_edition_should_be_positive CHECK (edition>0);
ALTER TABLE book ADD CONSTRAINT book_ck_stockpile_should_be_positive CHECK (stockpile>=0);
ALTER TABLE book ADD CONSTRAINT book_ck_price_should_be_positive CHECK (price>0);

CREATE TABLE IF NOT EXISTS writer (
	id         INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name  VARCHAR(50) NOT NULL,
	biography  VARCHAR(1000) NOT NULL
);

CREATE TABLE IF NOT EXISTS author (
	id        INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	book_id   INT(10) UNSIGNED NOT NULL,
	writer_id INT(10) UNSIGNED NOT NULL,
	FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (writer_id) REFERENCES writer(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS supply_order (
	id                    INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	identification_number VARCHAR(20) NOT NULL,
	issue_date            DATETIME NOT NULL,
	state                 VARCHAR(30) NOT NULL DEFAULT 'sent',
	publishing_house_id   INT(10) UNSIGNED,
	FOREIGN KEY (publishing_house_id) REFERENCES publishing_house(id) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE supply_order ADD CONSTRAINT supply_order_ck_state_possible_values CHECK (state in ('sent', 'delivered'));

CREATE TABLE IF NOT EXISTS supply_order_detail (
	id              INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	supply_order_id INT(10) UNSIGNED NOT NULL,
	book_id         INT(10) UNSIGNED NOT NULL,
	quantity        INT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (supply_order_id) REFERENCES supply_order(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE supply_order_detail ADD CONSTRAINT supply_order_detail_ck_quantity_should_be_positive CHECK(quantity>0);

CREATE TABLE IF NOT EXISTS user (
	personal_identifier BIGINT(13) UNSIGNED PRIMARY KEY NOT NULL,
	first_name          VARCHAR(50) NOT NULL,
	last_name           VARCHAR(50) NOT NULL,
	address             VARCHAR(100) NOT NULL,
	phone_number        INT(10),
	email               VARCHAR(60) NOT NULL,
	type                VARCHAR(30) NOT NULL DEFAULT 'client',
	role                VARCHAR(30) NOT NULL DEFAULT 'registered client',
	username            VARCHAR(30) NOT NULL,
	password            VARCHAR(30) NOT NULL
);
ALTER TABLE user ADD CONSTRAINT user_ck_type_possible_values CHECK (type in ('administrator', 'client'));
ALTER TABLE user ADD CONSTRAINT user_ck_role_possible_values CHECK (role in ('super-administrator', 'regular administrator', 'registered client', 'verified client'));

CREATE TABLE IF NOT EXISTS invoice (
	id                       INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	identification_number    VARCHAR(20) NOT NULL,
	issue_date               DATETIME NOT NULL,
	state                    VARCHAR(10) NOT NULL DEFAULT 'issued', 
	user_personal_identifier BIGINT(13) UNSIGNED NOT NULL,
	FOREIGN KEY (user_personal_identifier) REFERENCES user(personal_identifier) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE invoice ADD CONSTRAINT invoice_ck_state_possible_values CHECK (state in ('issued', 'paid'));

CREATE TABLE IF NOT EXISTS invoice_detail (
	id         INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	invoice_id INT(10) UNSIGNED NOT NULL,
	book_id    INT(10) UNSIGNED NOT NULL,
	quantity   INT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE invoice_detail ADD CONSTRAINT invoice_detail_ck_quantity_should_be_positive CHECK (quantity>0);

INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('China Education and Media Group', '992644992', '-', 'Helsinki', 'Uusimaa', 'Finland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Abril Educacao', '941100617', '-', 'Moscow', 'Moscow', 'Russian Federation');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Shueisha', '964228502', '-', 'Oslo', 'Eastern Norway', 'Norway');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('China Education and Media Group', '724994107', '-', 'Helsinki', 'Uusimaa', 'Finland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Egmont Group', '188626313', '-', 'Brussels', 'Brussels - Capital Region', 'Belgium');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Shueisha', '393696909', '-', 'Madrid', 'Community of Madrid', 'Spain');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Scholastic', '499042727', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Media Participations', '180408019', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Readers\' Digest', '716761979', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Abril Educacao', '501082211', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Reed Elsevier', '664561179', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('De Agostini Editore', '709654551', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('McGraw-Hill', '567543177', '-', 'Helsinki', 'Uusimaa', 'Finland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('China Education and Media Group', '732792746', '-', 'Rome', 'Lazio', 'Italy');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Harlequin', '306574334', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('HarperCollins', '664555212', '-', 'Paris', 'Ile-de-France', 'France');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('RCS Libri', '188945412', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Planeta', '279657516', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cornelsen', '138953890', '-', 'London', 'Greater London', 'United Kingdom');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Lefebre Sarrut', '748719315', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Kondansha', '414851955', '-', 'Brasilia', 'Federal District', 'Brazil');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Santillana', '278263362', '-', 'Warsaw', 'Masovian Voivodeship', 'Poland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Informa', '147661178', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Egmont Group', '547835361', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Gakken', '318776031', '-', 'Warsaw', 'Masovian Voivodeship', 'Poland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Springer Science and Business Media', '236238764', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Planeta', '876703438', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Egmont Group', '592922341', '-', 'Brasilia', 'Federal District', 'Brazil');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cengage Learning', '152570879', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Pearson', '213666485', '-', 'London', 'Greater London', 'United Kingdom');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Wolters Kluwer', '717919827', '-', 'Rome', 'Lazio', 'Italy');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Wiley', '177877566', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Gakken', '948001314', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('De Agostini Editore', '700959918', '-', 'Madrid', 'Community of Madrid', 'Spain');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Santillana', '127672718', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Egmont Group', '361680009', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Houghton Mifflin Harcourt', '934288859', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Harlequin', '612152849', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Klett', '267574508', '-', 'Copenhagen', 'Capital Region of Denmark', 'Denmark');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('De Agostini Editore', '150383886', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Gakken', '785937073', '-', 'Brussels', 'Brussels - Capital Region', 'Belgium');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Springer Science and Business Media', '589117694', '-', 'Tokyo', 'Tokyo-to', 'Japan');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Pearson', '705073256', '-', 'Warsaw', 'Masovian Voivodeship', 'Poland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Houghton Mifflin Harcourt', '946144808', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('De Agostini Editore', '616910695', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Wolters Kluwer', '155380174', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cornelsen', '982122538', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Klett', '598858095', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Hachette Livre', '925486964', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Harlequin', '510636670', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Holtzbrinck', '648394978', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Holtzbrinck', '638390708', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Shogakukan', '758778219', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cengage Learning', '267507761', '-', 'Brussels', 'Brussels - Capital Region', 'Belgium');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cengage Learning', '552967481', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Harlequin', '428654980', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Reed Elsevier', '807380418', '-', 'Moscow', 'Moscow', 'Russian Federation');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cengage Learning', '309633260', '-', 'Moscow', 'Moscow', 'Russian Federation');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Holtzbrinck', '487269798', '-', 'Brussels', 'Brussels - Capital Region', 'Belgium');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Simon & Schuster', '497706465', '-', 'Paris', 'Ile-de-France', 'France');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Holtzbrinck', '729984745', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cornelsen', '156176461', '-', 'Beijing', 'Beijing', 'Peoples\' Republic of China');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Oxford University Press', '624574548', '-', 'Brussels', 'Brussels - Capital Region', 'Belgium');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Cengage Learning', '442603075', '-', 'Oslo', 'Eastern Norway', 'Norway');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Informa', '893423226', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('GeMS - Gruppo editoriale Mauri Spagnol', '141474516', '-', 'Copenhagen', 'Capital Region of Denmark', 'Denmark');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('RCS Libri', '690634171', '-', 'Moscow', 'Moscow', 'Russian Federation');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Bonnier', '733120926', '-', 'Helsinki', 'Uusimaa', 'Finland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Oxford University Press', '118151850', '-', 'Tokyo', 'Tokyo-to', 'Japan');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('China Education and Media Group', '248597640', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Pearson', '566146509', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Abril Educacao', '809389298', '-', 'Copenhagen', 'Capital Region of Denmark', 'Denmark');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Lefebre Sarrut', '209906644', '-', 'Paris', 'Ile-de-France', 'France');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Springer Science and Business Media', '529213506', '-', 'Oslo', 'Eastern Norway', 'Norway');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Readers\' Digest', '563474423', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Houghton Mifflin Harcourt', '844720035', '-', 'Beijing', 'Beijing', 'Peoples\' Republic of China');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Pearson', '558022287', '-', 'Brasilia', 'Federal District', 'Brazil');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('GeMS - Gruppo editoriale Mauri Spagnol', '412887579', '-', 'Copenhagen', 'Capital Region of Denmark', 'Denmark');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Kadokawa Publishing', '976085573', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('McGraw-Hill', '498607531', '-', 'Brasilia', 'Federal District', 'Brazil');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Planeta', '256768227', '-', 'Stockholm', 'Stockholm', 'Sweden');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Kondansha', '646548693', '-', 'Ottawa', 'Ontario', 'Canada');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Harlequin', '188710993', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Wolters Kluwer', '725763057', '-', 'Moscow', 'Moscow', 'Russian Federation');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Klett', '717504932', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Random House', '762059294', '-', 'Oslo', 'Eastern Norway', 'Norway');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Sanoma', '716886413', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Planeta', '398919843', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Shogakukan', '188674441', '-', 'Brasilia', 'Federal District', 'Brazil');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Pearson', '397619229', '-', 'Washington, D. C.', 'Washington, D. C.', 'United States of America');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Reed Elsevier', '231419527', '-', 'Amsterdam', 'North Holland', 'Netherlands');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Santillana', '791402275', '-', 'Seoul', 'Seoul Special City', 'Korea');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Hachette Livre', '986174302', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Informa', '422063908', '-', 'London', 'Greater London', 'United Kingdom');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Oxford University Press', '745429768', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('RCS Libri', '992851566', '-', 'Beijing', 'Beijing', 'Peoples\' Republic of China');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Grupo Planeta', '892687559', '-', 'Rome', 'Lazio', 'Italy');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Reed Elsevier', '779513593', '-', 'Warsaw', 'Masovian Voivodeship', 'Poland');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('Kadokawa Publishing', '489139560', '-', 'Berlin', 'Berlin', 'Germany');
INSERT INTO publishing_house (name, registered_number, description, town, region, country)
 VALUES('China Education and Media Group', '476793591', '-', 'Vienna', 'Wien', 'Austria');
INSERT INTO series (name, description)
 VALUES ('Strong Heroine Series', '-');
INSERT INTO series (name, description)
 VALUES ('Best South Slavic Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Books That Surprised Me - Way Better Than I Thought They Would Be', '-');
INSERT INTO series (name, description)
 VALUES ('The Best Epic Fantasy', '-');
INSERT INTO series (name, description)
 VALUES ('Classic Picture Book Characters', '-');
INSERT INTO series (name, description)
 VALUES ('The 50 greatest British writers since 1945', '-');
INSERT INTO series (name, description)
 VALUES ('Best Authors Ever', '-');
INSERT INTO series (name, description)
 VALUES ('Best South Slavic Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Best German Children Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Best Sci-Fi/Fantasy Series', '-');
INSERT INTO series (name, description)
 VALUES ('Books for Middle-Schoolers', '-');
INSERT INTO series (name, description)
 VALUES ('Strong Heroine Series', '-');
INSERT INTO series (name, description)
 VALUES ('Best Books of the 19th Century', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('Best Psilosophical Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Best Spy Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Best Authors Ever', '-');
INSERT INTO series (name, description)
 VALUES ('Best Paranormal Romance Series', '-');
INSERT INTO series (name, description)
 VALUES ('Best Authors Ever', '-');
INSERT INTO series (name, description)
 VALUES ('American Literature at the Movies', '-');
INSERT INTO series (name, description)
 VALUES ('Best Series to Start', '-');
INSERT INTO series (name, description)
 VALUES ('Modern-day Classics', '-');
INSERT INTO series (name, description)
 VALUES ('The Must-Have Series for Children Ages 6 to 12', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('Best Books of the 19th Century', '-');
INSERT INTO series (name, description)
 VALUES ('Middle Earth', '-');
INSERT INTO series (name, description)
 VALUES ('Great Victorian Romance to Daydream About', '-');
INSERT INTO series (name, description)
 VALUES ('Best German Children Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Middle Earth', '-');
INSERT INTO series (name, description)
 VALUES ('Fictionalized Accounts of Real People', '-');
INSERT INTO series (name, description)
 VALUES ('The Best Epic Fantasy', '-');
INSERT INTO series (name, description)
 VALUES ('Most Difficult Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Books To Read Before You Die', '-');
INSERT INTO series (name, description)
 VALUES ('The Best Epic Fantasy', '-');
INSERT INTO series (name, description)
 VALUES ('American Literature at the Movies', '-');
INSERT INTO series (name, description)
 VALUES ('Middle Earth', '-');
INSERT INTO series (name, description)
 VALUES ('Great Underrated and Obscure Books', '-');
INSERT INTO series (name, description)
 VALUES ('Books That Surprised Me - Way Better Than I Thought They Would Be', '-');
INSERT INTO series (name, description)
 VALUES ('Modern-day Classics', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('Best Sci-Fi/Fantasy Series', '-');
INSERT INTO series (name, description)
 VALUES ('Classic Picture Book Characters', '-');
INSERT INTO series (name, description)
 VALUES ('Best Psilosophical Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Strong Heroine Series', '-');
INSERT INTO series (name, description)
 VALUES ('Most Difficult Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Best German Children Literature', '-');
INSERT INTO series (name, description)
 VALUES ('The Ultimate Reading List', '-');
INSERT INTO series (name, description)
 VALUES ('Great Mystery Seris of the 00\'s', '-');
INSERT INTO series (name, description)
 VALUES ('Classic Picture Book Characters', '-');
INSERT INTO series (name, description)
 VALUES ('Books for Middle-Schoolers', '-');
INSERT INTO series (name, description)
 VALUES ('Fictionalized Accounts of Real People', '-');
INSERT INTO series (name, description)
 VALUES ('Books for Middle-Schoolers', '-');
INSERT INTO series (name, description)
 VALUES ('Most Difficult Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('Books for Middle-Schoolers', '-');
INSERT INTO series (name, description)
 VALUES ('Great Victorian Romance to Daydream About', '-');
INSERT INTO series (name, description)
 VALUES ('Once Upon a Time Series', '-');
INSERT INTO series (name, description)
 VALUES ('Best Spy Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Contemporary Black Women\'s Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('I Don\'t Understand All That Fuss', '-');
INSERT INTO series (name, description)
 VALUES ('Mysteries in Good Taste', '-');
INSERT INTO series (name, description)
 VALUES ('Colonial and Post-colonial Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Stately Home Mysteries', '-');
INSERT INTO series (name, description)
 VALUES ('The 50 greatest British writers since 1945', '-');
INSERT INTO series (name, description)
 VALUES ('Middle Earth', '-');
INSERT INTO series (name, description)
 VALUES ('Middle Earth', '-');
INSERT INTO series (name, description)
 VALUES ('The 50 greatest British writers since 1945', '-');
INSERT INTO series (name, description)
 VALUES ('Best Sci-Fi/Fantasy Series', '-');
INSERT INTO series (name, description)
 VALUES ('Mysteries in Good Taste', '-');
INSERT INTO series (name, description)
 VALUES ('What to Read after Harry Potter', '-');
INSERT INTO series (name, description)
 VALUES ('20th Century Hungarian Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Best Series to Start', '-');
INSERT INTO series (name, description)
 VALUES ('Best Books To Lose Yourself In', '-');
INSERT INTO series (name, description)
 VALUES ('Strong Heroine Series', '-');
INSERT INTO series (name, description)
 VALUES ('Best Spy Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Best Paranormal Romance Series', '-');
INSERT INTO series (name, description)
 VALUES ('The Must-Have Series for Children Ages 6 to 12', '-');
INSERT INTO series (name, description)
 VALUES ('The Must-Have Series for Children Ages 6 to 12', '-');
INSERT INTO series (name, description)
 VALUES ('Modern-day Classics', '-');
INSERT INTO series (name, description)
 VALUES ('20th Century Hungarian Literature', '-');
INSERT INTO series (name, description)
 VALUES ('The 50 greatest British writers since 1945', '-');
INSERT INTO series (name, description)
 VALUES ('I Don\'t Understand All That Fuss', '-');
INSERT INTO series (name, description)
 VALUES ('Books To Read Before You Die', '-');
INSERT INTO series (name, description)
 VALUES ('Once Upon a Time Series', '-');
INSERT INTO series (name, description)
 VALUES ('Colonial and Post-colonial Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Fictionalized Accounts of Real People', '-');
INSERT INTO series (name, description)
 VALUES ('Best Spy Novels', '-');
INSERT INTO series (name, description)
 VALUES ('Gentle Fiction', '-');
INSERT INTO series (name, description)
 VALUES ('What to Read after Harry Potter', '-');
INSERT INTO series (name, description)
 VALUES ('What to Read after Harry Potter', '-');
INSERT INTO series (name, description)
 VALUES ('Fictionalized Accounts of Real People', '-');
INSERT INTO series (name, description)
 VALUES ('Books To Read Before You Die', '-');
INSERT INTO series (name, description)
 VALUES ('Best Psilosophical Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Books That Surprised Me - Way Better Than I Thought They Would Be', '-');
INSERT INTO series (name, description)
 VALUES ('Best Books To Lose Yourself In', '-');
INSERT INTO series (name, description)
 VALUES ('Colonial and Post-colonial Literature', '-');
INSERT INTO series (name, description)
 VALUES ('Literary Horror', '-');
INSERT INTO series (name, description)
 VALUES ('Conspiracy Fiction', '-');
INSERT INTO series (name, description)
 VALUES ('Great Victorian Romance to Daydream About', '-');
INSERT INTO genre (name, description)
 VALUES('biography', '-');
INSERT INTO genre (name, description)
 VALUES('romance', '-');
INSERT INTO genre (name, description)
 VALUES('classic', '-');
INSERT INTO genre (name, description)
 VALUES('adventure', '-');
INSERT INTO genre (name, description)
 VALUES('finance', '-');
INSERT INTO genre (name, description)
 VALUES('science', '-');
INSERT INTO genre (name, description)
 VALUES('satire', '-');
INSERT INTO genre (name, description)
 VALUES('romance', '-');
INSERT INTO genre (name, description)
 VALUES('philosophy', '-');
INSERT INTO genre (name, description)
 VALUES('horror', '-');
INSERT INTO genre (name, description)
 VALUES('drama', '-');
INSERT INTO genre (name, description)
 VALUES('biography', '-');
INSERT INTO genre (name, description)
 VALUES('house', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('monography', '-');
INSERT INTO genre (name, description)
 VALUES('comics', '-');
INSERT INTO genre (name, description)
 VALUES('satire', '-');
INSERT INTO genre (name, description)
 VALUES('anthology', '-');
INSERT INTO genre (name, description)
 VALUES('satire', '-');
INSERT INTO genre (name, description)
 VALUES('poetry', '-');
INSERT INTO genre (name, description)
 VALUES('fictional', '-');
INSERT INTO genre (name, description)
 VALUES('religious', '-');
INSERT INTO genre (name, description)
 VALUES('computing', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('house', '-');
INSERT INTO genre (name, description)
 VALUES('health', '-');
INSERT INTO genre (name, description)
 VALUES('sport', '-');
INSERT INTO genre (name, description)
 VALUES('philosophy', '-');
INSERT INTO genre (name, description)
 VALUES('health', '-');
INSERT INTO genre (name, description)
 VALUES('travel', '-');
INSERT INTO genre (name, description)
 VALUES('adventure', '-');
INSERT INTO genre (name, description)
 VALUES('music', '-');
INSERT INTO genre (name, description)
 VALUES('dictionary', '-');
INSERT INTO genre (name, description)
 VALUES('adventure', '-');
INSERT INTO genre (name, description)
 VALUES('poetry', '-');
INSERT INTO genre (name, description)
 VALUES('health', '-');
INSERT INTO genre (name, description)
 VALUES('politics', '-');
INSERT INTO genre (name, description)
 VALUES('classic', '-');
INSERT INTO genre (name, description)
 VALUES('religious', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('horror', '-');
INSERT INTO genre (name, description)
 VALUES('finance', '-');
INSERT INTO genre (name, description)
 VALUES('monography', '-');
INSERT INTO genre (name, description)
 VALUES('biography', '-');
INSERT INTO genre (name, description)
 VALUES('music', '-');
INSERT INTO genre (name, description)
 VALUES('philosophy', '-');
INSERT INTO genre (name, description)
 VALUES('economics', '-');
INSERT INTO genre (name, description)
 VALUES('encyclopedia', '-');
INSERT INTO genre (name, description)
 VALUES('finance', '-');
INSERT INTO genre (name, description)
 VALUES('drama', '-');
INSERT INTO genre (name, description)
 VALUES('travel', '-');
INSERT INTO genre (name, description)
 VALUES('drama', '-');
INSERT INTO genre (name, description)
 VALUES('music', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('drama', '-');
INSERT INTO genre (name, description)
 VALUES('sport', '-');
INSERT INTO genre (name, description)
 VALUES('children', '-');
INSERT INTO genre (name, description)
 VALUES('comics', '-');
INSERT INTO genre (name, description)
 VALUES('society', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('business', '-');
INSERT INTO genre (name, description)
 VALUES('diary', '-');
INSERT INTO genre (name, description)
 VALUES('thriller', '-');
INSERT INTO genre (name, description)
 VALUES('history', '-');
INSERT INTO genre (name, description)
 VALUES('science', '-');
INSERT INTO genre (name, description)
 VALUES('health', '-');
INSERT INTO genre (name, description)
 VALUES('health', '-');
INSERT INTO genre (name, description)
 VALUES('science', '-');
INSERT INTO genre (name, description)
 VALUES('horror', '-');
INSERT INTO genre (name, description)
 VALUES('diary', '-');
INSERT INTO genre (name, description)
 VALUES('art', '-');
INSERT INTO genre (name, description)
 VALUES('school', '-');
INSERT INTO genre (name, description)
 VALUES('fictional', '-');
INSERT INTO genre (name, description)
 VALUES('guide', '-');
INSERT INTO genre (name, description)
 VALUES('biography', '-');
INSERT INTO genre (name, description)
 VALUES('comics', '-');
INSERT INTO genre (name, description)
 VALUES('anthology', '-');
INSERT INTO genre (name, description)
 VALUES('computing', '-');
INSERT INTO genre (name, description)
 VALUES('computing', '-');
INSERT INTO genre (name, description)
 VALUES('religious', '-');
INSERT INTO genre (name, description)
 VALUES('school', '-');
INSERT INTO genre (name, description)
 VALUES('science', '-');
INSERT INTO genre (name, description)
 VALUES('business', '-');
INSERT INTO genre (name, description)
 VALUES('dictionary', '-');
INSERT INTO genre (name, description)
 VALUES('children', '-');
INSERT INTO genre (name, description)
 VALUES('thriller', '-');
INSERT INTO genre (name, description)
 VALUES('travel', '-');
INSERT INTO genre (name, description)
 VALUES('comics', '-');
INSERT INTO genre (name, description)
 VALUES('hobbies', '-');
INSERT INTO genre (name, description)
 VALUES('art', '-');
INSERT INTO genre (name, description)
 VALUES('art', '-');
INSERT INTO genre (name, description)
 VALUES('travel', '-');
INSERT INTO genre (name, description)
 VALUES('dictionary', '-');
INSERT INTO genre (name, description)
 VALUES('monography', '-');
INSERT INTO genre (name, description)
 VALUES('classic', '-');
INSERT INTO genre (name, description)
 VALUES('guide', '-');
INSERT INTO genre (name, description)
 VALUES('thriller', '-');
INSERT INTO genre (name, description)
 VALUES('mystery', '-');
INSERT INTO genre (name, description)
 VALUES('cookbook', '-');
INSERT INTO genre (name, description)
 VALUES('sport', '-');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Divine Comedy', '-', '93', '1973', '1', '18', '36', '433', '2823');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Great Expectations', '-', '3', '1908', '4', '24', '8', '225', '4765');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Lolita', '-', '22', '1917', '10', '97', '52', '727', '2704');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Pride and Prejudice', '-', '20', '1997', '9', '80', '60', '160', '5865');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Journey to the End of the Night', '-', '81', '1849', '10', '31', '66', '551', '1306');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('King Lear', '-', '78', '1965', '4', '47', '29', '453', '4994');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Bals Soprano', '-', '53', '1907', '3', '67', '68', '412', '1270');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Master and Margarita', '-', '47', '1822', '8', '45', '91', '918', '3268');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Madame Bovary', '-', '40', '2009', '6', '43', '71', '362', '7990');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Memories of Hadrian', '-', '79', '1905', '7', '62', '88', '727', '7920');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Sound and the Fury', '-', '76', '1846', '2', '50', '39', '479', '9955');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Old Man and the Sea', '-', '83', '1920', '10', '72', '86', '485', '577');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Magic Mountain', '-', '28', '1956', '8', '67', '4', '887', '6123');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Lolita', '-', '86', '1884', '7', '31', '19', '243', '433');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Things Fall Apart', '-', '10', '1826', '5', '60', '8', '613', '4079');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Divine Comedy', '-', '59', '1896', '5', '66', '87', '560', '4922');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Pride and Prejudice', '-', '62', '1915', '5', '70', '6', '256', '6897');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Sound and the Fury', '-', '9', '1905', '6', '96', '24', '558', '5722');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Catcher in the Rye', '-', '45', '1888', '1', '19', '96', '859', '3731');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Love in the Time of Cholera', '-', '40', '1975', '1', '72', '16', '978', '3486');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Madame Bovary', '-', '9', '1925', '3', '22', '20', '810', '206');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Journey to the End of the Night', '-', '62', '1990', '2', '18', '94', '58', '7849');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Middlemarch', '-', '90', '2008', '6', '83', '61', '115', '1323');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Things Fall Apart', '-', '2', '1928', '6', '7', '16', '745', '4798');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Crime and Punishment', '-', '62', '1911', '5', '49', '2', '762', '7339');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('King Lear', '-', '17', '1836', '1', '29', '17', '644', '8686');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('One Hundred Years of Solitude', '-', '76', '1867', '7', '66', '45', '850', '946');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Divine Comedy', '-', '41', '1802', '6', '10', '100', '760', '245');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Crime and Punishment', '-', '61', '1896', '7', '56', '56', '506', '3258');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Magic Mountain', '-', '24', '1895', '5', '36', '34', '385', '8103');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('King Lear', '-', '69', '2007', '5', '98', '74', '637', '9311');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Mrs Dalloway', '-', '32', '1900', '10', '28', '98', '619', '3363');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Brave New World', '-', '14', '1977', '1', '19', '58', '95', '2965');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Decameron', '-', '12', '1852', '5', '33', '71', '971', '8117');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Anna Karenina', '-', '30', '1837', '1', '53', '42', '662', '5331');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Castle', '-', '20', '1823', '8', '12', '11', '126', '1432');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Nineteen Eighty-Four', '-', '52', '1888', '1', '17', '9', '878', '8464');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Moby Dick', '-', '68', '1875', '7', '34', '30', '559', '5529');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Mrs Dalloway', '-', '94', '1938', '8', '61', '8', '843', '1284');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Name of the Rose', '-', '84', '1922', '8', '87', '64', '860', '4341');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Othello', '-', '31', '1877', '1', '63', '23', '721', '8241');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Anna Karenina', '-', '26', '1919', '5', '20', '53', '946', '3279');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Magic Mountain', '-', '86', '1887', '8', '82', '20', '486', '2620');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Lolita', '-', '73', '1859', '5', '57', '8', '291', '6269');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Order of Things', '-', '29', '1891', '2', '2', '62', '278', '7895');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Othello', '-', '47', '2007', '8', '66', '86', '942', '285');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Stranger', '-', '22', '1848', '10', '26', '15', '93', '7773');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Bals Soprano', '-', '31', '1912', '8', '25', '87', '886', '2034');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Bals Soprano', '-', '84', '1803', '2', '19', '81', '480', '5884');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Divine Comedy', '-', '11', '1918', '8', '26', '76', '976', '9999');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Gone with the Wind', '-', '17', '1857', '4', '67', '19', '59', '6100');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('King Lear', '-', '49', '1958', '5', '76', '93', '345', '945');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('One Hundred Years of Solitude', '-', '24', '1927', '1', '69', '20', '202', '2014');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Sound and the Fury', '-', '37', '1887', '9', '42', '20', '597', '1129');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Name of the Rose', '-', '16', '1921', '2', '18', '50', '515', '3168');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The War of the Worlds', '-', '40', '1995', '3', '55', '34', '200', '7476');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Catcher in the Rye', '-', '47', '1870', '3', '51', '87', '442', '4197');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Brothers Karamazov', '-', '90', '1873', '9', '67', '32', '607', '6547');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Memories of Hadrian', '-', '7', '1825', '6', '99', '11', '835', '7341');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Sound and the Fury', '-', '44', '1840', '4', '8', '99', '815', '3114');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('To the Lighthouse', '-', '27', '1890', '6', '20', '59', '139', '9540');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Order of Things', '-', '86', '1947', '6', '25', '30', '940', '4895');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Idiot', '-', '5', '1885', '8', '62', '30', '397', '1620');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Great Expectations', '-', '25', '2000', '5', '75', '26', '826', '9201');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Grapes of Wrath', '-', '40', '1867', '7', '33', '78', '272', '5288');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Nineteen Eighty-Four', '-', '92', '1890', '8', '99', '36', '975', '9861');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Lolita', '-', '95', '1989', '1', '2', '51', '191', '8868');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Nineteen Eighty-Four', '-', '62', '1881', '8', '54', '77', '501', '9434');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Stranger', '-', '60', '1856', '2', '90', '78', '199', '6171');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Castle', '-', '5', '1949', '3', '51', '84', '243', '7400');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Wuthering Heights', '-', '61', '1812', '9', '32', '62', '676', '9137');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('In Search of Lost Time', '-', '15', '1942', '8', '43', '7', '541', '4372');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Decameron', '-', '5', '1984', '9', '50', '90', '907', '1626');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Decameron', '-', '76', '1920', '6', '39', '53', '822', '9052');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Pride and Prejudice', '-', '90', '1915', '6', '12', '83', '16', '4606');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Stranger', '-', '94', '1825', '10', '67', '96', '572', '5602');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Death of Ivan Ilych', '-', '31', '1822', '4', '3', '42', '87', '3651');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Little Prince', '-', '94', '1870', '5', '68', '7', '163', '1617');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Sound and the Fury', '-', '75', '1929', '2', '6', '35', '95', '2379');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Dead Souls', '-', '33', '1871', '10', '2', '25', '71', '8243');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Sentimental Education', '-', '68', '1908', '5', '59', '34', '737', '5041');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Order of Things', '-', '75', '1807', '10', '58', '11', '669', '2425');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Magic Mountain', '-', '24', '1952', '1', '61', '13', '732', '8081');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Name of the Rose', '-', '100', '1813', '6', '39', '60', '754', '1517');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Master and Margarita', '-', '38', '1832', '2', '43', '46', '852', '5607');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Things Fall Apart', '-', '71', '1954', '3', '68', '91', '658', '6213');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Anna Karenina', '-', '16', '1815', '4', '83', '13', '37', '6787');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Magic Mountain', '-', '45', '1874', '1', '36', '86', '505', '6084');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Things Fall Apart', '-', '85', '1868', '8', '58', '91', '356', '912');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('King Lear', '-', '69', '1947', '10', '71', '93', '709', '3356');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Catcher in the Rye', '-', '36', '1936', '9', '94', '39', '125', '505');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Hound of the Baskervilles', '-', '18', '1815', '8', '95', '44', '665', '2614');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The War of the Worlds', '-', '35', '1970', '5', '70', '35', '141', '9510');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Othello', '-', '98', '1925', '8', '51', '15', '754', '6604');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Love in the Time of Cholera', '-', '36', '1950', '4', '23', '15', '752', '2501');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Lolita', '-', '3', '1814', '5', '25', '65', '20', '2361');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Madame Bovary', '-', '97', '1893', '3', '29', '68', '379', '1121');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('The Hound of the Baskervilles', '-', '85', '1994', '9', '64', '91', '556', '1775');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Journey to the End of the Night', '-', '19', '1867', '1', '57', '45', '130', '9759');
INSERT INTO book (title, description, publishing_house_id, printing_year, edition, series_id, genre_id, stockpile, price)
 VALUES('Anna Karenina', '-', '61', '2009', '1', '74', '73', '287', '5311');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Harper', 'LEE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Nikolai', 'GOGOL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Franz', 'KAFKA', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Ralph', 'ELLISON', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Herman', 'MELVILLE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Salman', 'RUSHDIE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Harper', 'LEE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Vladimir', 'NABOKOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Fyodor', 'DOSTOEVSKY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Vladimir', 'NABOKOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'FAULKNER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Henry', 'FIELDING', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Marguerite', 'YOURCENAR', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Charles', 'DICKENS', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gabriel', 'GARCIA MARQUEZ', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Dante', 'ALIGHIERI', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Ernest', 'HEMINGWAY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Leo', 'TOLSTOY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Ernest', 'HEMINGWAY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('George', 'ELLIOT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Margaret', 'MITCHELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('J. D.', 'SALINGER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('D. H.', 'LAWRENCE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Marguerite', 'YOURCENAR', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Marcel', 'PROUST', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Malcolm', 'LOWRY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gunter', 'GRASS', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'CONRAD', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('George', 'ELLIOT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Ralph', 'ELLISON', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Margaret', 'MITCHELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gustave', 'FLAUBERT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Laurence', 'STERNE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Nathaniel', 'HAWTHORNE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'CONRAD', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Laurence', 'STERNE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Franz', 'KAFKA', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('J. D.', 'SALINGER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Charles', 'DICKENS', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'FAULKNER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Salman', 'RUSHDIE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Ernest', 'HEMINGWAY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Margaret', 'MITCHELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Toni', 'MORRISON', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Jane', 'AUSTEN', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Anton', 'CHEKHOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Vladimir', 'NABOKOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Nathaniel', 'HAWTHORNE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'FAULKNER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Thomas', 'MANN', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Herman', 'MELVILLE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'FAULKNER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Geoffrey', 'CHAUCER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Margaret', 'MITCHELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Thomas', 'MANN', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Herman', 'MELVILLE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Richard', 'WRIGHT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Kurt', 'VONNEGUT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('George', 'ORWELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Antoine', 'de SAINT-EXUPERY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Franz', 'KAFKA', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Geoffrey', 'CHAUCER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'CONRAD', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Emily', 'BRONTE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Nikolai', 'GOGOL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'SHAKESPEARE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('William', 'FAULKNER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Anton', 'CHEKHOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Thomas', 'MANN', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Toni', 'MORRISON', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Marguerite', 'YOURCENAR', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Thomas', 'MANN', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gustave', 'FLAUBERT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Malcolm', 'LOWRY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('John', 'STEINBECK', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Richard', 'WRIGHT', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gabriel', 'GARCIA MARQUEZ', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('James', 'JOYCE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Leo', 'TOLSTOY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Nathaniel', 'HAWTHORNE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gunter', 'GRASS', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'CONRAD', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Louis-Ferdinand', 'CELINE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Mikhail', 'BULGAKOV', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Jorge Luis', 'BORGES', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Virginia', 'WOOLF', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'CONRAD', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Leo', 'TOLSTOY', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Salman', 'RUSHDIE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Salman', 'RUSHDIE', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Toni', 'MORRISON', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Gunter', 'GRASS', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Joseph', 'HELLER', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('George', 'ORWELL', '-');
INSERT INTO writer (first_name, last_name, biography)
 VALUES('Charles', 'DICKENS', '-');
INSERT INTO author (book_id, writer_id)
 VALUES('84', '93');
INSERT INTO author (book_id, writer_id)
 VALUES('66', '61');
INSERT INTO author (book_id, writer_id)
 VALUES('18', '36');
INSERT INTO author (book_id, writer_id)
 VALUES('34', '53');
INSERT INTO author (book_id, writer_id)
 VALUES('9', '3');
INSERT INTO author (book_id, writer_id)
 VALUES('13', '44');
INSERT INTO author (book_id, writer_id)
 VALUES('24', '8');
INSERT INTO author (book_id, writer_id)
 VALUES('26', '27');
INSERT INTO author (book_id, writer_id)
 VALUES('14', '22');
INSERT INTO author (book_id, writer_id)
 VALUES('14', '10');
INSERT INTO author (book_id, writer_id)
 VALUES('97', '52');
INSERT INTO author (book_id, writer_id)
 VALUES('28', '48');
INSERT INTO author (book_id, writer_id)
 VALUES('24', '20');
INSERT INTO author (book_id, writer_id)
 VALUES('38', '89');
INSERT INTO author (book_id, writer_id)
 VALUES('80', '60');
INSERT INTO author (book_id, writer_id)
 VALUES('61', '47');
INSERT INTO author (book_id, writer_id)
 VALUES('12', '81');
INSERT INTO author (book_id, writer_id)
 VALUES('50', '80');
INSERT INTO author (book_id, writer_id)
 VALUES('31', '66');
INSERT INTO author (book_id, writer_id)
 VALUES('52', '8');
INSERT INTO author (book_id, writer_id)
 VALUES('63', '78');
INSERT INTO author (book_id, writer_id)
 VALUES('86', '64');
INSERT INTO author (book_id, writer_id)
 VALUES('47', '29');
INSERT INTO author (book_id, writer_id)
 VALUES('54', '35');
INSERT INTO author (book_id, writer_id)
 VALUES('78', '53');
INSERT INTO author (book_id, writer_id)
 VALUES('100', '13');
INSERT INTO author (book_id, writer_id)
 VALUES('67', '68');
INSERT INTO author (book_id, writer_id)
 VALUES('13', '78');
INSERT INTO author (book_id, writer_id)
 VALUES('90', '47');
INSERT INTO author (book_id, writer_id)
 VALUES('17', '68');
INSERT INTO author (book_id, writer_id)
 VALUES('45', '91');
INSERT INTO author (book_id, writer_id)
 VALUES('19', '1');
INSERT INTO author (book_id, writer_id)
 VALUES('16', '40');
INSERT INTO author (book_id, writer_id)
 VALUES('80', '56');
INSERT INTO author (book_id, writer_id)
 VALUES('43', '71');
INSERT INTO author (book_id, writer_id)
 VALUES('63', '35');
INSERT INTO author (book_id, writer_id)
 VALUES('17', '79');
INSERT INTO author (book_id, writer_id)
 VALUES('24', '67');
INSERT INTO author (book_id, writer_id)
 VALUES('62', '88');
INSERT INTO author (book_id, writer_id)
 VALUES('28', '32');
INSERT INTO author (book_id, writer_id)
 VALUES('95', '76');
INSERT INTO author (book_id, writer_id)
 VALUES('65', '72');
INSERT INTO author (book_id, writer_id)
 VALUES('50', '39');
INSERT INTO author (book_id, writer_id)
 VALUES('80', '87');
INSERT INTO author (book_id, writer_id)
 VALUES('42', '83');
INSERT INTO author (book_id, writer_id)
 VALUES('23', '80');
INSERT INTO author (book_id, writer_id)
 VALUES('72', '86');
INSERT INTO author (book_id, writer_id)
 VALUES('86', '79');
INSERT INTO author (book_id, writer_id)
 VALUES('39', '28');
INSERT INTO author (book_id, writer_id)
 VALUES('69', '58');
INSERT INTO author (book_id, writer_id)
 VALUES('67', '4');
INSERT INTO author (book_id, writer_id)
 VALUES('88', '15');
INSERT INTO author (book_id, writer_id)
 VALUES('64', '86');
INSERT INTO author (book_id, writer_id)
 VALUES('19', '17');
INSERT INTO author (book_id, writer_id)
 VALUES('31', '19');
INSERT INTO author (book_id, writer_id)
 VALUES('44', '87');
INSERT INTO author (book_id, writer_id)
 VALUES('49', '10');
INSERT INTO author (book_id, writer_id)
 VALUES('1', '75');
INSERT INTO author (book_id, writer_id)
 VALUES('60', '8');
INSERT INTO author (book_id, writer_id)
 VALUES('14', '50');
INSERT INTO author (book_id, writer_id)
 VALUES('84', '59');
INSERT INTO author (book_id, writer_id)
 VALUES('9', '65');
INSERT INTO author (book_id, writer_id)
 VALUES('66', '87');
INSERT INTO author (book_id, writer_id)
 VALUES('61', '8');
INSERT INTO author (book_id, writer_id)
 VALUES('74', '62');
INSERT INTO author (book_id, writer_id)
 VALUES('56', '95');
INSERT INTO author (book_id, writer_id)
 VALUES('70', '6');
INSERT INTO author (book_id, writer_id)
 VALUES('57', '35');
INSERT INTO author (book_id, writer_id)
 VALUES('95', '9');
INSERT INTO author (book_id, writer_id)
 VALUES('28', '6');
INSERT INTO author (book_id, writer_id)
 VALUES('96', '24');
INSERT INTO author (book_id, writer_id)
 VALUES('59', '75');
INSERT INTO author (book_id, writer_id)
 VALUES('81', '45');
INSERT INTO author (book_id, writer_id)
 VALUES('39', '1');
INSERT INTO author (book_id, writer_id)
 VALUES('19', '96');
INSERT INTO author (book_id, writer_id)
 VALUES('60', '12');
INSERT INTO author (book_id, writer_id)
 VALUES('65', '40');
INSERT INTO author (book_id, writer_id)
 VALUES('54', '71');
INSERT INTO author (book_id, writer_id)
 VALUES('72', '16');
INSERT INTO author (book_id, writer_id)
 VALUES('79', '68');
INSERT INTO author (book_id, writer_id)
 VALUES('16', '9');
INSERT INTO author (book_id, writer_id)
 VALUES('58', '93');
INSERT INTO author (book_id, writer_id)
 VALUES('22', '20');
INSERT INTO author (book_id, writer_id)
 VALUES('11', '63');
INSERT INTO author (book_id, writer_id)
 VALUES('62', '62');
INSERT INTO author (book_id, writer_id)
 VALUES('23', '82');
INSERT INTO author (book_id, writer_id)
 VALUES('18', '94');
INSERT INTO author (book_id, writer_id)
 VALUES('59', '81');
INSERT INTO author (book_id, writer_id)
 VALUES('18', '90');
INSERT INTO author (book_id, writer_id)
 VALUES('19', '56');
INSERT INTO author (book_id, writer_id)
 VALUES('83', '61');
INSERT INTO author (book_id, writer_id)
 VALUES('16', '96');
INSERT INTO author (book_id, writer_id)
 VALUES('99', '2');
INSERT INTO author (book_id, writer_id)
 VALUES('55', '66');
INSERT INTO author (book_id, writer_id)
 VALUES('7', '16');
INSERT INTO author (book_id, writer_id)
 VALUES('46', '52');
INSERT INTO author (book_id, writer_id)
 VALUES('5', '62');
INSERT INTO author (book_id, writer_id)
 VALUES('54', '85');
INSERT INTO author (book_id, writer_id)
 VALUES('49', '2');
INSERT INTO author (book_id, writer_id)
 VALUES('63', '76');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('IRP420560', '2007-4-4', 'delivered', '9');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CMS713823', '1997-10-27', 'sent', '22');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('NJV814551', '1997-4-24', 'sent', '38');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('NEJ615160', '1996-8-22', 'sent', '80');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FPB581707', '1992-6-16', 'sent', '47');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('DDJ646377', '2002-8-17', 'sent', '68');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('MCO877846', '2006-8-22', 'sent', '19');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('APO774579', '2005-3-10', 'delivered', '35');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('QDX331166', '1991-4-28', 'delivered', '95');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('AOV581049', '2008-12-7', 'delivered', '83');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WEV447185', '1995-7-10', 'sent', '69');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HQD674887', '2004-12-11', 'delivered', '17');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FSS919486', '1998-6-1', 'delivered', '60');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HNY181983', '2008-5-22', 'delivered', '87');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('KHX891261', '2005-11-10', 'sent', '57');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('JTI919527', '1995-4-24', 'delivered', '75');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FTN110600', '2008-12-4', 'delivered', '65');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ODU200071', '2005-7-30', 'sent', '9');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HRV978219', '2000-11-2', 'delivered', '23');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GRS745058', '1990-2-26', 'sent', '56');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HKP554895', '2008-10-26', 'delivered', '7');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('PUB291004', '1991-6-25', 'delivered', '2');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('MAM236416', '1996-1-29', 'sent', '45');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RVA799921', '1996-10-7', 'sent', '30');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('IPK424065', '1999-12-17', 'sent', '5');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('KTV129355', '2005-3-2', 'sent', '24');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WJK220433', '1995-12-5', 'sent', '80');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('EWX566637', '1992-4-22', 'delivered', '50');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CWT348693', '1993-2-26', 'delivered', '19');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HUS204932', '2001-3-16', 'delivered', '71');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('VNB599129', '1993-11-23', 'sent', '63');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FET444189', '1997-12-23', 'delivered', '76');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('UBC804020', '2006-1-27', 'sent', '69');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RMQ892733', '1999-8-2', 'sent', '94');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('YCK658007', '1993-12-16', 'delivered', '21');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RLN494860', '1994-9-21', 'sent', '41');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('MWV860226', '1991-2-2', 'sent', '20');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CVV262288', '1995-8-16', 'sent', '20');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('LKN544872', '2009-5-15', 'sent', '92');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('YRD581657', '1991-6-22', 'delivered', '42');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WVH940137', '1995-6-3', 'sent', '46');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('VVO977925', '2004-2-3', 'sent', '31');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('PRY305086', '1996-6-18', 'delivered', '40');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('VSF193480', '1990-4-11', 'sent', '58');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('AAB632322', '1997-1-10', 'sent', '67');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('SJR749962', '1998-7-24', 'sent', '93');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ULV812923', '2005-3-14', 'sent', '3');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ATL926261', '1998-2-8', 'sent', '68');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('PPM663361', '2007-2-12', 'sent', '48');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OEW260254', '2003-1-4', 'sent', '47');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('TCA382286', '1992-9-19', 'delivered', '94');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('XQG773607', '1991-11-17', 'delivered', '76');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('XKK128508', '2004-8-23', 'delivered', '8');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('XPR467276', '1996-7-9', 'sent', '59');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OFR198185', '2009-4-15', 'sent', '41');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GLE244547', '2007-2-18', 'delivered', '89');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('IYE202294', '2004-2-23', 'sent', '35');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OBB893332', '2007-9-14', 'delivered', '92');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GHX527035', '2005-3-11', 'delivered', '100');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('UBA291191', '2000-5-25', 'sent', '88');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('DBB862382', '2005-4-17', 'delivered', '90');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CYN451429', '1994-12-3', 'delivered', '84');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('SFY503760', '2008-9-12', 'delivered', '77');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RKO190614', '2007-11-27', 'delivered', '91');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('HES834398', '1999-2-4', 'sent', '33');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('AKP494438', '2002-3-7', 'delivered', '90');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OKL346882', '2006-4-6', 'sent', '94');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OQU357572', '2008-8-2', 'sent', '44');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CQM484242', '1997-2-19', 'delivered', '68');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GNM663444', '2004-12-5', 'sent', '35');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('UVF993532', '2001-8-31', 'delivered', '72');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WYR899302', '2004-3-20', 'sent', '97');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RYL898919', '2007-3-8', 'delivered', '89');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('XQP789060', '2002-9-5', 'delivered', '100');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('SFN180459', '2004-2-10', 'delivered', '35');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GRU189852', '1997-11-1', 'sent', '43');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RPI106941', '1991-4-16', 'delivered', '83');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('MMI917738', '1994-3-28', 'sent', '86');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FMX288384', '2008-2-22', 'delivered', '57');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('GMS799851', '2009-3-25', 'delivered', '3');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('FKF651578', '2003-3-14', 'sent', '36');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('RKH659794', '1993-10-14', 'delivered', '35');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ETT961734', '1991-3-14', 'delivered', '6');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('CAO472754', '2003-5-17', 'sent', '84');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WOC832571', '1993-11-15', 'sent', '25');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OUD420715', '2006-12-1', 'delivered', '68');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ESK544284', '1998-11-24', 'sent', '57');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('WLS182045', '1990-1-2', 'sent', '30');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('BKA134170', '2003-5-16', 'delivered', '67');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('TLX660579', '2002-7-7', 'sent', '47');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('PYM561968', '1991-4-18', 'sent', '5');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('NIV288599', '2007-3-27', 'delivered', '32');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('MRL381398', '2003-4-9', 'sent', '75');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('LOE765037', '2009-1-5', 'sent', '11');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('ISG786167', '1996-2-28', 'sent', '88');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('NRH212250', '2006-3-17', 'sent', '18');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('QAS890275', '1995-7-5', 'sent', '99');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('IGJ535902', '2007-2-12', 'delivered', '22');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('JDK917836', '1996-2-23', 'delivered', '73');
INSERT INTO supply_order (identification_number, issue_date, state, publishing_house_id)
 VALUES('OAA210850', '2002-1-24', 'sent', '30');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('27', '1', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('47', '50', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('64', '69', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('43', '88', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('10', '88', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('44', '84', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('63', '43', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('90', '66', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('88', '12', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('78', '29', '9');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('89', '26', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('13', '39', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('56', '91', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('74', '93', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('69', '88', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('29', '71', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('2', '80', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('12', '82', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('97', '3', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('84', '56', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('37', '85', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('15', '95', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('61', '19', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('75', '85', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('44', '40', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('22', '88', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('28', '18', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('92', '25', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('65', '62', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('100', '98', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('72', '88', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('75', '7', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('59', '76', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('48', '7', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('96', '50', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('58', '89', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('25', '97', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('74', '98', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('28', '23', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('69', '78', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('79', '69', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('97', '92', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('64', '59', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('4', '76', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('18', '22', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('5', '95', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('82', '81', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('52', '19', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('25', '4', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('45', '93', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('42', '15', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('90', '82', '9');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('91', '7', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('55', '18', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('97', '100', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('13', '46', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('73', '84', '9');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('49', '87', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('33', '38', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('37', '62', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('15', '24', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('77', '83', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('12', '62', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('100', '73', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('42', '63', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('43', '75', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('73', '97', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('49', '83', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('45', '33', '9');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('27', '93', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('68', '9', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('92', '48', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('21', '40', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('70', '18', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('10', '69', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('62', '26', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('40', '66', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('30', '29', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('28', '74', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('63', '44', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('70', '45', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('91', '42', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('14', '56', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('41', '34', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('87', '16', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('16', '28', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('8', '93', '6');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('36', '29', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('65', '56', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('7', '39', '5');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('92', '5', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('11', '72', '3');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('82', '66', '7');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('85', '1', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('95', '62', '10');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('34', '80', '4');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('83', '81', '1');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('47', '79', '8');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('74', '10', '2');
INSERT INTO supply_order_detail (supply_order_id, book_id, quantity)
 VALUES('36', '98', '6');

INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1920611600617', 'Sophia', 'THOMPSON', '-', '0', 'sophia.thompson@bigstring.com', 'registered client', 'client', 'sophia.thompson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2431210382225', 'Dorothy', 'THOMPSON', '-', '0', 'dorothy.thompson@live.com', 'verified client', 'client', 'dorothy.thompson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1510809194223', 'John', 'WILSON', '-', '0', 'john.wilson@in.com', 'regular administrator', 'administrator', 'john.wilson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2460822361349', 'John', 'SMITH', '-', '0', 'john.smith@myspace.com', 'super-administrator', 'administrator', 'john.smith', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1771002192746', 'Olivia', 'HERNANDEZ', '-', '0', 'olivia.hernandez@myrealbox.com', 'verified client', 'client', 'olivia.hernandez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2121108845412', 'Thomas', 'GONZALES', '-', '0', 'thomas.gonzales@zapak.com', 'super-administrator', 'administrator', 'thomas.gonzales', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1900719819315', 'John', 'LEE', '-', '0', 'john.lee@myway.com', 'registered client', 'client', 'john.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2340514934523', 'Dorothy', 'ALLEN', '-', '0', 'dorothy.allen@gmx.com', 'regular administrator', 'administrator', 'dorothy.allen', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2750513581049', 'Tyler', 'YOUNG', '-', '0', 'tyler.young@zapak.com', 'verified client', 'client', 'tyler.young', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2790426366485', 'Jessica', 'WRIGHT', '-', '0', 'jessica.wright@gmx.com', 'regular administrator', 'administrator', 'jessica.wright', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1030415519063', 'Daniel', 'WRIGHT', '-', '0', 'daniel.wright@fastmail.com', 'super-administrator', 'administrator', 'daniel.wright', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2860522314500', 'Isabella', 'LEE', '-', '0', 'isabella.lee@gmx.com', 'regular administrator', 'administrator', 'isabella.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2580522781965', 'Dorothy', 'ADAMS', '-', '0', 'dorothy.adams@gmx.com', 'regular administrator', 'administrator', 'dorothy.adams', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2941016373256', 'Isabella', 'HILL', '-', '0', 'isabella.hill@in.com', 'verified client', 'client', 'isabella.hill', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1230310422080', 'David', 'KING', '-', '0', 'david.king@google.com', 'super-administrator', 'administrator', 'david.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2110504453053', 'Rachel', 'TAYLOR', '-', '0', 'rachel.taylor@myway.com', 'super-administrator', 'administrator', 'rachel.taylor', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1080623235821', 'John', 'GREEN', '-', '0', 'john.green@yahoo.com', 'regular administrator', 'administrator', 'john.green', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2810614745058', 'Joseph', 'WILSON', '-', '0', 'joseph.wilson@fanbox.com', 'regular administrator', 'administrator', 'joseph.wilson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1600406369798', 'Barbara', 'WALKER', '-', '0', 'barbara.walker@myspace.com', 'regular administrator', 'administrator', 'barbara.walker', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1510129938853', 'Margaret', 'RODRIGUEZ', '-', '0', 'margaret.rodriguez@live.com', 'super-administrator', 'administrator', 'margaret.rodriguez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2160302236528', 'Susan', 'BROWN', '-', '0', 'susan.brown@gmx.com', 'super-administrator', 'administrator', 'susan.brown', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2261007251850', 'Esther', 'BAKER', '-', '0', 'esther.baker@google.com', 'verified client', 'client', 'esther.baker', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2990124743604', 'Joseph', 'BROWN', '-', '0', 'joseph.brown@zapak.com', 'verified client', 'client', 'joseph.brown', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1120127453147', 'Isabella', 'WHITE', '-', '0', 'isabella.white@mail.com', 'verified client', 'client', 'isabella.white', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1681217744897', 'Helen', 'WILSON', '-', '0', 'helen.wilson@yahoo.com', 'verified client', 'client', 'helen.wilson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2491225240619', 'Helen', 'BAKER', '-', '0', 'helen.baker@mail.com', 'regular administrator', 'administrator', 'helen.baker', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1570808204932', 'Filip', 'NELSON', '-', '0', 'filip.nelson@myrealbox.com', 'registered client', 'client', 'filip.nelson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2130821219843', 'Ethan', 'THOMAS', '-', '0', 'ethan.thomas@live.com', 'verified client', 'client', 'ethan.thomas', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2190628438111', 'Ethan', 'CLARK', '-', '0', 'ethan.clark@myway.com', 'registered client', 'client', 'ethan.clark', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1200511948878', 'Margaret', 'GARCIA', '-', '0', 'margaret.garcia@gmx.com', 'verified client', 'client', 'margaret.garcia', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2290802541669', 'Samuel', 'HILL', '-', '0', 'samuel.hill@email.com', 'registered client', 'client', 'samuel.hill', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2910113989120', 'Thomas', 'CLARK', '-', '0', 'thomas.clark@aol.com', 'registered client', 'client', 'thomas.clark', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1300824767862', 'Benjamin', 'ALLEN', '-', '0', 'benjamin.allen@zapak.com', 'verified client', 'client', 'benjamin.allen', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1641208422946', 'Laura', 'GARCIA', '-', '0', 'laura.garcia@myspace.com', 'super-administrator', 'administrator', 'laura.garcia', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1191116996663', 'Robert', 'LEE', '-', '0', 'robert.lee@aim.com', 'super-administrator', 'administrator', 'robert.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2490730581657', 'Laura', 'LOPEZ', '-', '0', 'laura.lopez@live.com', 'verified client', 'client', 'laura.lopez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1460618574665', 'Daniel', 'MARTIN', '-', '0', 'daniel.martin@myway.com', 'super-administrator', 'administrator', 'daniel.martin', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2890615731093', 'Benjamin', 'ROBINSON', '-', '0', 'benjamin.robinson@inbox.com', 'super-administrator', 'administrator', 'benjamin.robinson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2861118663627', 'Lucas', 'YOUNG', '-', '0', 'lucas.young@live.com', 'super-administrator', 'administrator', 'lucas.young', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1200411468662', 'Thomas', 'CARTER', '-', '0', 'thomas.carter@myway.com', 'super-administrator', 'administrator', 'thomas.carter', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1160624372266', 'Tyler', 'LEE', '-', '0', 'tyler.lee@gmx.com', 'regular administrator', 'administrator', 'tyler.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1940812884345', 'Laura', 'HALL', '-', '0', 'laura.hall@aol.com', 'registered client', 'client', 'laura.hall', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1190324103044', 'Susan', 'LOPEZ', '-', '0', 'susan.lopez@in.com', 'super-administrator', 'administrator', 'susan.lopez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1671106559937', 'Barbara', 'JONES', '-', '0', 'barbara.jones@fanbox.com', 'registered client', 'client', 'barbara.jones', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1391219260254', 'Samuel', 'ADAMS', '-', '0', 'samuel.adams@bigstring.com', 'super-administrator', 'administrator', 'samuel.adams', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2021117573442', 'Robert', 'KING', '-', '0', 'robert.king@fanbox.com', 'verified client', 'client', 'robert.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2311218699866', 'Mason', 'HERNANDEZ', '-', '0', 'mason.hernandez@myway.com', 'verified client', 'client', 'mason.hernandez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2080307896072', 'Lucas', 'DAVIS', '-', '0', 'lucas.davis@hotmail.com', 'super-administrator', 'administrator', 'lucas.davis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2260709899419', 'Tyler', 'LEE', '-', '0', 'tyler.lee@google.com', 'super-administrator', 'administrator', 'tyler.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2750930599940', 'Laura', 'JOHNSON', '-', '0', 'laura.johnson@aim.com', 'verified client', 'client', 'laura.johnson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2290217357108', 'David', 'BROWN', '-', '0', 'david.brown@myrealbox.com', 'verified client', 'client', 'david.brown', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2560719833751', 'Dorothy', 'HARRIS', '-', '0', 'dorothy.harris@email.com', 'verified client', 'client', 'dorothy.harris', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2910730541098', 'Sophia', 'JACKSON', '-', '0', 'sophia.jackson@zapak.com', 'regular administrator', 'administrator', 'sophia.jackson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2700621291191', 'Ethan', 'LEWIS', '-', '0', 'ethan.lewis@live.com', 'super-administrator', 'administrator', 'ethan.lewis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1761002909995', 'William', 'JOHNSON', '-', '0', 'william.johnson@lavabit.com', 'super-administrator', 'administrator', 'william.johnson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1381001200223', 'Benjamin', 'GREEN', '-', '0', 'benjamin.green@aol.com', 'verified client', 'client', 'benjamin.green', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2601109679431', 'Laura', 'WILLIAMS', '-', '0', 'laura.williams@gmx.com', 'regular administrator', 'administrator', 'laura.williams', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2371127699541', 'Rachel', 'THOMAS', '-', '0', 'rachel.thomas@aim.com', 'regular administrator', 'administrator', 'rachel.thomas', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1891202651532', 'Sophia', 'GREEN', '-', '0', 'sophia.green@myway.com', 'registered client', 'client', 'sophia.green', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2690610869139', 'Daniel', 'HALL', '-', '0', 'daniel.hall@yahoo.com', 'verified client', 'client', 'daniel.hall', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2931005840766', 'Jack', 'HARRIS', '-', '0', 'jack.harris@hotmail.com', 'verified client', 'client', 'jack.harris', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1430313632087', 'Benjamin', 'DAVIS', '-', '0', 'benjamin.davis@mail.com', 'regular administrator', 'administrator', 'benjamin.davis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2061231663444', 'Sarah', 'LEE', '-', '0', 'sarah.lee@lavabit.com', 'super-administrator', 'administrator', 'sarah.lee', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2960613776551', 'William', 'LOPEZ', '-', '0', 'william.lopez@aim.com', 'regular administrator', 'administrator', 'william.lopez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1670720163758', 'Samuel', 'JONES', '-', '0', 'samuel.jones@fastmail.com', 'regular administrator', 'administrator', 'samuel.jones', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2191021116669', 'Robert', 'GARCIA', '-', '0', 'robert.garcia@aol.com', 'verified client', 'client', 'robert.garcia', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2120905123090', 'William', 'THOMPSON', '-', '0', 'william.thompson@myway.com', 'regular administrator', 'administrator', 'william.thompson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1810628366034', 'Richard', 'MARTIN', '-', '0', 'richard.martin@myspace.com', 'verified client', 'client', 'richard.martin', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2700722395367', 'Ethan', 'KING', '-', '0', 'ethan.king@live.com', 'regular administrator', 'administrator', 'ethan.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2331113644037', 'Lucas', 'KING', '-', '0', 'lucas.king@aim.com', 'registered client', 'client', 'lucas.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1850228641098', 'Margaret', 'KING', '-', '0', 'margaret.king@email.com', 'verified client', 'client', 'margaret.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1060716799851', 'William', 'SMITH', '-', '0', 'william.smith@bigstring.com', 'registered client', 'client', 'william.smith', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2350711750893', 'Tyler', 'CARTER', '-', '0', 'tyler.carter@google.com', 'verified client', 'client', 'tyler.carter', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2070715143665', 'Daniel', 'DAVIS', '-', '0', 'daniel.davis@myrealbox.com', 'regular administrator', 'administrator', 'daniel.davis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2340219477422', 'Thomas', 'CARTER', '-', '0', 'thomas.carter@gmx.com', 'super-administrator', 'administrator', 'thomas.carter', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1130517575628', 'Charles', 'ANDERSON', '-', '0', 'charles.anderson@myrealbox.com', 'verified client', 'client', 'charles.anderson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2020915473524', 'Margaret', 'LEWIS', '-', '0', 'margaret.lewis@hotmail.com', 'registered client', 'client', 'margaret.lewis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1520928493379', 'Jessica', 'WHITE', '-', '0', 'jessica.white@aim.com', 'verified client', 'client', 'jessica.white', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1900508897861', 'Tyler', 'CARTER', '-', '0', 'tyler.carter@google.com', 'regular administrator', 'administrator', 'tyler.carter', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1290621115475', 'Ethan', 'HERNANDEZ', '-', '0', 'ethan.hernandez@bigstring.com', 'regular administrator', 'administrator', 'ethan.hernandez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1690115660579', 'Robert', 'KING', '-', '0', 'robert.king@gmx.com', 'super-administrator', 'administrator', 'robert.king', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2240201905281', 'Sophia', 'ROBINSON', '-', '0', 'sophia.robinson@email.com', 'regular administrator', 'administrator', 'sophia.robinson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1210806549222', 'Lucas', 'MARTINEZ', '-', '0', 'lucas.martinez@lavabit.com', 'super-administrator', 'administrator', 'lucas.martinez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2980622989118', 'John', 'HILL', '-', '0', 'john.hill@live.com', 'regular administrator', 'administrator', 'john.hill', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2990105924755', 'Rachel', 'RODRIGUEZ', '-', '0', 'rachel.rodriguez@hotmail.com', 'registered client', 'client', 'rachel.rodriguez', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1730428911187', 'Olivia', 'JONES', '-', '0', 'olivia.jones@gmx.com', 'super-administrator', 'administrator', 'olivia.jones', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2820328860091', 'Jack', 'GARCIA', '-', '0', 'jack.garcia@myway.com', 'regular administrator', 'administrator', 'jack.garcia', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1090308850956', 'Margaret', 'MARTIN', '-', '0', 'margaret.martin@email.com', 'regular administrator', 'administrator', 'margaret.martin', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2210722659535', 'Susan', 'NELSON', '-', '0', 'susan.nelson@myspace.com', 'regular administrator', 'administrator', 'susan.nelson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1390510210850', 'Harry', 'LEWIS', '-', '0', 'harry.lewis@live.com', 'regular administrator', 'administrator', 'harry.lewis', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2921012960096', 'Joseph', 'NELSON', '-', '0', 'joseph.nelson@icloud.com', 'super-administrator', 'administrator', 'joseph.nelson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1970805448225', 'Richard', 'JONES', '-', '0', 'richard.jones@myway.com', 'verified client', 'client', 'richard.jones', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1720717621779', 'James', 'CARTER', '-', '0', 'james.carter@zapak.com', 'regular administrator', 'administrator', 'james.carter', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2291013548024', 'Patricia', 'WALKER', '-', '0', 'patricia.walker@myspace.com', 'regular administrator', 'administrator', 'patricia.walker', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('2511021181410', 'Jennifer', 'HILL', '-', '0', 'jennifer.hill@myway.com', 'regular administrator', 'administrator', 'jennifer.hill', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1301123501216', 'Sophia', 'ANDERSON', '-', '0', 'sophia.anderson@in.com', 'verified client', 'client', 'sophia.anderson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1330406703183', 'Jack', 'GARCIA', '-', '0', 'jack.garcia@gmx.com', 'verified client', 'client', 'jack.garcia', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1370223590180', 'Mary', 'YOUNG', '-', '0', 'mary.young@zapak.com', 'registered client', 'client', 'mary.young', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1120318116674', 'Margaret', 'THOMPSON', '-', '0', 'margaret.thompson@live.com', 'super-administrator', 'administrator', 'margaret.thompson', '-');
INSERT INTO user (personal_identifier, first_name, last_name, address, phone_number, email, type, role, username, password)
 VALUES('1010416478736', 'Richard', 'ALLEN', '-', '0', 'richard.allen@myspace.com', 'verified client', 'client', 'richard.allen', '-');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('IRP420560', '2007-4-4', 'paid', '2750513581049');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CMS713823', '1997-10-27', 'issued', '2261007251850');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('NJV814551', '1997-4-24', 'issued', '2890615731093');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('NEJ615160', '1996-8-22', 'issued', '1290621115475');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FPB581707', '1992-6-16', 'issued', '2311218699866');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('DDJ646377', '2002-8-17', 'issued', '1810628366034');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('MCO877846', '2006-8-22', 'issued', '1600406369798');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('APO774579', '2005-3-10', 'paid', '1191116996663');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('QDX331166', '1991-4-28', 'paid', '2511021181410');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('AOV581049', '2008-12-7', 'paid', '1210806549222');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WEV447185', '1995-7-10', 'issued', '2700722395367');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HQD674887', '2004-12-11', 'paid', '1080623235821');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FSS919486', '1998-6-1', 'paid', '2690610869139');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HNY181983', '2008-5-22', 'paid', '2820328860091');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('KHX891261', '2005-11-10', 'issued', '2601109679431');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('JTI919527', '1995-4-24', 'paid', '2340219477422');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FTN110600', '2008-12-4', 'paid', '1670720163758');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ODU200071', '2005-7-30', 'issued', '2750513581049');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HRV978219', '2000-11-2', 'paid', '2990124743604');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GRS745058', '1990-2-26', 'issued', '1381001200223');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HKP554895', '2008-10-26', 'paid', '1900719819315');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('PUB291004', '1991-6-25', 'paid', '2431210382225');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('MAM236416', '1996-1-29', 'issued', '1391219260254');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RVA799921', '1996-10-7', 'issued', '1200511948878');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('IPK424065', '1999-12-17', 'issued', '1771002192746');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('KTV129355', '2005-3-2', 'issued', '1120127453147');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WJK220433', '1995-12-5', 'issued', '1290621115475');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('EWX566637', '1992-4-22', 'paid', '2750930599940');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CWT348693', '1993-2-26', 'paid', '1600406369798');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HUS204932', '2001-3-16', 'paid', '1850228641098');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('VNB599129', '1993-11-23', 'issued', '2061231663444');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FET444189', '1997-12-23', 'paid', '1130517575628');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('UBC804020', '2006-1-27', 'issued', '2700722395367');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RMQ892733', '1999-8-2', 'issued', '2291013548024');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('YCK658007', '1993-12-16', 'paid', '2160302236528');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RLN494860', '1994-9-21', 'issued', '1160624372266');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('MWV860226', '1991-2-2', 'issued', '1510129938853');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CVV262288', '1995-8-16', 'issued', '1510129938853');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('LKN544872', '2009-5-15', 'issued', '1970805448225');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('YRD581657', '1991-6-22', 'paid', '1940812884345');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WVH940137', '1995-6-3', 'issued', '2021117573442');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('VVO977925', '2004-2-3', 'issued', '2290802541669');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('PRY305086', '1996-6-18', 'paid', '1200411468662');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('VSF193480', '1990-4-11', 'issued', '2371127699541');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('AAB632322', '1997-1-10', 'issued', '2120905123090');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('SJR749962', '1998-7-24', 'issued', '1720717621779');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ULV812923', '2005-3-14', 'issued', '1510809194223');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ATL926261', '1998-2-8', 'issued', '1810628366034');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('PPM663361', '2007-2-12', 'issued', '2080307896072');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OEW260254', '2003-1-4', 'issued', '2311218699866');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('TCA382286', '1992-9-19', 'paid', '2291013548024');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('XQG773607', '1991-11-17', 'paid', '1130517575628');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('XKK128508', '2004-8-23', 'paid', '2340514934523');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('XPR467276', '1996-7-9', 'issued', '1891202651532');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OFR198185', '2009-4-15', 'issued', '1160624372266');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GLE244547', '2007-2-18', 'paid', '2210722659535');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('IYE202294', '2004-2-23', 'issued', '1191116996663');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OBB893332', '2007-9-14', 'paid', '1970805448225');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GHX527035', '2005-3-11', 'paid', '1010416478736');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('UBA291191', '2000-5-25', 'issued', '1090308850956');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('DBB862382', '2005-4-17', 'paid', '1390510210850');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CYN451429', '1994-12-3', 'paid', '2980622989118');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('SFY503760', '2008-9-12', 'paid', '2020915473524');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RKO190614', '2007-11-27', 'paid', '2921012960096');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('HES834398', '1999-2-4', 'issued', '1300824767862');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('AKP494438', '2002-3-7', 'paid', '1390510210850');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OKL346882', '2006-4-6', 'issued', '2291013548024');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OQU357572', '2008-8-2', 'issued', '1671106559937');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CQM484242', '1997-2-19', 'paid', '1810628366034');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GNM663444', '2004-12-5', 'issued', '1191116996663');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('UVF993532', '2001-8-31', 'paid', '1060716799851');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WYR899302', '2004-3-20', 'issued', '1330406703183');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RYL898919', '2007-3-8', 'paid', '2210722659535');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('XQP789060', '2002-9-5', 'paid', '1010416478736');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('SFN180459', '2004-2-10', 'paid', '1191116996663');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GRU189852', '1997-11-1', 'issued', '1190324103044');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RPI106941', '1991-4-16', 'paid', '1210806549222');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('MMI917738', '1994-3-28', 'issued', '1730428911187');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FMX288384', '2008-2-22', 'paid', '2601109679431');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('GMS799851', '2009-3-25', 'paid', '1510809194223');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('FKF651578', '2003-3-14', 'issued', '2490730581657');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('RKH659794', '1993-10-14', 'paid', '1191116996663');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ETT961734', '1991-3-14', 'paid', '2121108845412');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('CAO472754', '2003-5-17', 'issued', '2980622989118');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WOC832571', '1993-11-15', 'issued', '1681217744897');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OUD420715', '2006-12-1', 'paid', '1810628366034');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ESK544284', '1998-11-24', 'issued', '2601109679431');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('WLS182045', '1990-1-2', 'issued', '1200511948878');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('BKA134170', '2003-5-16', 'paid', '2120905123090');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('TLX660579', '2002-7-7', 'issued', '2311218699866');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('PYM561968', '1991-4-18', 'issued', '1771002192746');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('NIV288599', '2007-3-27', 'paid', '2910113989120');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('MRL381398', '2003-4-9', 'issued', '2340219477422');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('LOE765037', '2009-1-5', 'issued', '1030415519063');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('ISG786167', '1996-2-28', 'issued', '1090308850956');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('NRH212250', '2006-3-17', 'issued', '2810614745058');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('QAS890275', '1995-7-5', 'issued', '1120318116674');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('IGJ535902', '2007-2-12', 'paid', '2261007251850');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('JDK917836', '1996-2-23', 'paid', '2350711750893');
INSERT INTO invoice (identification_number, issue_date, state, user_personal_identifier)
 VALUES('OAA210850', '2002-1-24', 'issued', '1200511948878');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('10', '33', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('43', '88', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('40', '47', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('18', '28', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('14', '72', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('30', '89', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('88', '3', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('5', '73', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('38', '57', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('11', '78', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('16', '42', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('2', '6', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('47', '91', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('39', '29', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('42', '93', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('53', '73', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('52', '42', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('63', '41', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('67', '28', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('75', '54', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('80', '40', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('81', '54', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('67', '61', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('42', '33', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('77', '35', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('97', '20', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('63', '66', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('3', '19', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('6', '79', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('19', '74', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('88', '50', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('43', '100', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('22', '79', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('32', '60', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('12', '79', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('80', '24', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('1', '60', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('51', '45', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('80', '23', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('50', '85', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('27', '38', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('59', '24', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('50', '9', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('18', '15', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('85', '56', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('67', '15', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('23', '23', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('18', '91', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('31', '67', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('86', '82', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('64', '65', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('83', '11', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('69', '72', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('33', '94', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('57', '28', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('13', '52', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('42', '71', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('10', '84', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('87', '25', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('73', '79', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('27', '23', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('31', '97', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('80', '11', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('41', '34', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('26', '67', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('68', '24', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('82', '37', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('49', '37', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('46', '50', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('58', '8', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('96', '56', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('74', '29', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('23', '45', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('5', '98', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('12', '4', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('69', '57', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('39', '95', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('50', '90', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('73', '41', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('25', '20', '8');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('60', '50', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('10', '69', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('70', '82', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('29', '57', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('61', '16', '3');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('46', '10', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('26', '34', '6');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('45', '57', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('72', '79', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('60', '6', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('22', '75', '9');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('52', '62', '2');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('98', '62', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('38', '12', '10');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('100', '41', '7');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('8', '53', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('30', '2', '5');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('63', '98', '4');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('66', '36', '1');
INSERT INTO invoice_detail (invoice_id, book_id, quantity)
 VALUES('66', '74', '6');

DELIMITER //
CREATE FUNCTION calculate_supply_order_value (
	identification_number VARCHAR(10)
)
RETURNS DECIMAL(12,2)
BEGIN
	DECLARE result DECIMAL(12,2);
	SELECT SUM(sod.quantity*b.price) INTO result FROM supply_order so, supply_order_detail sod, book b
	WHERE so.identification_number=identification_number AND sod.supply_order_id=so.id AND b.id=sod.book_id;
	RETURN result;
END; //

DELIMITER //
CREATE FUNCTION calculate_invoice_value (
	identification_number VARCHAR(10)
)
RETURNS DECIMAL(12,2)
BEGIN
	DECLARE result DECIMAL(12,2);
	SELECT SUM(id.quantity*b.price) INTO result FROM invoice i, invoice_detail id, book b
	WHERE i.identification_number=identification_number AND id.invoice_id=i.id AND b.id=id.book_id;
	RETURN result;
END; //

DELIMITER //
CREATE PROCEDURE calculate_user_total_invoice_value (
	IN personal_identifier BIGINT(13),
	OUT total_invoice_value DECIMAL(12,2)
)
BEGIN
	SELECT COALESCE(SUM(calculate_invoice_value(identification_number)), 0) INTO total_invoice_value FROM invoice i WHERE i.user_personal_identifier=personal_identifier;
	SELECT identification_number, calculate_invoice_value(identification_number), issue_date FROM invoice i WHERE i.user_personal_identifier=personal_identifier ORDER BY issue_date ASC;
	SELECT CONCAT('Total Value: ',total_invoice_value,' RON'); 
END; //