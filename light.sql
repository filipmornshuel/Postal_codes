CREATE TABLE light(
	ONRP BIGINT(5) UNSIGNED NOT NULL,
	plz_typ INT(2) NOT NULL,
	postleitzahl INT(4) NOT NULL,
	zusatzziffern INT(2) NOT NULL,
	ortsbezeichnung18 VARCHAR(18) NOT NULL,
	ortsbezeichnung27 VARCHAR(27) NOT NULL,
	kanton VARCHAR(2) NOT NULL,
	PRIMARY KEY (ONRP) 
);

LOAD DATA INFILE 'C:/temp_import/plz_l_20130819.txt'
INTO TABLE light
CHARACTER SET 'latin1'
FIELDS
	TERMINATED BY '\t'
	ENCLOSED BY '' lines
	TERMINATED BY '\r\n';
	
	











