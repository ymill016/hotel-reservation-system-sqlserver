/* ============================================================
   VISTAS ANALITICAS Y OPERATIVAS - bd_hotel_grupoAA
   Estas vistas alimentan los reportes y el dashboard de Power BI
   ============================================================ */
USE bd_hotel_grupoAA;
GO

/* ------------------------------------------------------------
   1. OCUPACION ACTUAL POR HOTEL
   Porcentaje de habitaciones ocupadas vs. totales
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_ocupacion_por_hotel
AS
SELECT
    h.id_hotel,
    h.nombre AS hotel,
    COUNT(hab.id_habitacion) AS total_habitaciones,
    SUM(CASE WHEN hab.estado_habitacion = 'OCUPADA' THEN 1 ELSE 0 END) AS habitaciones_ocupadas,
    SUM(CASE WHEN hab.estado_habitacion = 'DISPONIBLE' THEN 1 ELSE 0 END) AS habitaciones_disponibles,
    SUM(CASE WHEN hab.estado_habitacion = 'MANTENIMIENTO' THEN 1 ELSE 0 END) AS habitaciones_mantenimiento,
    ROUND(
        100.0 * SUM(CASE WHEN hab.estado_habitacion = 'OCUPADA' THEN 1 ELSE 0 END)
        / COUNT(hab.id_habitacion), 2
    ) AS porcentaje_ocupacion
FROM hotel h
JOIN habitacion hab ON hab.id_hotel = h.id_hotel
GROUP BY h.id_hotel, h.nombre;
GO

/* ------------------------------------------------------------
   2. INGRESOS MENSUALES (fuente principal del dashboard)
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_ingresos_mensuales
AS
SELECT
    YEAR(f.fecha_emision)  AS anio,
    MONTH(f.fecha_emision) AS mes,
    DATEFROMPARTS(YEAR(f.fecha_emision), MONTH(f.fecha_emision), 1) AS mes_fecha,
    h.nombre AS hotel,
    COUNT(f.id_factura)              AS cantidad_facturas,
    SUM(f.subtotal)                  AS subtotal,
    SUM(f.impuestos)                 AS impuestos,
    SUM(COALESCE(f.descuento, 0))    AS descuentos,
    SUM(f.total)                     AS ingreso_total
FROM factura f
JOIN estancia e   ON e.id_estancia = f.id_estancia
JOIN habitacion hb ON hb.id_habitacion = e.id_habitacion
JOIN hotel h      ON h.id_hotel = hb.id_hotel
WHERE f.estado_factura <> 'CANCELADO'
GROUP BY
    YEAR(f.fecha_emision),
    MONTH(f.fecha_emision),
    DATEFROMPARTS(YEAR(f.fecha_emision), MONTH(f.fecha_emision), 1),
    h.nombre;
GO

/* ------------------------------------------------------------
   3. ESTANCIAS ACTIVAS CON DETALLE (vista operativa de recepcion)
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_estancias_activas
AS
SELECT
    e.id_estancia,
    h.nombre AS hotel,
    hb.numero_habitacion,
    th.nombre_tipo AS tipo_habitacion,
    hu.nombre + ' ' + hu.apellido AS huesped,
    e.fecha_checkin,
    DATEDIFF(DAY, e.fecha_checkin, GETDATE()) AS noches_actuales,
    emp.nombre + ' ' + emp.apellido AS empleado_checkin
FROM estancia e
JOIN reservacion r  ON r.id_reservacion = e.id_reservacion
JOIN huesped hu     ON hu.id_huesped = r.id_huesped
JOIN habitacion hb  ON hb.id_habitacion = e.id_habitacion
JOIN tipo_habitacion th ON th.id_tipo_habitacion = hb.id_tipo_habitacion
JOIN hotel h        ON h.id_hotel = hb.id_hotel
JOIN empleado emp   ON emp.id_empleado = e.id_empleado_checkin
WHERE e.estado_estancia = 'ACTIVA';
GO

/* ------------------------------------------------------------
   4. SERVICIOS MAS CONSUMIDOS (ranking para Power BI)
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_servicios_mas_consumidos
AS
SELECT
    s.id_servicio,
    s.nombre AS servicio,
    s.categoria,
    SUM(cs.cantidad)        AS unidades_vendidas,
    COUNT(cs.id_consumo)    AS cantidad_consumos,
    SUM(cs.subtotal)        AS ingreso_total
FROM consumo_servicio cs
JOIN servicio s ON s.id_servicio = cs.id_servicio
GROUP BY s.id_servicio, s.nombre, s.categoria;
GO

/* ------------------------------------------------------------
   5. RESUMEN DE FACTURAS POR ESTANCIA (auditoria de cobro)
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_resumen_facturacion
AS
SELECT
    f.id_factura,
    f.fecha_emision,
    hu.nombre + ' ' + hu.apellido AS huesped,
    h.nombre AS hotel,
    f.subtotal,
    f.impuestos,
    COALESCE(f.descuento, 0) AS descuento,
    f.total,
    f.estado_factura,
    f.tipo_pago,
    f.metodo_pago,
    emp.nombre + ' ' + emp.apellido AS cajero
FROM factura f
JOIN estancia e   ON e.id_estancia = f.id_estancia
JOIN reservacion r ON r.id_reservacion = e.id_reservacion
JOIN huesped hu   ON hu.id_huesped = r.id_huesped
JOIN habitacion hb ON hb.id_habitacion = e.id_habitacion
JOIN hotel h      ON h.id_hotel = hb.id_hotel
JOIN empleado emp ON emp.id_empleado = f.id_empleado;
GO

/* ------------------------------------------------------------
   6. CANCELACIONES Y TASA POR CANAL DE RESERVA
------------------------------------------------------------ */
CREATE OR ALTER VIEW vw_canales_reserva
AS
SELECT
    r.canal_reserva,
    COUNT(*) AS total_reservas,
    SUM(CASE WHEN r.estado_reserva = 'CONFIRMADA' THEN 1 ELSE 0 END) AS confirmadas,
    SUM(CASE WHEN r.estado_reserva = 'PENDIENTE'  THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN r.estado_reserva = 'CANCELADA'  THEN 1 ELSE 0 END) AS canceladas,
    ROUND(
        100.0 * SUM(CASE WHEN r.estado_reserva = 'CANCELADA' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS tasa_cancelacion_pct
FROM reservacion r
GROUP BY r.canal_reserva;
GO

/* ------------------------------------------------------------
   PRUEBAS
------------------------------------------------------------
SELECT * FROM vw_ocupacion_por_hotel;
SELECT * FROM vw_ingresos_mensuales ORDER BY anio, mes;
SELECT * FROM vw_estancias_activas;
SELECT * FROM vw_servicios_mas_consumidos ORDER BY ingreso_total DESC;
SELECT * FROM vw_resumen_facturacion;
SELECT * FROM vw_canales_reserva;
*/
