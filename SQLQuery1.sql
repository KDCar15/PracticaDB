CREATE DATABASE HospitalDB
GO

SELECT * FROM sys.databases
GO

USE HospitalDB
GO

-- Creación de tablas
CREATE TABLE Pacientes
(
	idPaciente int,
	nombres nvarchar(100),
	apellidos nvarchar(100),
	fechaNac date,
	habitacion int
)

CREATE TABLE Medicos(
	idMedico int,
	nombres nvarchar(100),
	apellidos nvarchar(100),
	fechaNac date,
	especialidad int
)

CREATE TABLE Especialidades(
	idEspecialidad int,
	nombre nvarchar(100)
)

CREATE TABLE Citas(
	idCita int,
	fechaHora datetime,
	paciente int,
	medico int,
)

CREATE TABLE Habitaciones(
	idHabitacion int,
	codigo nvarchar(50),
)

CREATE TABLE Tratamientos(
	idTratamiento int,
	idPaciente int,
)

CREATE TABLE Medicamentos(
	idMedicamento int,
	nombre nvarchar(50)
)

CREATE TABLE DetallesTratamientos(
	idTratamiento int,
	idMedicamento int,
	dosis float
)

