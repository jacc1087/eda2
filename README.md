# EDA 2 - Bases de datos relacionales

Para el desarrollo de este proyecto se va a crear una base de datos desde cero. 

El tema sobre el que tratan los datos es el torneo de fútbol de la Champions League en su edición 25/26, aunque es un torneo que todavía no ha finalizado, pero ya acumula unos cuantos partidos y se pueden sacar datos interesantes.

## Datos

Se trata del fichero SchemaEDA2.sql <br><br>

En él podemos encontrar el código para la creación de 5 tablas sobre las que trabajaremos las consultas sql.
<br><br>
Se han quedado fuera del proyecto, por ejemplo, datos como el presupuesto de cada equipo, porque es algo complejo de obtener al influir en ello factores como la publicidad o patrocinadores y no ser datos totalmente transparentes, sino que habría que ajustarlos específicamente a cada equipo y no se consideran datos tan trascendentales como para centrarnos en ello.
<br><br>
A continuación una breve descripción de cada tabla:
<br>
#### TEAMS 
Contiene información básica de los equipos clasificados para esta edición de la champions. País, año de fundación, número de veces que se ha proclamado campeón de este torneo, etc.
#### TEAMS_STATISTICS
En ella se pueden encontrar estadísticas más específicas, en lo que va de torneo, de cada uno de los equipos participantes, tales como: goles, datos de posesión, de balones recuperados, de tarjetas amarillas, etc. Con este tipo de datos se puede hacer un estudio de qué tipo de cualidades de un equipo están siendo más decisivas para estar arriba en la tabla.
#### PLAYERS
Jugadores pertenecientes a los equipos anteriormente descritos. Se describen características personales de los jugadores, tales como dorsal, país de procedencia, edad, posición, etc.
#### PLAYERS_STATISTICS
Estadísticas de los jugadores en esta edición de la champions league. Son sólamente estadísticas de goles y asistencias.
#### MANAGERS
Contiene información básica de cada uno de los entrenadores de los equipos.

## Modelo y esquema
En la creación de tablas, se utiliza la opción "AUTO_INCREMENT" en las tablas principales, TEAMS, PLAYERS y MANAGERS, por tratarse de diferentes entidades. Sin embargo, en las tablas TEAMS_STATISTICS y PLAYERS_STATISTICS, al ser tablas hijas con datos específicos de algunas de las tablas padre, simplemente se emparejan sus id con los de las tablas padre para añadirle algunos datos, mediante claves foráneas.
<br><br>
En todas las tablas se aplica el campo id como primary key, porque se considera que es la forma más sencilla de relacionar datos, si en lugar de esto se utilizasen los nombres de equipos habría que ser muy específico para encontrar cada nombre de equipo, jugador, etc para relacionarlo con otras tablas.
<br><br>
Se aplican varios constraint para controlar los datos que se inserten en las tablas, UNIQUE para datos que no pueden repetirse, NOT NULL para campos que no pueden quedar nulos, incluso un par de CHECK, para controlar que se cumplen algunos datos, como que un jugador no pueda medir menos de 100 cm o pesar menos de 40 kg.
<br><br>
Normalización: Alcanza al menos 3NF en la mayoría de tablas, ya que separa entidades (equipos, jugadores, managers) de sus estadísticas y elimina dependencias mediante tablas dedicadas como Teams_Statistics y Players_Statistics.
<br><br>

## Implementación
Se trata utiliza MySQL para el sistema de gestión de bases de datos y Workbench como entorno para trabajar con ello.
<br><br>
Tanto el archivo ya nombrado con el esquema "SchemaEDA2.sql" como el que contiene los datos "dataEDA2.sql", se pueden ejecutar desde cero en el entorno Workbench utilizando la combinación de selección de todo el contenido (command + a, en iOS) y pulsando el botón de ejecutar porción seleccionada (icono rayo).
<br><br>
Se utilizan las sentencias más comunes, tales como INSERT, UPDATE y DELETE, en el archivo "queriesEDA2.sql", para insertar o modificar datos interesantes o eliminar datos que no se utilicen.
<br><br>
No se utiliza CAST para conversión de tipos de datos porque al tratarse de una base de datos creada desde cero, se han utilizado los tipos de datos que se cree más convenientes para cada uno de las columnas insertadas. Por tanto, no se cree conveniente.
<br><br>
Se utilizan también funciones de fecha y agregaciones (SUM, COUNT, etc). También algunas subqueries en sitios donde encajan bien.
<br><br>

​



