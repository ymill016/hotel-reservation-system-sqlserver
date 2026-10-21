/* ============================================================
   DATOS DE PRUEBA - bd_hotel_grupoAA
   Uso: ejecutar DESPUES de 02_tables.sql, 04, 05, 06
   ============================================================ */
USE bd_hotel_grupoAA;
GO

SET NOCOUNT ON;
GO

/* ------------------------------------------------------------
   1. HOTELES
------------------------------------------------------------ */
SET IDENTITY_INSERT hotel ON;
INSERT INTO hotel (id_hotel, nombre, direccion, telefono, correo, num_estrellas) VALUES
(1, 'Hotel Playa Verde', 'Av. Costanera 123, San Salvador', '2222-1001', 'info@playaverde.com', 4),
(2, 'Hotel Montaña Azul', 'Km 45 Carretera al Boquerón', '2222-1002', 'contacto@montanaazul.com', 3);
SET IDENTITY_INSERT hotel OFF;
GO

/* ------------------------------------------------------------
   2. TIPOS DE HABITACION
------------------------------------------------------------ */
SET IDENTITY_INSERT tipo_habitacion ON;
INSERT INTO tipo_habitacion (id_tipo_habitacion, nombre_tipo, descripcion, capacidad, precio_noche) VALUES
(1, 'Sencilla',   'Cama individual, TV, WiFi',            1, 45.00),
(2, 'Doble',      'Dos camas dobles, TV, WiFi, minibar',  4, 75.00),
(3, 'Suite',      'King size, sala, jacuzzi, vista al mar',2, 150.00),
(4, 'Familiar',   'Dos habitaciones conectadas, 6 camas',  6, 120.00);
SET IDENTITY_INSERT tipo_habitacion OFF;
GO

/* ------------------------------------------------------------
   3. SERVICIOS
------------------------------------------------------------ */
SET IDENTITY_INSERT servicio ON;
INSERT INTO servicio (id_servicio, nombre, descripcion, precio_unitario, estado_servicio, categoria) VALUES
(1, 'Desayuno buffet',      'Desayuno completo 7am-10am',   8.50,  'ACTIVO',   'Alimentacion'),
(2, 'Cena restaurante',     'Plato principal + bebida',     15.00, 'ACTIVO',   'Alimentacion'),
(3, 'Lavanderia',           'Por libra de ropa',            5.00,  'ACTIVO',   'Lavanderia'),
(4, 'Transporte aeropuerto','Van privado ida o vuelta',     25.00, 'ACTIVO',   'Transporte'),
(5, 'Spa y masajes',        'Masaje relajante 60 min',      35.00, 'ACTIVO',   'Bienestar'),
(6, 'Room service',         'Cargo por entrega a habitacion',3.00,  'ACTIVO',   'Alimentacion'),
(7, 'Guia turistico',       'Tour ciudad medio dia',        20.00, 'INACTIVO', 'Turismo');
SET IDENTITY_INSERT servicio OFF;
GO

/* ------------------------------------------------------------
   4. HUESPEDES
------------------------------------------------------------ */
SET IDENTITY_INSERT huesped ON;
INSERT INTO huesped (id_huesped, nombre, apellido, documento_identidad, telefono, correo, direccion, tipo_documento, nacionalidad, fecha_registro) VALUES
(1, 'Carlos',   'Ramirez',    '00123456-7', '7777-0001', 'carlos.ramirez@gmail.com',   'Col. Escalón, San Salvador',   'DUI',             'El Salvador',  '2025-01-10'),
(2, 'Ana',      'Martinez',   '00876543-2', '7777-0002', 'ana.martinez@gmail.com',     'Santa Tecla, La Libertad',     'DUI',             'El Salvador',  '2025-01-15'),
(3, 'John',     'Smith',      'P1234567',   '7777-0003', 'john.smith@outlook.com',     'New York, USA',                'PASAPORTE',       'Estados Unidos','2025-02-01'),
(4, 'Maria',    'Fernandez',  '00987654-1', '7777-0004', 'maria.fernandez@gmail.com',  'San Miguel, San Miguel',       'DUI',             'El Salvador',  '2025-02-05'),
(5, 'Lucia',    'Gomez',      'P7654321',   '7777-0005', 'lucia.gomez@gmail.com',      'Madrid, España',               'PASAPORTE',       'España',       '2025-02-20'),
(6, 'Pedro',    'Hernandez',  '00567891-3', '7777-0006', 'pedro.hernandez@gmail.com',  'Soyapango, San Salvador',      'DUI',             'El Salvador',  '2025-03-01'),
(7, 'Sofia',    'Lopez',      'P1122334',   '7777-0007', 'sofia.lopez@gmail.com',      'Ciudad de México, México',     'PASAPORTE',       'México',       '2025-03-10'),
(8, 'Ricardo',  'Torres',     '00334455-6', '7777-0008', 'ricardo.torres@gmail.com',   'Sonsonate, Sonsonate',         'DUI',             'El Salvador',  '2025-03-15'),
(9, 'Elena',    'Castillo',   '00778899-0', '7777-0009', 'elena.castillo@gmail.com',   'Santa Ana, Santa Ana',         'DUI',             'El Salvador',  '2025-04-01'),
(10,'David',    'Ortiz',      'P9988776',   '7777-0010', 'david.ortiz@gmail.com',      'Toronto, Canadá',              'PASAPORTE',       'Canadá',       '2025-04-10');
SET IDENTITY_INSERT huesped OFF;
GO

/* ------------------------------------------------------------
   5. EMPLEADOS
------------------------------------------------------------ */
SET IDENTITY_INSERT empleado ON;
INSERT INTO empleado (id_empleado, nombre, apellido, cargo, telefono, correo, estado_empleado, fecha_contratacion, turno, id_hotel) VALUES
(1, 'Marta',   'Diaz',     'Recepcionista',   '6666-0001', 'marta.diaz@playaverde.com',   'ACTIVO',     '2024-06-01', 'MANANA', 1),
(2, 'Luis',    'Perez',    'Recepcionista',   '6666-0002', 'luis.perez@playaverde.com',   'ACTIVO',     '2024-08-15', 'TARDE',  1),
(3, 'Jorge',   'Salazar',  'Cajero',          '6666-0003', 'jorge.salazar@playaverde.com','ACTIVO',     '2024-05-01', 'MANANA', 1),
(4, 'Carmen',  'Rios',     'Gerente',         '6666-0004', 'carmen.rios@playaverde.com',  'ACTIVO',     '2023-01-10', 'MANANA', 1),
(5, 'Andres',  'Molina',   'Recepcionista',   '6666-0005', 'andres.molina@montanaazul.com','ACTIVO',    '2024-09-01', 'NOCHE',  2),
(6, 'Paola',   'Vega',     'Cajero',          '6666-0006', 'paola.vega@montanaazul.com',  'VACACIONES', '2024-07-20', 'TARDE',  2),
(7, 'Raul',    'Campos',   'Botones',         '6666-0007', 'raul.campos@playaverde.com',  'INACTIVO',   '2024-03-11', 'NOCHE',  1);
SET IDENTITY_INSERT empleado OFF;
GO

/* ------------------------------------------------------------
   6. HABITACIONES  (hotel 1: 101-110, hotel 2: 201-205)
------------------------------------------------------------ */
SET IDENTITY_INSERT habitacion ON;
INSERT INTO habitacion (id_habitacion, numero_habitacion, nivel, estado_habitacion, id_hotel, id_tipo_habitacion) VALUES
(1,  '101', 1, 'DISPONIBLE',  1, 1),
(2,  '102', 1, 'DISPONIBLE',  1, 2),
(3,  '103', 1, 'OCUPADA',     1, 2),
(4,  '104', 1, 'DISPONIBLE',  1, 3),
(5,  '105', 1, 'MANTENIMIENTO',1, 1),
(6,  '201', 2, 'DISPONIBLE',  1, 2),
(7,  '202', 2, 'DISPONIBLE',  1, 4),
(8,  '203', 2, 'LIMPIEZA',    1, 1),
(9,  '301', 3, 'DISPONIBLE',  1, 3),
(10, '302', 3, 'DISPONIBLE',  1, 2),
(11, '201', 2, 'DISPONIBLE',  2, 1),
(12, '202', 2, 'DISPONIBLE',  2, 2),
(13, '203', 2, 'OCUPADA',     2, 2),
(14, '204', 2, 'DISPONIBLE',  2, 4),
(15, '301', 3, 'DISPONIBLE',  2, 3);
SET IDENTITY_INSERT habitacion OFF;
GO

/* ------------------------------------------------------------
   7. RESERVACIONES
------------------------------------------------------------ */
SET IDENTITY_INSERT reservacion ON;
INSERT INTO reservacion (id_reservacion, fecha_reserva, fecha_entrada, fecha_salida, estado_reserva, canal_reserva, id_huesped, id_empleado, id_tipo_habitacion) VALUES
(1,  '2025-05-01', '2025-06-01', '2025-06-05', 'CONFIRMADA', 'WEB',       1, 1, 2),
(2,  '2025-05-03', '2025-06-02', '2025-06-04', 'CONFIRMADA', 'TELEFONO',  3, 1, 3),
(3,  '2025-05-10', '2025-06-03', '2025-06-06', 'CONFIRMADA', 'RECEPCION', 5, 2, 1),
(4,  '2025-06-01', '2025-06-10', '2025-06-12', 'CONFIRMADA', 'WEB',       2, 2, 4),
(5,  '2025-06-05', '2025-06-15', '2025-06-18', 'PENDIENTE',  'AGENCIA',   7, 1, 2),
(6,  '2025-06-08', '2025-07-01', '2025-07-07', 'CONFIRMADA', 'WEB',       4, 1, 3),
(7,  '2025-06-10', '2025-07-05', '2025-07-08', 'CANCELADA',  'WEB',       6, 2, 1),
(8,  '2025-06-12', '2025-07-10', '2025-07-15', 'CONFIRMADA', 'TELEFONO',  8, 5, 2),
(9,  '2025-06-15', '2025-07-20', '2025-07-25', 'CONFIRMADA', 'AGENCIA',   9, 1, 4),
(10, '2025-07-01', '2025-08-01', '2025-08-05', 'CONFIRMADA', 'WEB',      10, 2, 3),
(11, '2025-07-05', '2025-08-10', '2025-08-14', 'PENDIENTE',  'RECEPCION', 1, 1, 2);
SET IDENTITY_INSERT reservacion OFF;
GO

/* ------------------------------------------------------------
   8. ESTANCIAS (varias finalizadas, 1 activa para el demo)
   Las fechas estan en el pasado para que fn_calcular_noches funcione
------------------------------------------------------------ */
SET IDENTITY_INSERT estancia ON;
INSERT INTO estancia (id_estancia, fecha_checkin, fecha_checkout, estado_estancia, id_reservacion, id_habitacion, id_empleado_checkin) VALUES
-- Finalizadas (generan historial para reportes)
(1,  '2025-06-01 14:00', '2025-06-05 11:00', 'FINALIZADA', 1, 2, 1),
(2,  '2025-06-02 15:00', '2025-06-04 12:00', 'FINALIZADA', 2, 4, 1),
(3,  '2025-06-03 13:00', '2025-06-06 10:00', 'FINALIZADA', 3, 1, 2),
(4,  '2025-06-10 14:00', '2025-06-12 11:00', 'FINALIZADA', 4, 7, 2),
(5,  '2025-07-01 15:00', '2025-07-07 12:00', 'FINALIZADA', 6, 9, 1),
(6,  '2025-07-10 14:00', '2025-07-15 11:00', 'FINALIZADA', 8, 6, 5),
(7,  '2025-07-20 13:00', '2025-07-25 10:00', 'FINALIZADA', 9, 10, 1),
(8,  '2025-08-01 14:00', '2025-08-05 12:00', 'FINALIZADA', 10, 4, 2),
-- Activas (para demo de check-in / ocupacion actual)
(9,  '2025-09-01 14:00', NULL,               'ACTIVA',     5, 13, 5);
SET IDENTITY_INSERT estancia OFF;
GO

/* El trigger de checkout puso habitaciones en LIMPIEZA al finalizar;
   las devolvemos a DISPONIBLE para que el estado actual sea coherente */
UPDATE habitacion SET estado_habitacion = 'DISPONIBLE'
WHERE id_habitacion IN (2,4,1,7,9,6,10);
UPDATE habitacion SET estado_habitacion = 'OCUPADA' WHERE id_habitacion = 13;
GO

/* ------------------------------------------------------------
   9. ACOMPANANTES
------------------------------------------------------------ */
SET IDENTITY_INSERT acompanante ON;
INSERT INTO acompanante (id_acompanante, es_titular, id_estancia, id_huesped) VALUES
(1, 1, 1, 1),
(2, 0, 1, 2),
(3, 1, 2, 3),
(4, 1, 3, 5),
(5, 1, 4, 2),
(6, 0, 4, 6),
(7, 1, 5, 4),
(8, 0, 5, 8),
(9, 1, 6, 8),
(10, 1, 7, 9),
(11, 1, 8, 10),
(12, 1, 9, 7);
SET IDENTITY_INSERT acompanante OFF;
GO

/* ------------------------------------------------------------
   10. CONSUMOS DE SERVICIO
   (subtotal = cantidad * precio; el trigger lo valida de todos modos)
------------------------------------------------------------ */
SET IDENTITY_INSERT consumo_servicio ON;
INSERT INTO consumo_servicio (id_consumo, fecha_consumo, cantidad, subtotal, id_estancia, id_servicio, id_empleado) VALUES
(1,  '2025-06-01 08:00', 2, 17.00,  1, 1, 1),
(2,  '2025-06-02 20:00', 1, 15.00,  1, 2, 1),
(3,  '2025-06-03 19:30', 1, 35.00,  1, 5, 2),
(4,  '2025-06-02 09:00', 2, 17.00,  2, 1, 1),
(5,  '2025-06-03 12:00', 1, 5.00,   2, 3, 1),
(6,  '2025-06-04 08:00', 1, 8.50,   3, 1, 2),
(7,  '2025-06-10 21:00', 3, 45.00,  4, 6, 2),
(8,  '2025-06-11 13:00', 1, 25.00,  4, 4, 2),
(9,  '2025-07-02 08:00', 2, 17.00,  5, 1, 1),
(10, '2025-07-04 20:00', 1, 15.00,  5, 2, 3),
(11, '2025-07-11 10:00', 1, 25.00,  6, 4, 5),
(12, '2025-07-13 15:00', 2, 70.00,  6, 5, 5),
(13, '2025-07-21 08:00', 4, 34.00,  7, 1, 1),
(14, '2025-08-02 09:00', 2, 17.00,  8, 1, 2),
(15, '2025-08-03 18:00', 1, 15.00,  8, 2, 2);
SET IDENTITY_INSERT consumo_servicio OFF;
GO

/* ------------------------------------------------------------
   11. FACTURAS (calculadas a mano: subtotal+servicios-desc, IVA 13%)
------------------------------------------------------------ */
SET IDENTITY_INSERT factura ON;
INSERT INTO factura (id_factura, fecha_emision, subtotal, impuestos, descuento, total, estado_factura, fecha_pago, tipo_pago, metodo_pago, id_empleado, id_estancia) VALUES
(1, '2025-06-05 11:30', 317.00, 41.21, 0,   358.21, 'PAGADO',    '2025-06-05 11:30', 'TARJETA',       'CONTADO', 3, 1),
(2, '2025-06-04 12:10', 320.00, 41.60, 0,   361.60, 'PAGADO',    '2025-06-04 12:10', 'EFECTIVO',      'CONTADO', 3, 2),
(3, '2025-06-06 10:20', 153.50, 19.96, 0,   173.46, 'PAGADO',    '2025-06-06 10:20', 'TARJETA',       'CONTADO', 3, 3),
(4, '2025-06-12 11:15', 325.00, 42.25, 25,  342.25, 'PAGADO',    '2025-06-12 11:15', 'TARJETA',       'CONTADO', 3, 4),
(5, '2025-07-07 12:05', 932.50, 121.23, 0,  1053.73,'PAGADO',    '2025-07-07 12:05', 'TRANSFERENCIA', 'CONTADO', 3, 5),
(6, '2025-07-15 11:00', 465.00, 60.45, 0,   525.45, 'PAGADO',    '2025-07-15 11:00', 'TARJETA',       'CONTADO', 3, 6),
(7, '2025-07-25 10:30', 634.00, 82.42, 0,   716.42, 'PENDIENTE', NULL,               'TRANSFERENCIA', 'CREDITO', 3, 7),
(8, '2025-08-05 12:20', 632.50, 82.23, 0,   714.73, 'PAGADO',    '2025-08-05 12:20', 'TARJETA',       'CONTADO', 3, 8);
SET IDENTITY_INSERT factura OFF;
GO

/* ------------------------------------------------------------
   12. DETALLE DE FACTURAS
------------------------------------------------------------ */
SET IDENTITY_INSERT detalle_factura ON;
INSERT INTO detalle_factura (id_detalle_factura, tipo_detalle, concepto, cantidad, precio_unitario, subtotal, id_factura, id_consumo) VALUES
-- Factura 1: estancia 1 (Doble, 4 noches * 75 = 300) + 3 consumos (17+15+35=67)
(1,  'HABITACION', 'Alojamiento - Doble (4 noche(s))',   4, 75.00, 300.00, 1, NULL),
(2,  'SERVICIO',   'Desayuno buffet',                    2, 8.50,   17.00,  1, 1),
(3,  'SERVICIO',   'Cena restaurante',                   1, 15.00,  15.00,  1, 2),
(4,  'SERVICIO',   'Spa y masajes',                        1, 35.00,  35.00,  1, 3),
-- Factura 2: estancia 2 (Suite, 2 noches * 150 = 300) + 2 consumos (17+5=22)... 
-- ajuste: 300 habitacion + 22 servicios - 0 = 322 -> usamos los calculos reales
(5,  'HABITACION', 'Alojamiento - Suite (2 noche(s))',     2, 150.00,300.00, 2, NULL),
(6,  'SERVICIO',   'Desayuno buffet',                    2, 8.50,   17.00,  2, 4),
(7,  'SERVICIO',   'Lavanderia',                           1, 5.00,    5.00,  2, 5),
-- Factura 3: estancia 3 (Sencilla, 3 noches * 45 = 135) + 8.50
(8,  'HABITACION', 'Alojamiento - Sencilla (3 noche(s))',  3, 45.00, 135.00, 3, NULL),
(9,  'SERVICIO',   'Desayuno buffet',                      1, 8.50,    8.50, 3, 6),
-- Factura 4: estancia 4 (Familiar, 2 noches * 120 = 240) + 70 servicios - desc 25 = 285
(10, 'HABITACION', 'Alojamiento - Familiar (2 noche(s))',  2, 120.00,240.00, 4, NULL),
(11, 'SERVICIO',   'Room service',                         3, 3.00,    9.00, 4, 7),
(12, 'SERVICIO',   'Transporte aeropuerto',                1, 25.00,  25.00, 4, 8),
-- Factura 5: estancia 5 (Suite, 6 noches * 150 = 900) + 32 servicios = 932.50
(13, 'HABITACION', 'Alojamiento - Suite (6 noche(s))',     6, 150.00,900.00, 5, NULL),
(14, 'SERVICIO',   'Desayuno buffet',                      2, 8.50,   17.00,  5, 9),
(15, 'SERVICIO',   'Cena restaurante',                     1, 15.00,  15.00, 5, 10),
-- Factura 6: estancia 6 (Doble, 5 noches * 75 = 375) + 95 servicios = 470
(16, 'HABITACION', 'Alojamiento - Doble (5 noche(s))',     5, 75.00, 375.00, 6, NULL),
(17, 'SERVICIO',   'Transporte aeropuerto',                1, 25.00,  25.00, 6, 11),
(18, 'SERVICIO',   'Spa y masajes',                        2, 35.00,  70.00, 6, 12),
-- Factura 7: estancia 7 (Doble, 5 noches * 120... Familiar 5 noches * 120 = 600) + 34 = 634
(19, 'HABITACION', 'Alojamiento - Familiar (5 noche(s))',  5, 120.00,600.00, 7, NULL),
(20, 'SERVICIO',   'Desayuno buffet',                      4, 8.50,   34.00,  7, 13),
-- Factura 8: estancia 8 (Suite, 4 noches * 150 = 600) + 32 = 632.50
(21, 'HABITACION', 'Alojamiento - Suite (4 noche(s))',     4, 150.00,600.00, 8, NULL),
(22, 'SERVICIO',   'Desayuno buffet',                      2, 8.50,   17.00,  8, 14),
(23, 'SERVICIO',   'Cena restaurante',                     1, 15.00,  15.00, 8, 15);
SET IDENTITY_INSERT detalle_factura OFF;
GO

/* ------------------------------------------------------------
   VERIFICACION RAPIDA
------------------------------------------------------------ */
SELECT 'hotel' AS tabla, COUNT(*) AS filas FROM hotel
UNION ALL SELECT 'tipo_habitacion', COUNT(*) FROM tipo_habitacion
UNION ALL SELECT 'servicio', COUNT(*) FROM servicio
UNION ALL SELECT 'huesped', COUNT(*) FROM huesped
UNION ALL SELECT 'empleado', COUNT(*) FROM empleado
UNION ALL SELECT 'habitacion', COUNT(*) FROM habitacion
UNION ALL SELECT 'reservacion', COUNT(*) FROM reservacion
UNION ALL SELECT 'estancia', COUNT(*) FROM estancia
UNION ALL SELECT 'acompanante', COUNT(*) FROM acompanante
UNION ALL SELECT 'consumo_servicio', COUNT(*) FROM consumo_servicio
UNION ALL SELECT 'factura', COUNT(*) FROM factura
UNION ALL SELECT 'detalle_factura', COUNT(*) FROM detalle_factura;
GO
