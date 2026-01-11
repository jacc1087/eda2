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

## EDA en SQL
El EDA se encuentra en el archivo "queriesEDA2.sql". Este archivo no es como los otros dos antes ejecutados, porque las queries se deben ejecutar de forma independiente cada una de ellas. 
<br><br>
Se realizan 20 queries con datos que se consideran interesantes para un aficionado al fútbol y seguidor de esta competición en concreto, los resultados obtenidos se pueden comprobar en la web oficial de la uefa, se ha tenido muy en cuenta que se trate de datos reales y cuando al realizar la consulta no han coincidido se han hecho las modificaciones oportunas para que coincidan.
<br><br>
### Requisitos a cumplir
- Mínimo 3 JOINs. Se utilizan bastantes INNER JOIN en las consultas, en este caso no se utiliza ningún LEFT JOIN porque al haber creado la base de datos desde cero, se sabe con certeza que no existen datos nulos y que con la utilización de INNER se pueden obtener los mismos resultados de forma más eficiente.
- CASE y lógica condicional. Se utilizan en varias consultas para asignar valores de texto cuando se cumplen ciertas condiciones, como por ejemplo, asignar la etiqueta de joven promesa a futbolistas que tengan 20 años o menos y hayan participado en goles de forma directa o indirecta.
- Agregaciones. Se utilizan varias de las funciones de agregación, COUNT para contar el número de filas, AVG para realizar una media o SUM para sumar el número de valores numéricos de una columna.
- CTEs (WITH), incluyendo encadenadas. Se utilizan tablas temporales con WITH (concretamente en las consultas 8,11 y 20) para consultas que comparan varias consultas y necesitan de la creación de una tabla temporal que clarifique los datos, por ejemplo, en la consulta 8, cuando se quiere estudiar si influye el porcentaje de posesión de los equipos en su posición en la tabla.
- Funciones ventana (OVER (PARTITION BY...)). Se utilizan para crear rankings útiles para obtener información concreta de algo, por ejemplo en la consulta 11, se crea un ranking de los jugadores de cada posición con más goles, y se selecciona el número 1 de cada posición para devolver lo solicitado en la consulta.
- 1 VIEW y FUNCIÓN con consultas. Se crea una vista para simplificar consultas más complejas y poder utilizar la información obtenida de ellas para otras consultas de forma rápida, por ejemplo, se crea una vista en la consulta 12 para obtener el top 20 de goleadores en la competición, y después, se reutiliza esta vista en la consulta 13 para averiguar con una función con consulta de agregación la media de altura de estos goleadores, para así obtener un insight sobre el tipo de delantero que está triunfando en esta edición de la champions league hasta este momento.
- PROCEDURE. Se utiliza un procedimiento almacenado para realizar tareas más complejas que requieren la utilización de INSERT, por ejemplo, en la consulta 14, que crea una alineación mediante la inserción de un país como parámetro. Para ello crea una tabla temporal donde inserta 1 portero, 4 defensas, 4 centrocampistas y 2 delanteros, todos del mismo país y de forma aleatoria.

## Resultado final
Obtención de varias agrupaciones relevantes:
- En la consulta 4 se obtiene una clasificación de los equipos en función de los puntos y la diferencia de goles hasta el momento
- En la consulta 12 se obtiene el top 20 de máximos goleadores en la competición.
- En la consulta 20 se obtiene la importancia que tienen para su equipo los futbolistas más importantes hasta ahora.
​



