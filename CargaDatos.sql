use db1_proyecto2;
-- TABLA PAIS
insert into pais (nombre) select distinct pais from temporal;  
-- TABLA REGION
insert into region (id_pais,nombre) 
select distinct (select id_pais from pais where nombre=t.pais) as id,t.region from temporal t;
-- DEPARTAMENTO 
insert into departamento (nombre,id_region)
select distinct TRIM(t.depto),(select r.id_region from region r 
where t.region=r.nombre and r.id_pais=(select id_pais from pais where nombre=t.pais)) as id_region 
from temporal t;
-- MUNICIPIO
insert into municipio (nombre,id_depto)
select distinct TRIM(t.municipio),
(select id_depto from departamento where nombre=TRIM(t.depto) ) as id
from temporal t;
-- SEXO
insert into sexo (sexo)
select distinct sexo from temporal;
-- RAZA
insert into raza (descripcion)
select distinct raza from temporal;
-- PARTIDO POLITICO
insert into partido (partido,nombre)
select distinct partido,nombre_partido from temporal;
-- ELECCION MUNICIPIO =======================================
insert into eleccion (nombre,año,id_municipio)
select datos.nombre_eleccion,datos.año_eleccion,datos.ide from (
select distinct t.pais,t.depto,t.municipio,t.nombre_eleccion,t.año_eleccion,
(select id_municipio from municipio where nombre=trim(t.municipio) and id_depto=
(select id_depto from departamento where nombre=trim(t.depto) )) as ide
from temporal t) datos;
-- PARTIDO ELECCION
insert into partido_eleccion (id_partido,id_eleccion)
select da.id_partido,da.id_eleccion from (
select distinct t.pais,t.region,t.depto,t.municipio,t.partido,p.id_partido,e.id_eleccion
from temporal t inner join partido p 
inner join eleccion e
on p.partido=t.partido and e.id_municipio=(select id_municipio from municipio where nombre=trim(t.municipio)
and id_depto=(select id_depto from departamento where nombre=trim(t.depto)))
) da;
-- ===============================================================
-- eduacion 
insert into educacion (analfabetos,alfabetos,primaria,nivel_medio,universidad)
select datos.analfabetos,datos.alfabetos,datos.primaria,datos.nivel_medio,datos.universitarios from (
select distinct trim(depto),TRIM(municipio),partido,sexo,raza,alfabetos,analfabetos,
primaria,nivel_medio,universitarios 
from temporal) as datos;
-- ========================================================
-- voto
insert into voto (id_raza,id_sexo,id_educacion)
select (select id_raza from raza where descripcion=da.raza) id_raza,
(select id_sexo from sexo where sexo=da.sexo) id_sexo, e.id_educacion
from (select distinct trim(depto),TRIM(municipio),partido,sexo,raza,alfabetos,
analfabetos,primaria,nivel_medio,universitarios from temporal) da inner join 
educacion e on e.alfabetos=da.alfabetos and e.analfabetos=da.analfabetos and 
e.primaria=da.primaria and e.nivel_medio=da.nivel_medio and e.universidad=da.universitarios;