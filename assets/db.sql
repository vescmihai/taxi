CREATE DATABASE uagrm
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    contraseña VARCHAR(100),
    perfil VARCHAR(100)
);

CREATE TABLE Vehiculos (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    año INT,
    placa VARCHAR(10)
);

CREATE TABLE Rutas (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    origen VARCHAR(100),
    destino VARCHAR(100),
    fecha_hora TIMESTAMP
);

CREATE TABLE SolicitudesViaje (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    id_ruta INT REFERENCES Rutas(id),
    estado VARCHAR(20) -- Podría ser 'pendiente', 'aceptado', 'rechazado'
);

CREATE TABLE Pagos (
    id SERIAL PRIMARY KEY,
    id_solicitud_viaje INT REFERENCES SolicitudesViaje(id),
    monto DECIMAL(10,2),
    fecha_pago TIMESTAMP
);

CREATE TABLE Calificaciones (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    id_ruta INT REFERENCES Rutas(id),
    calificacion INT -- Podría ser un valor entre 1 y 5
);

CREATE TABLE Notificaciones (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    mensaje VARCHAR(255),
    fecha TIMESTAMP
);

CREATE TABLE HistorialViajes (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    id_ruta INT REFERENCES Rutas(id),
    fecha TIMESTAMP
);

CREATE TABLE Problemas (
    id SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id),
    id_ruta INT REFERENCES Rutas(id),
    problema VARCHAR(255),
    fecha TIMESTAMP
);
