INSERT INTO SUCURSAL (Nombre, Ciudad, Direccion) VALUES
('San Pablo Norte', 'Loja', 'Av. Cuxibamba y Manuel Agustín Aguirre'),
('San Pablo Sur', 'Loja', 'Av. Eduardo Kingman y Pío Jaramillo Alvarado');


INSERT INTO PACIENTE (Nombres, Apellidos, Correo, F_Nacimiento, Telefono, Genero) VALUES
('Jostin', 'Perez', 'jostin.p@correo.com', '2005-10-18', '0981234567', 'Masculino'),
('Mayerly', 'Romero', 'mayerly.r@correo.com', '2004-05-20', '0987654321', 'Femenino'),
('Carlos', 'Andrade', 'carlos.a@correo.com', '1990-01-15', '0991111222', 'Masculino'),
('Ana', 'Gomez', 'ana.g@correo.com', '1985-11-30', '0979876543', 'Femenino');

INSERT INTO DOCTOR (Nombres, Apellidos, Num_licencia, Especialidad, Correo, ID_Sucursal_fk) VALUES
('Elena', 'Davila', 'L-1001', 'Cardiología', 'elena.d@sanpablo.com', 1), 
('Miguel', 'Castro', 'L-1002', 'Pediatría', 'miguel.c@sanpablo.com', 1), 
('Lucia', 'Fernandez', 'L-2001', 'Dermatología', 'lucia.f@sanpablo.com', 2); 

INSERT INTO CITA (Fecha, Hora, Motivo, Estado, ID_Paciente_fk, ID_Doctor_fk) VALUES
('2025-11-15', '09:00:00', 'Chequeo general', 'Completada', 1, 1), 
('2025-11-15', '10:00:00', 'Vacunación', 'Completada', 3, 2),     
('2025-11-16', '14:00:00', 'Revisión de lunares', 'Completada', 2, 3), 
('2025-11-17', '11:00:00', 'Control de presión', 'Programada', 1, 1), 
('2025-11-18', '09:30:00', 'Chequeo pediátrico', 'Programada', 3, 2), 
('2025-11-19', '16:00:00', 'Consulta dermatológica', 'Cancelada', 4, 3);

INSERT INTO TRATAMIENTO (Descripcion, Duracion_dias, Costo, ID_Cita_fk) VALUES
('Exámenes de sangre y electrocardiograma', 0, 85.50, 1),
('Receta de medicación para presión (incluida)', 0, 0.00, 1),
('Vacuna Tétanos', 0, 30.00, 2),
('Extracción de lunar (biopsia)', 0, 150.00, 3);

CREATE VIEW view_citas_completadas_detalle AS
SELECT
    p.Nombres AS nombre_paciente,
    p.Apellidos AS apellido_paciente,
    d.Nombres AS nombre_doctor,
    d.Especialidad,
    s.Nombre AS nombre_sucursal,
    c.Fecha, 
    c.Motivo
FROM CITA c
JOIN PACIENTE p ON c.ID_Paciente_fk = p.ID_Paciente
JOIN DOCTOR d ON c.ID_Doctor_fk = d.ID_Doctor
JOIN SUCURSAL s ON d.ID_Sucursal_fk = s.ID_Sucursal
WHERE c.Estado = 'Completada';

CREATE VIEW view_costo_total_por_paciente AS
SELECT
    p.Nombres,
    p.Apellidos,
    SUM(t.Costo) AS costo_total_gastado
FROM PACIENTE p
JOIN CITA c ON p.ID_Paciente = c.ID_Paciente_fk
JOIN TRATAMIENTO t ON c.ID_Cita = t.ID_Cita_fk
GROUP BY
    p.ID_Paciente,
    p.Nombres,
    p.Apellidos;
    
CREATE VIEW view_doctores_sin_citas_programadas AS
SELECT Nombres, Especialidad
FROM DOCTOR
WHERE ID_Doctor NOT IN (
    SELECT ID_Doctor_fk
    FROM CITA
    WHERE Estado = 'Programada'
);

CREATE VIEW view_pacientes_sin_citas_programadas AS
SELECT Nombres, Apellidos, Correo
FROM PACIENTE
WHERE ID_Paciente NOT IN (
    SELECT ID_Paciente_fk
    FROM CITA
    WHERE Estado = 'Programada'
);

CREATE VIEW view_tratamiento_costo_mayor_50 AS
SELECT
    p.Nombres AS Paciente_Nombre,
    p.Apellidos AS Paciente_Apellido,
    d.Nombres AS Doctor_Nombre,
    d.Apellidos AS Doctor_Apellido,
    t.Descripcion
FROM PACIENTE p
JOIN CITA c ON p.ID_Paciente = c.ID_Paciente_fk
JOIN DOCTOR d ON c.ID_Doctor_fk = d.ID_Doctor
JOIN TRATAMIENTO t ON c.ID_Cita = t.ID_Cita_fk
WHERE
    t.Costo > 50.00;

CREATE VIEW view_lista_contactos_pacientes_doctores AS
(
    SELECT Nombres, Apellidos, Correo
    FROM PACIENTE
)
UNION
(
    SELECT Nombres, Apellidos, Correo
    FROM DOCTOR
);