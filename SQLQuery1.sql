CREATE DATABASE HospitalDB
GO

SELECT * FROM sys.databases
GO

USE HospitalDB
GO

-- Creación de tablas
CREATE TABLE Especialidades(
	idEspecialidad INT IDENTITY(1,1),
	nombre NVARCHAR(100) NOT NULL,

	CONSTRAINT pk_especialidad
		PRIMARY KEY(idEspecialidad),
)
GO

CREATE TABLE Pacientes
(
	idPaciente INT IDENTITY(1,1),
	nombres NVARCHAR(100) NOT NULL,
	apellidos NVARCHAR(100) NOT NULL,
	email NVARCHAR(100) NOT NULL,
	fechaNac DATE NOT NULL,

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

CREATE TABLE Habitaciones(
	idHabitacion INT IDENTITY(1,1),
	codigo NVARCHAR(4) NOT NULL,
	
	idPaciente INT,

	CONSTRAINT pk_habitacion 
		PRIMARY KEY(idHabitacion),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente)
		REFERENCES Pacientes(idPaciente),
)
GO

CREATE TABLE Medicos(
	idMedico INT IDENTITY(1,1),
	nombres NVARCHAR(100) NOT NULL,
	apellidos NVARCHAR(100) NOT NULL,
	email NVARCHAR(100) NOT NULL,
	direccion NVARCHAR(100),
	fechaNac DATE NOT NULL,
	idEspecialidad INT,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_medico 
		PRIMARY KEY(idMedico),
	CONSTRAINT fk_especialidad 
		FOREIGN KEY(idEspecialidad) 
		REFERENCES Especialidades(idEspecialidad),

	CONSTRAINT uq_email
		UNIQUE(email),
	CONSTRAINT ck_email
		CHECK(email like N'%@%.%')
)
GO

CREATE TABLE Citas(
	idCita INT IDENTITY(1,1),
	fechaHora datetime,
	
	idPaciente INT,
	idMedico INT,

	CONSTRAINT pk_cita 
		PRIMARY KEY(idCita),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente) 
		REFERENCES Pacientes(idPaciente),
	CONSTRAINT fk_medico 
		FOREIGN KEY(idMedico) 
		REFERENCES Medicos(idMedico)
)
GO

CREATE TABLE Tratamientos(
	idTratamiento int IDENTITY(1,1),
	idPaciente int,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,
	
	CONSTRAINT pk_tratamiento 
		PRIMARY KEY(idTratamiento),
	CONSTRAINT fk_paciente 
		FOREIGN KEY(idPaciente) 
		REFERENCES Pacientes(idPaciente),
)
GO

CREATE TABLE Medicamentos(
	idMedicamento int IDENTITY(1,1),
	nombre nvarchar(50) NOT NULL,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_medicamento 
		PRIMARY KEY(idMedicamento),
)
GO

CREATE TABLE DetallesTratamientos(
	idTratamiento int IDENTITY(1,1),
	idMedicamento int NOT NULL,
	dosis float,

	createdAt DATETIME DEFAULT getDate(),
	updatedAt DATETIME NULL,
	deletedAt DATETIME NULL,

	CONSTRAINT pk_tratamiento 
		PRIMARY KEY(idTratamiento),
	CONSTRAINT fk_medicamento 
		FOREIGN KEY(idMedicamento) 
		REFERENCES Medicamentos(idMedicamento)
)
GO