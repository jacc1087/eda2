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

