set SERVEROUTPUT on;
-----CREACION DE TABLAS
CREATE TABLE gerente(
    idGerente NUMBER(20) primary key,
    descGerente varchar(50),
    fechaRegistro DATE

);
CREATE TABLE condicion(
    idCondicion NUMBER(20) PRIMARY KEY,
    descCondicion varchar(50),
    fechaRegistro DATE

);
CREATE TABLE hospital(
    idHospital NUMBER PRIMARY KEY,
    idDistrito NUMBER(20),
    Nombre varchar(30),
    Antiguedad NUMBER(30),
    Area NUMBER(5,2),
    idSede NUMBER(30),
    idGerente NUMBER(30)UNIQUE,
    idCondicion NUMBER(30),
    fechaRegistro DATE,
    FOREIGN KEY (idDistrito) REFERENCES distrito(idDistrito),
    FOREIGN KEY (idGerente) REFERENCES gerente(idGerente),
    FOREIGN KEY (idCondicion) REFERENCES condicion(idCondicion),
    FOREIGN KEY (idSede) REFERENCES sede(idSede)
);
CREATE TABLE distrito(
    idDistrito NUMBER(20) PRIMARY KEY,
    idProvincia NUMBER(30),
    descDistrito varchar(30),
    fechaRegistro DATE,
    FOREIGN KEY (idProvincia) REFERENCES provincia(idProvincia)
);
CREATE TABLE provincia(
    idProvincia NUMBER(30) PRIMARY KEY ,
    descProvincia VARCHAR(50),
    fechaRegistro DATE
);
CREATE TABLE sede(
    idSede NUMBER(30) PRIMARY KEY,
    descSede VARCHAR2(50),
    fechaRegistro DATE
);




---------------------- INSERTAR VALORES -----------------------
-- Registros para la tabla "provincia"
INSERT INTO provincia (idProvincia, descProvincia, fechaRegistro)
VALUES (1, 'Lima', SYSDATE);

INSERT INTO provincia (idProvincia, descProvincia, fechaRegistro)
VALUES (2, 'Arequipa', SYSDATE);

-- Registros para la tabla "sede"
INSERT INTO sede (idSede, descSede, fechaRegistro)
VALUES (1, 'Sede Principal', SYSDATE);

INSERT INTO sede (idSede, descSede, fechaRegistro)
VALUES (2, 'Sede Secundaria', SYSDATE);

-- Registros para la tabla "distrito"
INSERT INTO distrito (idDistrito, idProvincia, descDistrito, fechaRegistro)
VALUES (1, 1, 'Miraflores', SYSDATE);

INSERT INTO distrito (idDistrito, idProvincia, descDistrito, fechaRegistro)
VALUES (2, 2, 'Cayma', SYSDATE);

-- Registros para la tabla "gerente"
INSERT INTO gerente (idGerente, descGerente, fechaRegistro)
VALUES (1, 'Juan Pérez', SYSDATE);

INSERT INTO gerente (idGerente, descGerente, fechaRegistro)
VALUES (2, 'María García', SYSDATE);

-- Registros para la tabla "condicion"
INSERT INTO condicion (idCondicion, descCondicion, fechaRegistro)
VALUES (1, 'Buena', SYSDATE);

INSERT INTO condicion (idCondicion, descCondicion, fechaRegistro)
VALUES (2, 'Regular', SYSDATE);


SELECT * FROM DISTRITO
-- Registros para la tabla "hospital"
INSERT INTO hospital (idHospital, idDistrito, Nombre, Antiguedad, Area, idSede, idGerente, idCondicion, fechaRegistro)
VALUES (1, 2, 'Hospital A', 10, 100.5, 1, 1, 1, SYSDATE);

INSERT INTO hospital (idHospital, idDistrito, Nombre, Antiguedad, Area, idSede, idGerente, idCondicion, fechaRegistro)
VALUES (2, 2, 'Hospital B', 5, 80.2, 2, 2, 2, SYSDATE);

---------------------- PREGUNTAS -----------------------
--a. SP_HOSPITAL_REGISTRAR----------------
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_REGISTRAR (
    p_idHospital IN hospital.idHospital%TYPE,
    p_idDistrito IN hospital.idDistrito%TYPE,
    p_Nombre IN hospital.Nombre%TYPE,
    p_Antiguedad IN hospital.Antiguedad%TYPE,
    p_Area IN hospital.Area%TYPE,
    p_idSede IN hospital.idSede%TYPE,
    p_idGerente IN hospital.idGerente%TYPE,
    p_idCondicion IN hospital.idCondicion%TYPE
) AS
BEGIN
    INSERT INTO hospital (idHospital, idDistrito, Nombre, Antiguedad, Area, idSede, idGerente, idCondicion, fechaRegistro)
    VALUES (p_idHospital, p_idDistrito, p_Nombre, p_Antiguedad, p_Area, p_idSede, p_idGerente, p_idCondicion, SYSDATE);
    
    COMMIT;
END SP_HOSPITAL_REGISTRAR;
/

--B. ACTUALIZAR HOSPITAL ----------------
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ACTUALIZAR (
    p_idHospital IN hospital.idHospital%TYPE,
    p_idDistrito IN hospital.idDistrito%TYPE,
    p_Nombre IN hospital.Nombre%TYPE,
    p_Antiguedad IN hospital.Antiguedad%TYPE,
    p_Area IN hospital.Area%TYPE,
    p_idSede IN hospital.idSede%TYPE,
    p_idGerente IN hospital.idGerente%TYPE,
    p_idCondicion IN hospital.idCondicion%TYPE
) AS
BEGIN
    UPDATE hospital
    SET idDistrito = p_idDistrito,
        Nombre = p_Nombre,
        Antiguedad = p_Antiguedad,
        Area = p_Area,
        idSede = p_idSede,
        idGerente = p_idGerente,
        idCondicion = p_idCondicion
    WHERE idHospital = p_idHospital;
    
    COMMIT;
END SP_HOSPITAL_ACTUALIZAR;
/


--C. ELIMINAR POR IDHOSPITAL----------------
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_ELIMINAR (
    p_idHospital IN hospital.idHospital%TYPE
) AS
BEGIN
    DELETE FROM hospital WHERE idHospital = p_idHospital;
    
    COMMIT;
END SP_HOSPITAL_ELIMINAR;
/

--D. LISTAR DE FORMA DINAMICA_HOSPITAL :---------------- 
CREATE OR REPLACE PROCEDURE SP_HOSPITAL_LISTAR AS
    CURSOR c_hospitales IS
        SELECT h.idHospital, h.Nombre, h.Antiguedad, h.Area, h.idSede, h.idGerente, h.idCondicion, d.descDistrito, p.descProvincia, s.descSede, g.descGerente, c.descCondicion
        FROM hospital h
        JOIN distrito d ON h.idDistrito = d.idDistrito
        JOIN provincia p ON d.idProvincia = p.idProvincia
        JOIN sede s ON h.idSede = s.idSede
        JOIN gerente g ON h.idGerente = g.idGerente
        JOIN condicion c ON h.idCondicion = c.idCondicion;
BEGIN
    FOR hospital_rec IN c_hospitales LOOP
        DBMS_OUTPUT.PUT_LINE('ID Hospital: ' || hospital_rec.idHospital || ', Nombre: ' || hospital_rec.Nombre || ', Antigüedad: ' || hospital_rec.Antiguedad || ', Área: ' || hospital_rec.Area || ', Sede: ' || hospital_rec.descSede || ', Distrito: ' || hospital_rec.descDistrito || ', Provincia: ' || hospital_rec.descProvincia || ', Gerente: ' || hospital_rec.descGerente || ', Condición: ' || hospital_rec.descCondicion);
    END LOOP;
END SP_HOSPITAL_LISTAR;
/
commit





