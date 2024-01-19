CREATE TABLE bootcamp (
bootcamp_id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL
);


CREATE TABLE students (
student_id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
surname VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
bootcamp_id INT NOT NULL,
FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
);


CREATE TABLE module (
module_id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL
);

CREATE TABLE bc_module (
bc_module_id SERIAL PRIMARY KEY,
module_id INT NOT NULL,
bootcamp_id INT NOT NULL,
FOREIGN KEY (module_id) REFERENCES module(module_id),
FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
);

CREATE TABLE teacher (
teacher_id SERIAL PRIMARY KEY,
name VARCHAR(255) NOT NULL,
surname VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
module_id INT NOT NULL,
FOREIGN KEY (module_id) REFERENCES module(module_id)
);



ALTER TABLE students
ADD CONSTRAINT unique_email UNIQUE (email)
;

INSERT INTO bootcamp (name) VALUES 
('Big Data'),
('IA'),
('Web'),
('Machine Learning'),
('Ciberseguridad')
;

INSERT INTO students (name, surname, email, bootcamp_id) VALUES
('Liam', 'García', 'liam.garcia@example.com', 1),
('Emma', 'Martínez', 'emma.martinez@example.com', 2),
('Noah', 'Hernández', 'noah.hernandez@example.com', 3),
('Olivia', 'González', 'olivia.gonzalez@example.com', 4),
('William', 'Pérez', 'william.perez@example.com', 5),
('Ava', 'Rodríguez', 'ava.rodriguez@example.com', 1),
('James', 'López', 'james.lopez@example.com', 1),
('Isabella', 'Sánchez', 'isabella.sanchez@example.com', 3),
('Benjamin', 'Torres', 'benjamin.torres@example.com', 2),
('Sophia', 'Flores', 'sophia.flores@example.com', 1)
;

INSERT INTO module (name) VALUES
('SQL'),
('Protección de datos'),
('HTML-CSS'),
('Estadistica');

INSERT INTO bc_module (module_id, bootcamp_id) VALUES 
(1,1),
(2,1),
(4,1),
(1,2),
(2,2),
(3,3),
(1,4),
(2,4),
(4,4),
(2,5)
;

INSERT INTO teacher (name, surname, email, module_id) VALUES
('Jaime', 'Perez', 'jaime.perez@example.com', 1),
('Isabel', 'Sánchez', 'isabel.sanchez@example.com', 3),
('Benja', 'Torra', 'benja.torra@example.com', 2),
('Sofia', 'Ramos', 'sofia.ramos@example.com', 4)
;