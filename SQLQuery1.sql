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
	medico INT FOREIGN KEY REFERENCES Atencion.Medicos(idMedico)
)
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