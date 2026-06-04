USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'HospitalDB')
	BEGIN
		ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE HospitalDB
	END
GO

CREATE DATABASE HospitalDB
GO

SELECT * FROM sys.databases
GO

USE HospitalDB
GO

-- Creacion de Schemas
CREATE SCHEMA Admision
GO

CREATE SCHEMA Atencion
GO

CREATE SCHEMA Farmacia	
GO
-------------------------------------
-- Creación de tablas
-------------------------------------
-- Esquema Admision

CREATE TABLE Admision.Pacientes
(
	idPaciente INT IDENTITY(1,1),
	nombres NVARCHAR(100) NOT NULL,
	apellidos NVARCHAR(100) NOT NULL,
	email NVARCHAR(100) NOT NULL,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,
	
	CONSTRAINT pk_paciente 
		PRIMARY KEY(idPaciente),
	CONSTRAINT uq_email
		UNIQUE(email),
	CONSTRAINT ck_email
		CHECK(email like N'%@%.%')
)
GO

CREATE TABLE Admision.Habitaciones(
	idHabitacion INT IDENTITY(1,1),
	codigo NVARCHAR(4) NOT NULL,
	
	idPaciente INT,

	CONSTRAINT pk_habitacion 
		PRIMARY KEY(idHabitacion),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente)
		REFERENCES Admision.Pacientes(idPaciente),
)
GO

-- Esquema Atencion
CREATE TABLE Atencion.Especialidades(
	idEspecialidad INT IDENTITY(1,1),
	nombre NVARCHAR(100) NOT NULL,

	CONSTRAINT pk_especialidad
		PRIMARY KEY(idEspecialidad),
)
GO

CREATE TABLE Atencion.Medicos(
	idMedico INT IDENTITY(1,1),
	nombres NVARCHAR(100) NOT NULL,
	apellidos NVARCHAR(100) NOT NULL,
	email NVARCHAR(100) NOT NULL,
	direccion NVARCHAR(100),
	salario DECIMAL NOT NULL,
	
	idEspecialidad INT,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_medico 
		PRIMARY KEY(idMedico),
	CONSTRAINT fk_especialidad 
		FOREIGN KEY(idEspecialidad) 
		REFERENCES Atencion.Especialidades(idEspecialidad),
	CONSTRAINT uq_email
		UNIQUE(email),
	CONSTRAINT ck_email
		CHECK(email LIKE N'%@%.%'),
	CONSTRAINT ck_salario
		CHECK(salario > 0)
)
GO

CREATE TABLE Atencion.Citas(
	idCita INT IDENTITY(1,1),
	fechaHora datetime,
	estado nvarchar(30),
	
	idPaciente INT,
	idMedico INT,

	CONSTRAINT pk_cita 
		PRIMARY KEY(idCita),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente) 
		REFERENCES Admision.Pacientes(idPaciente),
	CONSTRAINT fk_medico 
		FOREIGN KEY(idMedico) 
		REFERENCES Atencion.Medicos(idMedico)
)
GO


-- Esquema Farmacia

CREATE TABLE Farmacia.Tratamientos(
	idTratamiento int IDENTITY(1,1),
	idPaciente int,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,
	
	CONSTRAINT pk_tratamiento 
		PRIMARY KEY(idTratamiento),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente) 
		REFERENCES Admision.Pacientes(idPaciente),
)
GO

CREATE TABLE Farmacia.Medicamentos(
	idMedicamento int IDENTITY(1,1),
	nombre nvarchar(50) NOT NULL,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_medicamento 
		PRIMARY KEY(idMedicamento),
)
GO

CREATE TABLE Farmacia.DetallesTratamientos(
	idTratamiento int IDENTITY(1,1),
	idMedicamento int NOT NULL,
	dosis float,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_detallest
		PRIMARY KEY(idTratamiento, idMedicamento),
	CONSTRAINT fk_tratamiento 
		FOREIGN KEY(idTratamiento)
		REFERENCES Farmacia.Tratamientos(idTratamiento),
	CONSTRAINT fk_medicamento 
		FOREIGN KEY(idMedicamento) 
		REFERENCES Farmacia.Medicamentos(idMedicamento)
)
GO

-- Alterando las tablas

-- Pacientes
ALTER TABLE Admision.Pacientes
ADD
	telefono NVARCHAR(15),
	direccion NVARCHAR(30),
	genero BIT,
	tipoSangre VARCHAR(3),
	fechaNac DATE NOT NULL
GO

ALTER TABLE Admision.Pacientes
ALTER COLUMN
	nombres NVARCHAR(100)
GO

ALTER TABLE Admision.Pacientes
ALTER COLUMN
	direccion NVARCHAR(100)
GO

-- Medicos
ALTER TABLE Atencion.Medicos
	ADD
	experiencia NVARCHAR(100),
	turno NVARCHAR(15),
	observaciones NVARCHAR(max),

	CONSTRAINT ck_turno CHECK(turno IN ('Matutino', 'Vespertino', N'Nocturno'))
GO

ALTER TABLE Atencion.Medicos
	DROP COLUMN observaciones;
GO

-- Citas
ALTER TABLE Atencion.Citas
	ADD
	costoConsulta int,
	CONSTRAINT ck_costo CHECK(costoConsulta > 0)
GO

ALTER TABLE Atencion.Citas
	DROP CONSTRAINT ck_costo
GO

ALTER TABLE Atencion.Citas
	ALTER COLUMN
	costoConsulta DECIMAL
GO
ALTER TABLE Atencion.Citas
	ADD
	CONSTRAINT ck_costo CHECK(costoConsulta > 0)
GO

-- Habitaciones
ALTER TABLE Admision.Habitaciones
	ADD
	disponibilidad nvarchar(15) DEFAULT 'Disponible',
	CHECK(disponibilidad IN ('Ocupado', 'Disponible'))
GO

-- Tablas temporales: CREATE TABLE #[NOMBRETABLA]
-- Tablas temporales globales: CREATE TABLE ##--

-----------------------------------------------------
-- Modulo IV
-----------------------------------------------------

CREATE TABLE #Temporal
(
	idTemporal INT IDENTITY(1,1),
	dametucosita INT,
	eselpepetastico BIT,
	comosellamaesacosa NVARCHAR(50)

	CONSTRAINT ck_comosellama CHECK(comosellamaesacosa LIKE 'Elpipack!!!'),
	CONSTRAINT uq_damedane UNIQUE(dametucosita)
)
GO

ALTER TABLE #Temporal
DROP CONSTRAINT ck_comosellama
GO

ALTER TABLE #Temporal
DROP CONSTRAINT uq_damedane
GO

ALTER TABLE #Temporal
DROP COLUMN eselpepetastico
GO

DROP TABLE #Temporal
GO

-- Crear y eliminar tabla auditoria
CREATE TABLE Auditoria
(
	idAuditoria INT IDENTITY(1,1),
)
GO

DROP TABLE Auditoria
GO

-- Crear y eliminar tabla logs
CREATE TABLE Logs
(
	idLog INT IDENTITY(1,1),
)
GO

DROP TABLE Logs
GO

-- Eliminar FK
CREATE TABLE Medicoss2
(
	idMedicoss2 INT IDENTITY(1,1),
	medico INT 
	
	CONSTRAINT fk_medico FOREIGN KEY(medico) REFERENCES Atencion.Medicos(idMedico)
)
GO

ALTER TABLE Medicoss2
DROP CONSTRAINT fk_medico
GO

ALTER TABLE Medicoss2
DROP COLUMN medico
GO

DROP TABLE Medicoss2

-- Crear y eliminar tabla MedicamentosPrueba
CREATE TABLE MedicamentosPrueba
(
	idPrueba INT IDENTITY(1,1),
)
GO

DROP TABLE MedicamentosPrueba
GO

-- Crear base de datos de prueba y eliminarla
CREATE DATABASE AllYourBase
GO

DROP DATABASE AllYourBase
GO

---------------------------------------
-- Modulo V
---------------------------------------

INSERT INTO Atencion.Especialidades(nombre)
VALUES
	('Cardiología'),
	('Pediatría'),
	('Neurología'),
	('Dermatología'),
	('Traumatología');
GO

INSERT INTO Atencion.Medicos
(nombres, apellidos, email, direccion, salario, idEspecialidad,	experiencia, turno)
VALUES
	('Carlos','Gomez','cgomez@hospital.com','Managua',1500,1,'10 años','Matutino'),
	('Ana','Martinez','amartinez@hospital.com','Leon',1800,2,'8 años','Vespertino'),
	('Jorge','Ruiz','jruiz@hospital.com','Masaya',2000,3,'12 años','Nocturno'),
	('Lucia','Perez','lperez@hospital.com','Granada',1700,4,'6 años','Matutino'),
	('Mario','Lopez','mlopez@hospital.com','Chinandega',2100,5,'15 años','Vespertino'),
	('Sofia','Castillo','scastillo@hospital.com','Esteli',1900,1,'9 años','Nocturno'),
	('Pedro','Mendez','pmendez@hospital.com','Jinotega',1600,2,'5 años','Matutino'),
	('Rosa','Hernandez','rhernandez@hospital.com','Rivas',2200,3,'14 años','Vespertino'),
	('Luis','Morales','lmorales@hospital.com','Boaco',1750,4,'7 años','Nocturno'),
	('Elena','Torres','etorres@hospital.com','Matagalpa',2300,5,'16 años','Matutino');
GO

INSERT INTO Admision.Pacientes
(nombres, apellidos, email, telefono, direccion, genero, tipoSangre, fechaNac)
VALUES
	('Juan','Perez','juan1@gmail.com','88880001','Managua',1,'O+','1990-01-15'),
	('Maria','Lopez','maria1@gmail.com','88880002','Leon',0,'A+','1992-03-20'),
	('Jose','Ruiz','jose1@gmail.com','88880003','Masaya',1,'B+','1988-07-10'),
	('Ana','Torres','ana1@gmail.com','88880004','Granada',0,'AB+','1995-09-12'),
	('Luis','Castillo','luis1@gmail.com','88880005','Esteli',1,'O-','1985-05-01'),
	('Rosa','Mendez','rosa1@gmail.com','88880006','Jinotega',0,'A-','1998-11-25'),
	('Pedro','Martinez','pedro1@gmail.com','88880007','Rivas',1,'B-','1991-06-15'),
	('Lucia','Morales','lucia1@gmail.com','88880008','Boaco',0,'AB-','1994-04-30'),
	('Mario','Hernandez','mario1@gmail.com','88880009','Chontales',1,'O+','1987-08-08'),
	('Elena','Gomez','elena1@gmail.com','88880010','Carazo',0,'A+','1993-12-19'),
	('Carlos','Diaz','carlos1@gmail.com','88880011','Managua',1,'B+','1990-02-18'),
	('Patricia','Perez','patricia1@gmail.com','88880012','Leon',0,'AB+','1997-01-28'),
	('Andres','Lopez','andres1@gmail.com','88880013','Masaya',1,'O-','1986-10-10'),
	('Karla','Ruiz','karla1@gmail.com','88880014','Granada',0,'A-','1999-06-05'),
	('Javier','Torres','javier1@gmail.com','88880015','Esteli',1,'B-','1992-07-17'),
	('Sandra','Castillo','sandra1@gmail.com','88880016','Jinotega',0,'AB-','1989-09-03'),
	('Fernando','Mendez','fernando1@gmail.com','88880017','Rivas',1,'O+','1991-04-21'),
	('Diana','Martinez','diana1@gmail.com','88880018','Boaco',0,'A+','1996-08-14'),
	('Roberto','Morales','roberto1@gmail.com','88880019','Carazo',1,'B+','1984-12-02'),
	('Valeria','Hernandez','valeria1@gmail.com','88880020','Chinandega',0,'AB+','2000-03-09');
GO

INSERT INTO Atencion.Citas(fechaHora, estado, idPaciente, idMedico, costoConsulta)
VALUES
	(GETDATE(),'Completada',1,1,25),
	(GETDATE(),'Completada',2,2,30),
	(GETDATE(),'Completada',3,3,35),
	(GETDATE(),'Completada',4,4,20),
	(GETDATE(),'Completada',5,5,40),

	(DATEADD(DAY,1,GETDATE()),'Programada',6,6,25),
	(DATEADD(DAY,2,GETDATE()),'Programada',7,7,30),
	(DATEADD(DAY,3,GETDATE()),'Programada',8,8,35),
	(DATEADD(DAY,4,GETDATE()),'Programada',9,9,20),
	(DATEADD(DAY,5,GETDATE()),'Programada',10,10,40),

	(DATEADD(DAY,6,GETDATE()),'Programada',11,1,25),
	(DATEADD(DAY,7,GETDATE()),'Programada',12,2,30),
	(DATEADD(DAY,8,GETDATE()),'Programada',13,3,35),
	(DATEADD(DAY,9,GETDATE()),'Programada',14,4,20),
	(DATEADD(DAY,10,GETDATE()),'Programada',15,5,40);
GO

INSERT INTO Admision.Habitaciones(codigo,idPaciente, disponibilidad) VALUES
	('A101',1,'Ocupado'),
	('A102',2,'Ocupado'),
	('A103',3,'Ocupado'),
	('A104',4,'Ocupado'),
	('A105',5,'Ocupado'),

	('B101',NULL,'Disponible'),
	('B102',NULL,'Disponible'),
	('B103',NULL,'Disponible'),
	('B104',NULL,'Disponible'),
	('B105',NULL,'Disponible');
GO

INSERT INTO Farmacia.Tratamientos(idPaciente)
VALUES
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10);
GO

UPDATE Farmacia.Tratamientos
	SET deletedAt = GETDATE()
	WHERE idTratamiento IN (6,7,8,9,10);
GO

INSERT INTO Farmacia.Medicamentos(nombre)
VALUES
	('Paracetamol'),
	('Ibuprofeno'),
	('Amoxicilina'),
	('Omeprazol'),
	('Loratadina'),
	('Metformina'),
	('Losartan'),
	('Aspirina'),
	('Diclofenaco'),
	('Azitromicina'),
	('Claritromicina'),
	('Insulina'),
	('Salbutamol'),
	('Prednisona'),
	('Cefalexina'),
	('Vitamina C'),
	('Vitamina D'),
	('Acetaminofen'),
	('Enalapril'),
	('Ranitidina');
GO

INSERT INTO Farmacia.DetallesTratamientos
(idMedicamento,dosis)
VALUES
	(1,500),
	(2,400),
	(3,250),
	(4,20),
	(5,10),
	(6,850),
	(7,50),
	(8,100),
	(9,75),
	(10,500);
GO
