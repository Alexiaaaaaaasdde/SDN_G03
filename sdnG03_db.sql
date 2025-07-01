DROP DATABASE IF EXISTS sdnG03_db;
CREATE DATABASE IF NOT EXISTS sdnG03_db;
USE sdnG03_db;

-- Tabla de roles
CREATE TABLE role (
    idrole INT PRIMARY KEY AUTO_INCREMENT,
    rolname VARCHAR(50) NOT NULL
);

-- Tabla de usuarios
CREATE TABLE user (
    iduser INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    names VARCHAR(100) NOT NULL,
    lastnames VARCHAR(100) NOT NULL,
    code VARCHAR(20),
    rol INT,
    session VARCHAR(10),
    time_stamp DATETIME,
    ip VARCHAR(15),
    sw_id VARCHAR(50),
    sw_port INT,
    mac VARCHAR(17),
    numrules INT,
    FOREIGN KEY (rol) REFERENCES role(idrole)
);

-- Tabla de reglas
CREATE TABLE rule (
    idrule INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    svr_ip VARCHAR(15),
    svr_port INT,
    svr_mac VARCHAR(17),
    action VARCHAR(20)
);

-- Tabla de relación rol-regla
CREATE TABLE role_has_rule (
    role_idrole INT,
    rule_idrule INT,
    PRIMARY KEY (role_idrole, rule_idrule),
    FOREIGN KEY (role_idrole) REFERENCES role(idrole),
    FOREIGN KEY (rule_idrule) REFERENCES rule(idrule)
);

-- Tabla cursos con estado
CREATE TABLE curso (
    idcurso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo'
);

-- Tabla inscripcion (relaciona usuarios y cursos)
CREATE TABLE inscripcion (
    user_iduser INT,
    curso_idcurso INT,
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_iduser, curso_idcurso),
    FOREIGN KEY (user_iduser) REFERENCES user(iduser),
    FOREIGN KEY (curso_idcurso) REFERENCES curso(idcurso)
);

-- Insertar roles
INSERT INTO role (rolname) VALUES 
('admin'),
('user'),
('invitado'),
('alumno');

-- Insertar usuarios con roles correspondientes
INSERT INTO user (username, password, names, lastnames, code, rol, session, time_stamp, ip, sw_id, sw_port, mac, numrules) VALUES
('admin1', 'admin123', 'Admin', 'User', 'ADMIN001', 1, 'active', NOW(), '10.0.0.1', '00:00:f2:20:f9:45:4c:4e', 3, 'fa:16:3e:0a:37:49', 0),
('user1', 'password1', 'Nombre1', 'Apellido1', 'C001', 2, 'active', NOW(), '10.0.0.1', '00:00:f2:20:f9:45:4c:4e', 3, 'fa:16:3e:0a:37:49', 0),
('alumno1', 'passalumno', 'Alumno', 'Ejemplo', 'A001', 4, 'active', NOW(), '10.0.0.5', '00:00:11:22:33:44:55:66', 2, 'de:ad:be:ef:00:01', 0);

-- Insertar reglas
INSERT INTO rule (name, description, svr_ip, svr_port, svr_mac, action) VALUES
('Regla Admin', 'Acceso completo para admin', '192.168.201.200', 8080, 'f2:20:f9:45:4c:4e', 'allow'),
('Regla User', 'Acceso limitado para usuario', '192.168.201.201', 8081, 'fa:16:3e:0a:37:49', 'allow'),
('Regla Invitado', 'Acceso restringido para invitado', '192.168.201.202', 8082, 'de:ad:be:ef:00:01', 'deny'),
('Regla Alumno', 'Acceso para alumnos a cursos', '192.168.201.203', 8083, 'de:ad:be:ef:00:02', 'allow');

-- Asociar reglas con roles
INSERT INTO role_has_rule (role_idrole, rule_idrule) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insertar cursos
INSERT INTO curso (nombre, estado) VALUES
('Curso Python Básico', 'activo'),
('Curso Redes', 'activo'),
('Curso Seguridad', 'inactivo');

-- Inscribir alumno1 en cursos activos
INSERT INTO inscripcion (user_iduser, curso_idcurso) VALUES
(
    (SELECT iduser FROM user WHERE username = 'alumno1'),
    (SELECT idcurso FROM curso WHERE nombre = 'Curso Python Básico')
),
(
    (SELECT iduser FROM user WHERE username = 'alumno1'),
    (SELECT idcurso FROM curso WHERE nombre = 'Curso Redes')
);

-- Añadir después de la tabla 'inscripcion'
-- Tabla de recursos
CREATE TABLE resource (
    idresource INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    ip VARCHAR(15) NOT NULL,
    mac VARCHAR(17) NOT NULL,
    port INT,
    description TEXT
);

-- Tabla de relación recurso-rol
CREATE TABLE role_has_resource (
    role_idrole INT,
    resource_idresource INT,
    PRIMARY KEY (role_idrole, resource_idresource),
    FOREIGN KEY (role_idrole) REFERENCES role(idrole),
    FOREIGN KEY (resource_idresource) REFERENCES resource(idresource)
);

-- Insertar recursos de ejemplo
INSERT INTO resource (name, ip, mac, port, description) VALUES
('Servidor Python', '192.168.201.210', 'aa:bb:cc:dd:ee:ff', 8080, 'Curso Python Básico'),
('Laboratorio Redes', '192.168.201.211', '11:22:33:44:55:66', 80, 'Laboratorio de redes'),
('Biblioteca Digital', '192.168.201.212', '22:33:44:55:66:77', 443, 'Recursos bibliográficos');

-- Asignar recursos a roles
INSERT INTO role_has_resource (role_idrole, resource_idresource) VALUES
(4, 1),  -- Alumno accede a Servidor Python
(4, 2),  -- Alumno accede a Laboratorio Redes
(1, 3);  -- Admin accede a Biblioteca Digital
