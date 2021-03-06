# Proyecto No.2 Laboratorio Sistemas de Bases de Datos 1

## Edson Saul Avila Ortiz 201902302

El siguiente proyecto surgió por la necesidad de mantener sistemas  escalables y óptimos ya que sabemos de estos depende principalmente de un buen diseño de base de datos, debido a la existencia de sistemas poco optimizados y que no utilizan ningún tipo de atomización, El Instituto Centroamericano Electoral ICE busca migrar su actual sistema de almacenaminto.

## Objetivos del Proyecto

- Diseñar y desarrollar un modelo relacional a partir del planteamiento de un problema y el análisis de un archivo de datos.
- Realizar una carga masiva de datos de la información proporcionada a una nueva plataforma mediante la creación de una tabla temporal distribuyendo la información de la carga al modelo relacional propuesto.
- Generar consultas avanzadas en lenguaje SQL que cumplan con los reportes solicitados.

---

## 1. Modelo Lógico

![foto](/imagenes/dd.jpg)

## 2. Modelo Relacional

![Modelo Relacional](/imagenes/relacional.png)

## 3. Restricciones a Utilizar

- Caracteristicas de los votantes que no son su sexo y su raza se tomaron como atributos dentro de la entidad educacion puesto que los valores dentro dependen del tipo de sexo y raza y no dependen entre ellos.
- Para el sexo y la raza se separaron en entidades puesto que son caracteristicas mas influyentes y que independientemente del nivel de educacion cada votante posee un sexo y una raza.
- La entidad eleccion hace referencia a un tipo de eleccion especifica, que en este caso son las elecciones municipales y debido a que no se encontro ningun otro tipo de elecciones se opto por manejar esta unica tabla.

## 4. Tabla de Atributos
### Listado de Entidades

1. pais
2. region
3. departamento
4. municipio
5. eleccion
6. partido
7. partido_eleccion
8. voto
9. educacion
10. sexo
11. raza
    
### Listado de Atributos

-  pais

![foto](/imagenes/pais.png)
-  region

![foto](/imagenes/region.png)
-  departamento

![foto](/imagenes/depto.png)
-  municipio

![foto](/imagenes/municipio.png)
-  eleccion

![foto](/imagenes/eleccion.png)
-  partido

![foto](/imagenes/partido.png)
-  partido_eleccion

![foto](/imagenes/partido_eleccion.png)
-  voto

![foto](/imagenes/voto.png)
-  educacion

![foto](/imagenes/educacion.png)
-  sexo

![foto](/imagenes/sexo.png)
-  raza
  
![foto](/imagenes/raza.png)

## 5. Consideraciones del Diseño

1. La relacion existente entre educacion y voto se dividio debido a que existen datos mas influyentes y que todo votante posee como es la raza y el sexo.
2. Debido a que dentro de los datos solo se maneja un tipo de eleccion se opto porque esta tabla estuviera relacionada unicamente con el municipio al que pertenecio la eleccion.
3. La entidad partido_eleccion sirguio por la necesidad de atomizar los datos de un partido independientemente de las elecciones en que este haya participado.
4. Se decidio dividir el departamento y la region como entidades diferentes para que en caso de existir la necesidad de hacer referencia a una region no haya necesidad de acceder a todos los departamentos.

## 6. Primera Forma Normal

>El valor de una columna debe ser una entidad atomica, indivisible, exluyendo asi las dificultades que podria llevar el tratamiento de un dato formado de varias partes.

1. Todos los atributos, valores almacenados en las columnas, deben ser indivisibles.

2. No deben existir grupos de valores repetidos.

Como primer paso de normalizacion se realiza una inspeccion sobre la tabla, cuyo nombre dentro del proyecto *temporal* en busqueda de atributos dentro de columnas que no sean atomicos, es decir que se puedan dividir y como resultado no se encontrarol columnas que se pudieran dividir debido a la naturaleza de la tabla.

Sin embargo si que se pudo aplicar la segunda indicacion debido a que se encontraron muchos datos repetidos que pudieron ser fracmentados en nuevas tablas, tal es el caso de la siguiente imagen.

![Ejmplo Primera Forma Normal](/imagenes/norm1.png)

A parte de las tablas creadas en el ejemplo tambien se pudieron separar algunas tablas de la temporal como:

- El partido con su nombre y municipio en que participó
- El tipo de elecciones que se llevaron a cabo

## 7. Segunda Forma Normal

>Cuando la tabla tiene una llave primaria conformada por dos o mas columnas se debe asegurar, que todas las demas columnas son accesables a travez de la clave completa y nunca mediante una parte de esa clave.

Un ejemplo de la aplicacion de esta norma la encontramos en la creacion de 2 tablas implicitas las cuales son eleccion y eleccion_municipio, las cuales permiten dividir la informacion de un municipio sin que esta dependa de las elecciones y viceversa. Tambien nos permite tener un mejor control de la informacion del partido sin que esta dependa de demas informacion.

![Ejmplo Tercera Forma Normal](/imagenes/norm2.png)

## 8. Tercera Forma Normal

>No deben existir precedencias transitivas entre las columnas de una tabla. Esto significa que las columnas que no forman parte de la clave primaria deben depender solo de la clave, nunca de otra columna o clave.

Se separaraon algunas columnas como nuevas tablas con el fin de eliminar las precedencias transitivas para que los datos dentro de una entidad correspondan a informacion muy puntual y atomizada. Como se muestra en la imagen, dentro de un pais almacenar la region o algun municipio no es informacion que dependa exclusivamente de la llave primaria.

![Ejmplo Tercera Forma Normal](/imagenes/norm3.png)

![Ejmplo Tercera Forma Normal](/imagenes/norm3_2.png)
