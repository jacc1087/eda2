CREATE DATABASE IF NOT EXISTS ChampionsLeague;
USE ChampionsLeague;

-- Creación de la tabla de equipos
-- DROP TABLE Teams; 
CREATE TABLE Teams(
	team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(50) UNIQUE, 
    country VARCHAR(30) NOT NULL,
    foundation_date DATE,
    champion INT(2)
);
 
-- Estadísticas de equipos en esta edición
-- Comprobar que los datos son reales
-- DROP TABLE Teams_Statistics;
CREATE TABLE Teams_Statistics(
	team_id INT PRIMARY KEY,
    goals_scored INT(3),
    goals_conceded INT(3),
    possession INT(2),
    balls_recovered INT(4),
    average_distance INT(3),
    yellow_cards INT(3),
    red_cards INT(3),
	FOREIGN KEY (team_id) REFERENCES Teams(team_id) 
);

-- Creación de la tabla Jugadores 
-- DROP TABLE Players;
CREATE TABLE Players(
	player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(50),
    team_id INT,
    dorsal INT(2),
    country VARCHAR(30),
    age INT,
    height INT CHECK (height > 0),
    weight INT CHECK (weight > 0),
    demarcation VARCHAR (5) NOT NULL,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) 
);

-- Estadísticas de jugadores en esta edición
-- DROP TABLE Players_Statistics;
CREATE TABLE Players_Statistics(
	player_id INT PRIMARY KEY,
    goals INT,
    assists INT,
    FOREIGN KEY (player_id) REFERENCES Players(player_id) 
);

-- Creación de la tabla managers
-- DROP TABLE Manager;
CREATE TABLE Manager(
	manager_id INT AUTO_INCREMENT PRIMARY KEY,
    manager_name VARCHAR(50),
    team_id INT,
    age INT,
    country VARCHAR(30),
    champion INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) 
);

 -- DROP TABLE Teams;
 -- DROP TABLE Teams_Statistics;
 -- DROP TABLE Players;
 -- DROP TABLE Players_Statistics;
 -- DROP TABLE Manager;
