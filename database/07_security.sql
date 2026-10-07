/* ============================================================
   SEGURIDAD
   bd_hotel_grupoAA
============================================================ */

USE master;
GO

ALTER DATABASE bd_hotel_grupoAA
SET CONTAINMENT = PARTIAL;
GO

USE bd_hotel_grupoAA;
GO

/* ============================================================
   ROLES
============================================================ */

CREATE ROLE rol_administrador;
GO

CREATE ROLE rol_recepcionista;
GO

CREATE ROLE rol_cajero;
GO

CREATE ROLE rol_gerente;
GO

/* ============================================================
   USUARIOS
============================================================ */

CREATE USER krissia_menjivar
WITH PASSWORD = 'Krissia123$';
GO

CREATE USER joahha_menjivar
WITH PASSWORD = 'Joahha123$';
GO

CREATE USER kevin_alas
WITH PASSWORD = 'Kevin123$';
GO

CREATE USER melissa_castro
WITH PASSWORD = 'Melissa123$';
GO

/* ============================================================
   ADMINISTRADOR
============================================================ */

GRANT CONTROL
ON DATABASE::bd_hotel_grupoAA
TO rol_administrador;
GO

/* ============================================================
   RECEPCIONISTA
============================================================ */

GRANT SELECT, INSERT, UPDATE
ON dbo.huesped
TO rol_recepcionista;

GRANT SELECT, INSERT, UPDATE
ON dbo.reservacion
TO rol_recepcionista;

GRANT SELECT
ON dbo.habitacion
TO rol_recepcionista;

GRANT SELECT
ON dbo.tipo_habitacion
TO rol_recepcionista;

GRANT SELECT
ON dbo.hotel
TO rol_recepcionista;

/* PROCEDIMIENTOS */

GRANT EXECUTE
ON dbo.sp_realizar_checkin
TO rol_recepcionista;

/* FUNCIONES */

GRANT EXECUTE
ON dbo.fn_habitacion_disponible
TO rol_recepcionista;

GO

/* ============================================================
   CAJERO
============================================================ */

GRANT SELECT
ON dbo.estancia
TO rol_cajero;

GRANT SELECT
ON dbo.consumo_servicio
TO rol_cajero;

GRANT SELECT, INSERT, UPDATE
ON dbo.factura
TO rol_cajero;

GRANT SELECT, INSERT
ON dbo.detalle_factura
TO rol_cajero;

/* PROCEDIMIENTOS */

GRANT EXECUTE
ON dbo.sp_realizar_checkout
TO rol_cajero;

GRANT EXECUTE
ON dbo.sp_registrar_consumo_servicio
TO rol_cajero;

/* FUNCIONES */

GRANT EXECUTE
ON dbo.fn_calcular_noches
TO rol_cajero;

GRANT EXECUTE
ON dbo.fn_calcular_total_servicios
TO rol_cajero;

GRANT EXECUTE
ON dbo.fn_calcular_costo_habitacion
TO rol_cajero;

GO

/* ============================================================
   GERENTE
============================================================ */

GRANT SELECT
ON dbo.hotel
TO rol_gerente;

GRANT SELECT
ON dbo.huesped
TO rol_gerente;

GRANT SELECT
ON dbo.empleado
TO rol_gerente;

GRANT SELECT
ON dbo.habitacion
TO rol_gerente;

GRANT SELECT
ON dbo.tipo_habitacion
TO rol_gerente;

GRANT SELECT
ON dbo.reservacion
TO rol_gerente;

GRANT SELECT
ON dbo.estancia
TO rol_gerente;

GRANT SELECT
ON dbo.factura
TO rol_gerente;

GRANT SELECT
ON dbo.detalle_factura
TO rol_gerente;

GRANT SELECT
ON dbo.consumo_servicio
TO rol_gerente;

GO

/* ============================================================
   ASIGNACION DE ROLES
============================================================ */

ALTER ROLE rol_administrador
ADD MEMBER krissia_menjivar;
GO

ALTER ROLE rol_recepcionista
ADD MEMBER joahha_recinos;
GO

ALTER ROLE rol_cajero
ADD MEMBER kevin_alas;
GO

ALTER ROLE rol_gerente
ADD MEMBER melissa_castro;
GO

/* ============================================================
   PRUEBAS
============================================================ */

EXECUTE AS USER = 'joahha_menjivar';

SELECT TOP 5 *
FROM huesped;

REVERT;
GO

EXECUTE AS USER = 'kevin_alas';

SELECT TOP 5 *
FROM factura;

REVERT;
GO
