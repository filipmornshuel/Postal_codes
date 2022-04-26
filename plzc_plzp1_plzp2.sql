/*
- Autor: Filip Slavkovic
- Datum: 17.10.2021
- Version: 0.1 
*/

drop DATABASE if EXISTS import_plz_post;
CREATE DATABASE import_plz_post;
USE import_plz_post;
/*
Diese Datenbank wurde mit dem Editor von HeidiSQL gemacht und über MYSQL MariaDB geschrieben.
Sie wurde gemacht mit Hilfe von der Post gemacht, indem ich die bereitgestellten PLZ-Datein von der Post,
hier importiert habe. Die Tabellen wurden gemäss Vorgaben von der Post geschrieben. Das Verzeichnes der Post heisst,
PLZ-Verzeichnis MAT[CH]. www.post.ch/match . Die Beschreibung der jeweilgen Werte werden kurz hier zusammengefasst und im PDF, dass mitgeben wurde, detailiertert beschrieben.
*/


-- Das ist die Community-Tabelle der Post, hier werden grundlegend nur der Gemeindename und Kanton festgehalten.
CREATE TABLE plzc(
	BFSNR BIGINT UNSIGNED NOT NULL, -- Primärschlüssel
	Gemeinename VARCHAR(30) NOT NULL, 
	Kanton VARCHAR(2) NOT NULL, 
	Agglomerationsnummer VARCHAR(5), -- hier darf der Wert NULL sein.
	PRIMARY KEY (BFSNR)

); 

/*Das ist die Postleitzahl 1 Tabelle vom Plus Bestand, da es sich um eine grösse als die Light Version handelt. 
Somit hat es auch mehr Datensätze. 
*/
CREATE TABLE plzp1(
	ONRP BIGINT(5) UNSIGNED NOT NULL, -- Primärschlüssel
	plz_typ INT(2) NOT NULL, /* Hier wird geprüft, ob eine PLZ für bestimmte Adresse grundsätzlich pausibel ist. 
	10 = Domizil- und Fachadressen, 20 = Nur Domiziladressen, 30 = Nur Fach-PLZ, 40 = Firmen-PLZ, 
	80 = Postinterne PLZ (Angabe Zustellpoststelle auf Bundzetteln oder Sackanschriften)
	*/
	postleitzahl INT(4) NOT NULL, 
	zusatzziffern INT(2) NOT NULL,
	ortsbezeichnung18 VARCHAR(18) NOT NULL,
	ortsbezeichnung27 VARCHAR(27) NOT NULL,
	kanton VARCHAR(2) NOT NULL,
	sprachcode INT(1) NOT NULL, -- Sprache innerhalb eines Gebietes: 1 = Deutsch, 2 = Französisch, 3 = Italienisch, 4 = Rätoromanisch
	sprachcode_abweichend varchar(1), -- Darf NULL sein. Abwechende Sprache auch in 1-4 
	bestandeszugehörigkeit INT(1) NOT NULL, 
	briefszustellung varchar(5),  -- Darf NULL sein. 
	plzc_BFSNR BIGINT UNSIGNED NOT NULL, -- Fremschlüssel der Tabelle plzc 
	gültigkeitsdatum DATE NOT NULL, -- Gibt an, ab wann die Daten gültig sind
	
	PRIMARY KEY(ONRP),
	FOREIGN KEY(plzc_BFSNR) REFERENCES plzc(BFSNR) ON UPDATE CASCADE ON DELETE CASCADE

);

-- Zusätzliche Tabelle plzp2. 
CREATE TABLE plzp2(
	onrp INT(5) UNSIGNED NOT NULL, -- Primärschlüssel
	laufnummer INT(3) UNSIGNED NOT NULL, -- 
	bezeichnungstyp INT(1) NOT NULL, /*
	Es gibt zwei Bezeichnungstypen:
	2 = Für die Adressierung erlaubte alternative oder fremdsprachige Ortsbezeichnung.
	3 = Gebietsbezeichnnug. 
	*/
	sprachcode INT(1) NOT NULL, -- Sprache innerhalb eines Gebietes: 1 = Deutsch, 2 = Französisch, 3 = Italienisch, 4 = Rätoromanisch
	ortsbezeichnung_18 CHAR(18) NOT NULL,
	ortsbezeichnung_27 CHAR(27) NOT NULL,
	
	PRIMARY KEY(onrp),
	FOREIGN KEY(laufnummer) REFERENCES plzp2(onrp) 
	
);


-- Die Import-Dateien der jeweiligen Tabellen.


LOAD DATA INFILE 'C:/temp_import/plz_p2_20130819.txt'
INTO TABLE plzp2
CHARACTER SET 'latin1'
FIELDS
	TERMINATED BY '\t'
	ENCLOSED BY '"' LINES 
	TERMINATED BY '\r\n';

LOAD DATA INFILE 'C:/temp_import/plz_p1_20130819.txt'
INTO TABLE plzp1
CHARACTER SET 'latin1'
FIELDS
	TERMINATED BY '\t'
	ENCLOSED BY '' LINES 
	TERMINATED BY '\r\n';

LOAD DATA INFILE 'C:/temp_import/plz_c_20130819.txt'
INTO TABLE plzc
CHARACTER SET 'latin1'
FIELDS
	TERMINATED BY '\t'
	ENCLOSED BY '' LINES 
	TERMINATED BY '\r\n';
	











