-- ==================================== CONSULTA 1 ==========================================
with votPart as (
    select ele.nombre elec,ele.año,pa.nombre,par.nombre parti,par.id_partido,
    sum(edu.alfabetos+edu.analfabetos+edu.primaria+edu.nivel_medio+edu.universidad)votos_totales
    from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre,par.partido),
total  as(
    select pa.nombre,sum(edu.alfabetos+edu.analfabetos+edu.primaria+edu.nivel_medio+edu.universidad) as votos
    from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre
)
select votPart.elec,votPart.año,pais.nombre,votPart.parti,((votPart.votos_totales/total.votos)*100) porcentaje
    from votPart inner join pais inner join total on votPart.nombre=pais.nombre 
    and votPart.votos_totales=(
    select max(votPart.votos_totales) from votPart where votPart.nombre=pais.nombre
    ) and 
total.nombre=votPart.nombre;
-- ================================== CONSULTA 4  ===========================================
with votRaz as (
    select pa.nombre,re.nombre reg,(select descripcion from raza where id_raza=vot.id_raza) raza,
    sum(edu.alfabetos+edu.analfabetos+edu.primaria+edu.nivel_medio+edu.universidad)votos,
    pa.id_pais,re.id_region
    from pais pa inner join region re inner join departamento dep 
    inner join municipio mun inner join eleccion ele inner join partido_eleccion pae 
    inner join partido par inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre,re.nombre,raza
), 
regiones as(
    select pa.nombre,re.nombre reg,pa.id_pais,re.id_region from pais pa 
    inner join region re where re.id_pais=pa.id_pais
) 
select votRaz.nombre,votRaz.reg,votRaz.votos 
    from votRaz inner join 
    regiones on votRaz.id_pais=regiones.id_pais and votRaz.id_region=regiones.id_region 
    and votRaz.votos=(select max(votRaz.votos) from votRaz where 
    votRaz.id_pais=regiones.id_pais and votRaz.id_region=regiones.id_region)
    and votRaz.raza='INDIGENAS'
group by regiones.nombre,regiones.reg;

select sum(alfabetos+analfabetos+primaria+nivel_medio+universitarios) from 
temporal where trim(pais)='Costa Rica' and trim(region)='REGION 1'
and raza='INDIGENAS';
-- ================================== CONSULTA 5  ===========================================
with dat as(
    select pa.nombre as pais,dep.nombre as depto,mun.nombre as muni,
    sum(edu.primaria)as prim,sum(edu.nivel_medio)as med,sum(edu.universidad)as univer
    from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion group by pa.nombre,dep.nombre,mun.nombre
) select dat.pais,dat.depto,dat.muni,dat.prim,dat.med,dat.univer from dat 
where dat.univer>(0.25*dat.prim) and dat.univer<(0.3*dat.med) order by dat.univer desc;
-- ================================== CONSULTA 6  ==========================================
with departa as (
    select pa.nombre,dep.nombre depto,pa.id_pais,dep.id_depto,
    sum(edu.alfabetos+edu.analfabetos+edu.primaria+edu.nivel_medio+edu.universidad)votos
    from pais pa inner join region re inner join departamento dep  
    inner join municipio mun inner join eleccion ele inner join partido_eleccion pae 
    inner join partido par inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre,dep.nombre
), vots as (
    select pa.nombre,dep.nombre depto,vot.id_sexo,pa.id_pais,dep.id_depto,
    sum(edu.universidad)votos_uni from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre,dep.nombre,vot.id_sexo
) select departa.nombre,departa.depto,(select (votos_uni/departa.votos*100) from vots where 
    vots.id_pais=departa.id_pais and vots.id_depto=departa.id_depto and vots.id_sexo=(select 
    id_sexo from sexo where sexo='hombres'))hombres,
    (select (votos_uni/departa.votos*100) from vots where vots.id_pais=departa.id_pais and 
    vots.id_depto=departa.id_depto and vots.id_sexo=(select 
    id_sexo from sexo where sexo='mujeres'))mujeres
    from departa where
    (select (votos_uni/departa.votos*100) from vots where vots.id_pais=departa.id_pais and 
    vots.id_depto=departa.id_depto and vots.id_sexo=(select 
    id_sexo from sexo where sexo='mujeres')) >
    (select (votos_uni/departa.votos*100) from vots where 
    vots.id_pais=departa.id_pais and vots.id_depto=departa.id_depto and vots.id_sexo=(select 
id_sexo from sexo where sexo='hombres'));
-- ================================== CONSULTA 11 ===========================================
with muj as (
    select pa.nombre,
    sum(edu.alfabetos) as votos
    from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion and vot.id_sexo=(select id_sexo from 
    sexo where sexo='mujeres') and vot.id_raza=(select id_raza from raza
    where descripcion='INDIGENAS') group by pa.nombre) ,
pai as (
    select pa.nombre,sum(edu.alfabetos+edu.analfabetos+edu.primaria+edu.nivel_medio+edu.universidad)votos
    from pais pa
    inner join region re inner join departamento dep inner join municipio mun
    inner join eleccion ele inner join partido_eleccion pae inner join partido par
    inner join voto vot inner join educacion edu
    on pa.id_pais=re.id_pais and re.id_region=dep.id_region and dep.id_depto=mun.id_depto
    and ele.id_municipio=mun.id_municipio and pae.id_eleccion=ele.id_eleccion 
    and par.id_partido=pae.id_partido and vot.id_partido_eleccion=pae.id_partido_eleccion
    and edu.id_educacion=vot.id_educacion  group by pa.nombre
) select muj.nombre,muj.votos,(muj.votos/pai.votos*100) porcentaje
from pai, muj where pai.nombre=muj.nombre;