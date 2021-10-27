use db1_proyecto2;

drop table if exists municipio;
drop table if exists departamento;
drop table if exists region;
drop table if exists pais;

create table pais(
	id_pais int not null auto_increment,
    nombre varchar(45) not null,
    primary key (id_pais)
);

create table region(
	id_region int not null auto_increment,
    nombre varchar(22) not null,
    id_pais int not null,
    primary key(id_region),
    foreign key (id_pais) references pais(id_pais)
);

create table departamento(
	id_depto int not null auto_increment,
    nombre varchar(55),
    id_region int not null,
    primary key (id_depto),
    foreign key (id_region) references region(id_region)
);

create table municipio(
	id_municipio int not null auto_increment,
    nombre varchar(55),
    id_depto int not null,
    primary key (id_municipio),
    foreign key (id_depto) references departamento(id_depto)
);
