/* ==========================================================================================================================================
	1. Obtener todos los equipos campeones de la champions league, inscritos en la edición 2025/2026
========================================================================================================================================== */
SELECT team_name, champion FROM Teams WHERE champion > 0 ORDER BY champion DESC;

	-- Tras comprobar los resultados, se observa que no aparece el último campeón, el PSG, por tanto se modifica este dato
		-- Primero se busca el id del Paris Saint Germaine
		SELECT team_id, team_name FROM Teams;
		-- A continuación se actualiza la lista de campeones con un trofeo
		UPDATE Teams SET champion = 1 WHERE team_id = 28;

	-- Volvemos a ejecutar la consulta anterior para comprobar que se ha actualizado
	SELECT team_name, champion FROM Teams WHERE champion > 0 ORDER BY champion DESC;
    
/* ==========================================================================================================================================
	2. Obtener todas los goles que se han anotado en esta edición
========================================================================================================================================== */
SELECT SUM(goals_scored) FROM Teams_Statistics;
	-- Se han marcado 365 goles en esta edición de la champions league hasta el momento


/* ==========================================================================================================================================
	3. Nacionalidad que más jugadores tiene inscritos en esta edición de la Champions League
========================================================================================================================================== */
SELECT 
	country,COUNT(player_id) AS Quantity 
FROM Players 
GROUP BY country 
ORDER BY Quantity DESC;
-- Se obtiene una abrumadora mayoría de jugadores españoles en esta competición.

	-- Para comprobar si se han tenido en cuenta todos los jugadores se realiza consulta que sume los valores de la consulta anterior mediante una subconsulta
	SELECT 
		SUM(Quantity) AS Total_Jugadores
	FROM (
		SELECT 
			country, 
            COUNT(player_id) AS Quantity 
		FROM Players 
    GROUP BY country) AS subconsulta;
    -- Obtenemos los 915 jugadores inscritos en la competición, por tanto, los datos deben ser correctos.
    
/* ==========================================================================================================================================
	4. Crear una clasificación de todos los equipos en función de los puntos obtenidos hasta el momento
========================================================================================================================================== */
	
    -- Para ello debemos añadir la columna puntos, puesto que no está en la carga de datos inicial 
	ALTER TABLE Teams_Statistics ADD points INT;
    
    -- A continuación añadir los datos de los 36 equipos, obtenidos directamente de la web oficial de la uefa
    SET SQL_SAFE_UPDATES = 0;
    UPDATE Teams_Statistics
    SET points = CASE team_id
		WHEN 1 THEN 3 	-- Ajax 
        WHEN 2 THEN 18  -- Arsenal
		WHEN 3 THEN 13	-- Atalanta
		WHEN 4 THEN 5	-- Athletic de Bilbao
		WHEN 5 THEN 12	-- Atlético de Madrid
        WHEN 6 THEN 11  -- Borussia Dortmund
        WHEN 7 THEN 10  -- FC Barcelona
        WHEN 8 THEN 15  -- Bayern Munich
        WHEN 9 THEN 6   -- Benfica
        WHEN 10 THEN 3  -- Bodo/Glimt
        WHEN 11 THEN 10 -- Chelsea
        WHEN 12 THEN 4  -- Brugge
        WHEN 13 THEN 7  -- Copenhagen
        WHEN 14 THEN 4  -- Eintracht Frankfurt
        WHEN 15 THEN 9  -- Galatasaray
        WHEN 16 THEN 12 -- Inter de Milan
		WHEN 17 THEN 9	-- Juventus
        WHEN 18 THEN 1  -- Kairat Almaty
        WHEN 19 THEN 9  -- Bayer Leverkusen
        WHEN 20 THEN 12 -- Liverpool
        WHEN 21 THEN 13 -- Manchester City
        WHEN 22 THEN 9  -- Marseille
        WHEN 23 THEN 9  -- Monaco
        WHEN 24 THEN 7  -- Napoli
        WHEN 25 THEN 10 -- Newcastle
        WHEN 26 THEN 5  -- Olympiacos
        WHEN 27 THEN 6  -- Pafos
        WHEN 28 THEN 13 -- PSG
        WHEN 29 THEN 8  -- PSV Eindovhen
        WHEN 30 THEN 7  -- Qarabag
        WHEN 31 THEN 12 -- Real Madrid
        WHEN 32 THEN 3  -- Slavia Praha
        WHEN 33 THEN 10 -- Sporting CP
        WHEN 34 THEN 11 -- Tottenham
        WHEN 35 THEN 6  -- Union SG
        WHEN 36 THEN 1  -- Villarreal
	END;
    
	-- A continuación se obtiene una clasificación que se ciñe a los puntos de cada equipo, en caso de empate ordena al azar los equipos
	SELECT 
		team_name,
        points 
    FROM Teams A JOIN Teams_Statistics B 
    ON A.team_id = B.team_id 
    ORDER BY points DESC;
    
    -- Para que sea más real, vamos a crear una nueva columna llamada GOAL_DIFFERENCE, que tenga en cuenta este dato para posicionar a los equipos en caso de empate de puntos
    ALTER TABLE Teams_Statistics ADD COLUMN goal_difference INT GENERATED ALWAYS AS (goals_scored - goals_conceded) VIRTUAL;
    
    -- Comprobamos de nuevo, teniendo en cuenta los empates de puntos y obtenemos la siguiente clasificación, que se ajusta más a la real de la web oficial
	SELECT 
		team_name,
        points,
        goal_difference 
	FROM Teams A JOIN Teams_Statistics B 
    ON A.team_id = B.team_id 
    ORDER BY points DESC, goal_difference DESC;
    
/* ==========================================================================================================================================
	5. Comprobar cuáles son los equipos que más kilómetros han recorrido
========================================================================================================================================== */
SELECT 
	team_name, 
    average_distance 
FROM Teams A JOIN Teams_Statistics B 
ON A.team_id = B.team_id 
ORDER BY average_distance DESC; 

/* ==========================================================================================================================================
	6. Comprobar cuáles son los equipos con más posesión de balón
========================================================================================================================================== */
SELECT 
	team_name, 
    possession 
FROM Teams A JOIN Teams_Statistics B 
ON A.team_id = B.team_id 
ORDER BY possession DESC;  

/* ==========================================================================================================================================
	7. Comprobar cuáles son los equipos con más balones recuperados
========================================================================================================================================== */
SELECT 
	team_name, 
    balls_recovered 
FROM Teams A JOIN Teams_Statistics B 
ON A.team_id = B.team_id 
ORDER BY balls_recovered DESC; 

/* ==========================================================================================================================================
	8. Sería interesante conocer el dato de cuántos de los 10 primeros equipos en las listas anteriores están situados entre los 10 primeros en la clasificación
========================================================================================================================================== */
	-- Vamos a resolver esta consulta con una CTE encadenada
	-- Tomamos como referencia la clasificación que hemos obtenido en el punto 5 para comparar el resto de tops obtenidos 
	WITH classification AS (
    SELECT team_name, points, goal_difference 
    FROM Teams A 
    JOIN Teams_Statistics B ON A.team_id = B.team_id 
    ORDER BY points DESC, goal_difference DESC
    LIMIT 10
	),
    -- En primer lugar buscamos cuantos de los 10 equipos que más kilómetros corren están entre los 10 primeros en la clasificación
	more_runners AS (
		SELECT team_name, average_distance 
		FROM Teams A 
		JOIN Teams_Statistics B ON A.team_id = B.team_id 
		ORDER BY average_distance DESC
		LIMIT 10
		),
	-- A continuación buscamos cuantos de los 10 equipos con más posesión de balón están entre los 10 primeros en la clasificación
	more_possession AS (
		SELECT team_name, possession 
		FROM Teams A 
		JOIN Teams_Statistics B ON A.team_id = B.team_id 
		ORDER BY possession DESC
		LIMIT 10
	),
    -- Por último buscamos cuantos de los 10 equipos que más balones roban están entre los 10 primeros de la clasificación
	more_recovered AS (
		SELECT team_name, balls_recovered 
		FROM Teams A 
		JOIN Teams_Statistics B ON A.team_id = B.team_id 
		ORDER BY balls_recovered DESC
		LIMIT 10
	),
	counts AS (
		SELECT 
			(SELECT COUNT(*) FROM classification c JOIN more_runners m ON c.team_name = m.team_name) as runners_count,
	    -- Obtenemos que 4 equipos de los 10 primeros clasificados están entre los 10 que más corren de la competición
			(SELECT COUNT(*) FROM classification c JOIN more_possession m ON c.team_name = m.team_name) as possession_count,
		-- Obtenemos que 7 de los 10 primeros clasificados son están entre los equipos que más posesión de balón tienen
			(SELECT COUNT(*) FROM classification c JOIN more_recovered m ON c.team_name = m.team_name) as recovered_count
		-- Obtenemos que sólamente 1 de los 10 primeros clasificados están entre los 10 que más balones recuperan.
	)
	
    SELECT * FROM counts;

    /* ===============================================================================================================================
		INSIGHT
		Sacamos la conclusión de que para estar arriba en la clasificación de esta edición de la Champions League, es más importante 
        la posesión de balón que los kilómetros recorridos durante el transcurso del partido, y también que los balones recuperados.
	  ================================================================================================================================
    */
  
/* ==========================================================================================================================================
	9. Quiero obtener una lista de los 15 jugadores más participaciones directas en goles en sus equipos
========================================================================================================================================== */
    -- Consulta de agregación, en la que vamos a tener en cuenta a los futbolistas con más goles y con más asistencias
    SELECT 
		player_name,
        SUM(ps.goals + ps.assists) AS goals_participation,
        goals,
        assists
	FROM Players p JOIN Players_Statistics ps 
    ON p.player_id = ps.player_id
    GROUP BY p.player_id, p.player_name
    ORDER BY goals_participation DESC
    LIMIT 15;
    
/* ==========================================================================================================================================
	10.  Quiero saber cuantos de los jugadores más valiosos (en base a la consulta anterior) son jóvenes promesas (<= 20 años)
========================================================================================================================================== */
    SELECT 
		player_name,
		age,
		SUM(ps.goals + ps.assists) AS goals_participation,
    CASE
        WHEN age <= 20 THEN 'Joven Promesa'
        ELSE 'Adulto'
    END AS categoria
	FROM Players p
	JOIN Players_Statistics ps ON p.player_id = ps.player_id
	WHERE age <= 20
	GROUP BY p.player_id, p.player_name, age
	ORDER BY goals_participation DESC, age ASC;
    
/* ==========================================================================================================================================
	11. Máximo goleador por cada demarcación
========================================================================================================================================== */

	-- Función ventana 
    WITH RankedPlayers AS(
		SELECT 
			p.player_name,
			p.demarcation,
			ps.goals,
			ROW_NUMBER() OVER (PARTITION BY p.demarcation ORDER BY ps.goals DESC) AS rn
		FROM Players p JOIN Players_Statistics ps
		ON p.player_id = ps.player_id
		WHERE ps.goals > 0
	)    
    SELECT player_name, demarcation, goals FROM RankedPlayers WHERE rn = 1 
    ORDER BY
		CASE demarcation
			WHEN 'DF' THEN 1
            WHEN 'MC' THEN 2
            WHEN 'DL' THEN 3
        END;

/* ==========================================================================================================================================
	12.  Top 20 de máximos goleadores de la competición
========================================================================================================================================== */

	-- Como vamos a utilizar estos datos para más consultas, vamos a crear una vista personalizada, para facilitar su uso
    CREATE VIEW top20scorers AS
		SELECT 
			p.player_name,
            p.country,
            p.height,
            p.weight,
            ps.goals
		FROM Players p JOIN Players_Statistics ps
        ON p.player_id = ps.player_id
        ORDER BY goals DESC
        LIMIT 20;
    
    SELECT * FROM top20scorers;
    
/* ==========================================================================================================================================
	13. Media de altura del top 20 de goleadores
========================================================================================================================================== */

	-- Creación de una función que nos diga la altura media del top20 de máximos goleadores, para comprobar qué tipo de delantero está siendo más certero

    -- 1. Cambiar delimitador
	DELIMITER //

	-- 2. Función
	CREATE FUNCTION media_altura_top20() 
	RETURNS DECIMAL(5,2)
	READS SQL DATA
	DETERMINISTIC
	BEGIN
		DECLARE suma_altura DECIMAL(10,2);
		DECLARE total_registros INT;
    
		SELECT SUM(height), COUNT(*) INTO suma_altura, total_registros 
		FROM top20scorers;
    
		RETURN ROUND(suma_altura / total_registros, 2);
	END //

	-- 3. Restaurar delimitador
	DELIMITER ;

SELECT media_altura_top20() AS media_altura_top20_goleadores;
   /* ===============================================================================================================================
		INSIGHT
		La media de altura de los máximos goleadores es bastante alta (1,80) lo que demuestra que normalmente los goleadores tienen 
        una altura considerable y, por regla general, tienen menos éxito los que son más pequeños y habilidosos
	  ================================================================================================================================
    */

    
/* ==========================================================================================================================================
	14. Crear una alineación de jugadores de un país (entra por parámetro) inscritos en esta edición de la Champions League
========================================================================================================================================== */
	-- Vamos a crear un procedimiento para ello
DELIMITER //

	CREATE PROCEDURE GenerarAlineacion(IN country VARCHAR(50))
BEGIN
    -- Crear tabla temporal con equipo en lugar de posicion
    CREATE TEMPORARY TABLE alineacion_temp (
        player_name VARCHAR(100),
        demarcation VARCHAR(10),
        team_name VARCHAR(100)
    );

    -- Insertar 1 PORTERO con nombre del equipo
    INSERT INTO alineacion_temp (player_name, demarcation, team_name)
    SELECT p.player_name, p.demarcation, t.team_name
    FROM Players p
    INNER JOIN teams t ON p.team_id = t.team_id
    WHERE p.country = country AND p.demarcation = 'POR'
    ORDER BY RAND() LIMIT 1;

    -- Insertar 4 DEFENSAS con nombre del equipo
    INSERT INTO alineacion_temp (player_name, demarcation, team_name)
    SELECT p.player_name, p.demarcation, t.team_name
    FROM Players p
    INNER JOIN teams t ON p.team_id = t.team_id
    WHERE p.country = country AND p.demarcation = 'DF'
    ORDER BY RAND() LIMIT 4;

    -- Insertar 4 MEDIOCAMPISTAS con nombre del equipo
    INSERT INTO alineacion_temp (player_name, demarcation, team_name)
    SELECT p.player_name, p.demarcation, t.team_name
    FROM Players p
    INNER JOIN teams t ON p.team_id = t.team_id
    WHERE p.country = country AND p.demarcation = 'MC'
    ORDER BY RAND() LIMIT 4;

    -- Insertar 2 DELANTEROS con nombre del equipo
    INSERT INTO alineacion_temp (player_name, demarcation, team_name)
    SELECT p.player_name, p.demarcation, t.team_name
    FROM Players p
    INNER JOIN teams t ON p.team_id = t.team_id
    WHERE p.country = country AND p.demarcation = 'DL'
    ORDER BY RAND() LIMIT 2;

    -- MOSTRAR TODO EN UNA SOLA PESTAÑA ordenado por demarcación
    SELECT * FROM alineacion_temp 
    ORDER BY 
        CASE demarcation 
            WHEN 'POR' THEN 1 
            WHEN 'DF' THEN 2 
            WHEN 'MC' THEN 3 
            WHEN 'DL' THEN 4 
        END;

    -- Limpiar tabla temporal
    DROP TEMPORARY TABLE alineacion_temp;
END //

DELIMITER ;

-- Probamos el procedimiento con un par de países con un gran número de jugadores inscritos, que probablemente puedan completar la alineación
CALL GenerarAlineacion('España');
CALL GenerarAlineacion('Brasil');

-- Se puede dar el caso de que no haya jugadores suficientes en todas las posiciones y no obtengamos un equipo completo, como pasa con Croacia
CALL GenerarAlineacion('Croacia');

/* ==========================================================================================================================================
	15. Obtener el promedio de edad de los entrenadores o managers que han conseguido ganar al menos una champions league
========================================================================================================================================== */
SELECT AVG(age) AS promedio_edad FROM Manager WHERE champion >= 1;

/* ==========================================================================================================================================
	16. Borrar las columnas de tarjetas rojas porque no se usan
========================================================================================================================================== */
ALTER TABLE Teams_Statistics DROP COLUMN red_cards;

/* ==========================================================================================================================================
	17. Conocer la antigüedad de todos los equipos inscritos en base a su año de fundación
========================================================================================================================================== */
SELECT team_name,
       foundation_date,
       TIMESTAMPDIFF(YEAR, foundation_date, CURDATE()) AS team_years
FROM Teams
ORDER BY foundation_date;
-- Es llamativo encontrar a equipos como el Brugge o el Slavia de Praga entre los ingleses, que se sabe que son los más antiguos.

/* ==========================================================================================================================================
	18. Relacionar si los equipos con mas tarjetas amarillas son los que mas balones recuperan 
========================================================================================================================================== */
-- La idea es comprobar si los equipos que más balones recuperan, lo hacen por atacar el balón con agresividad o por insistencia
SELECT t.team_name,ts.balls_recovered,ts.yellow_cards
FROM Teams_Statistics ts 
JOIN Teams t ON ts.team_id = t.team_id
ORDER BY ts.balls_recovered DESC,ts.yellow_cards 
DESC LIMIT 20;
 
  /* ===============================================================================================================================
		INSIGHT
		Se comprueba que los datos no están directamente relacionados, pues el equipo con más tarjetas amarillas, 
		(Olympique de Marsella) tiene 18 y , sin embargo, ocupa el puesto 16 en recuperaciones, de hecho, el top
		10 de equipos que más balones recuperan tienen un número de tarjetas amarillas bastante inferior a 18.
	  ================================================================================================================================
    */

/* ==========================================================================================================================================
	19. Visualizar los números de los jugadores con el dorsal 10
========================================================================================================================================== */
-- Históricamente el dorsal 10 en fútbol se asigna al mejor jugador del equipo, pero los datos dicen que en este caso algunos jugadores no lo merecen
SELECT 
	p.player_name, t.team_name, ps.goals, ps.assists 
FROM Players p 
JOIN Teams t ON p.team_id = t.team_id 
LEFT JOIN Players_Statistics ps ON p.player_id = ps.player_id 
WHERE p.dorsal = 10 
ORDER BY ps.goals DESC,ps.assists DESC;
 
 
/* ==========================================================================================================================================
	20. Buscar el porcentaje de participación directa en el total de goles del máximo contribuyente en cada equipo
========================================================================================================================================== */
 WITH max_contrib AS (
  SELECT 
	p.team_id, 
    p.player_name, 
    (ps.goals + ps.assists) AS contrib,
	ROW_NUMBER() OVER (PARTITION BY p.team_id ORDER BY (ps.goals + ps.assists) DESC) as rn
  FROM Players p 
  JOIN Players_Statistics ps ON p.player_id = ps.player_id
),
team_totals AS (
  SELECT 
	team_id, 
	goals_scored AS total_goals 
  FROM Teams_Statistics
)
SELECT 
	t.team_name,
    tt.total_goals,
    mc.player_name, 
    mc.contrib, 
    ROUND((mc.contrib * 100.0 / tt.total_goals), 2) AS porcentaje
FROM max_contrib mc 
JOIN team_totals tt ON mc.team_id = tt.team_id
JOIN Teams t ON mc.team_id = t.team_id
WHERE mc.rn = 1 AND tt.total_goals > 0
ORDER BY porcentaje DESC;

 
 
 
 
 