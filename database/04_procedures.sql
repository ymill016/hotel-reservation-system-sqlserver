USE bd_hotel_grupoAA;
GO

-- ============================================================
-- FUNCIONES ESCALARES
-- ============================================================

-- Funcion 1: Calcula la cantidad de noches
CREATE OR ALTER FUNCTION fn_calcular_noches(@p_id_estancia INT)
RETURNS INT
AS
BEGIN
    DECLARE @v_checkin DATETIME2;
    DECLARE @v_checkout DATETIME2;
    DECLARE @v_noches INT;

    SELECT @v_checkin = fecha_checkin, @v_checkout = fecha_checkout
    FROM estancia
    WHERE id_estancia = @p_id_estancia;

    IF @@ROWCOUNT = 0
        RETURN NULL; -- Manejo equivalente si no existe

    IF @v_checkout IS NULL
        RETURN NULL; -- Estancia aun activa

    -- En SQL Server se calculan los días por diferencia de fechas
    SET @v_noches = DATEDIFF(DAY, @v_checkin, @v_checkout);

    -- Mínimo 1 noche
    IF @v_noches < 1
        SET @v_noches = 1;

    RETURN @v_noches;
END;
GO

-- Funcion 2: Suma el total de consumos de servicios adicionales registrados en una estancia.
CREATE OR ALTER FUNCTION fn_calcular_total_servicios(@p_id_estancia INT)
RETURNS NUMERIC(10,2)
AS
BEGIN
    DECLARE @v_total NUMERIC(10,2);

    SELECT @v_total = COALESCE(SUM(subtotal), 0)
    FROM consumo_servicio
    where id_estancia = @p_id_estancia;

    RETURN @v_total;
END;
GO

-- Funcion 3: Verifica si una habitacion especifica esta disponible
CREATE OR ALTER FUNCTION fn_habitacion_disponible(
    @p_id_habitacion INT,
    @p_fecha_entrada DATETIME2,
    @p_fecha_salida DATETIME2
)
RETURNS BIT
AS
BEGIN
    DECLARE @v_conflictos INT;
    DECLARE @v_estado_habitacion VARCHAR(20);

    -- Verificar que las fechas sean validas
    IF @p_fecha_salida <= @p_fecha_entrada
        RETURN 0;

    SELECT @v_estado_habitacion = estado_habitacion
    FROM habitacion
    WHERE id_habitacion = @p_id_habitacion;

    IF @@ROWCOUNT = 0
        RETURN 0;

    IF @v_estado_habitacion = 'MANTENIMIENTO'
        RETURN 0;

    -- Verificar estancias de esa habitacion que se solapan con el rango solicitado
    SELECT @v_conflictos = COUNT(*)
    FROM estancia e
    WHERE e.id_habitacion = @p_id_habitacion
      AND e.estado_estancia IN ('ACTIVA', 'FINALIZADA')
      AND e.fecha_checkin < @p_fecha_salida
      AND COALESCE(e.fecha_checkout, @p_fecha_salida) > @p_fecha_entrada;

    IF @v_conflictos = 0
        RETURN 1;

    RETURN 0;
END;
GO

-- Funcion 4: Calcula el costo total de alojamiento de una estancia
CREATE OR ALTER FUNCTION fn_calcular_costo_habitacion(@p_id_estancia INT)
RETURNS NUMERIC(10,2)
AS
BEGIN
    DECLARE @v_noches INT;
    DECLARE @v_precio_noche NUMERIC(10,2);
    DECLARE @v_costo_total NUMERIC(10,2);

    -- Obtener noches de estancia
    SET @v_noches = dbo.fn_calcular_noches(@p_id_estancia);

    IF @v_noches IS NULL
        RETURN NULL;

    -- Obtener precio por noche del tipo de habitacion
    SELECT @v_precio_noche = th.precio_noche
    FROM estancia e
    JOIN habitacion h ON h.id_habitacion = e.id_habitacion
    JOIN tipo_habitacion th ON th.id_tipo_habitacion = h.id_tipo_habitacion
    WHERE e.id_estancia = @p_id_estancia;

    IF @@ROWCOUNT = 0
        RETURN NULL;

    SET @v_costo_total = @v_noches * @v_precio_noche;

    RETURN @v_costo_total;
END;
GO


-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

-- Procedimiento 1: Registra el check-in de un huesped.
CREATE OR ALTER PROCEDURE sp_realizar_checkin
    @p_id_reservacion INT,
    @p_id_habitacion INT,
    @p_id_empleado INT,
    @p_id_estancia_out INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_estado_reserva VARCHAR(20);
    DECLARE @v_estado_habitacion VARCHAR(20);
    DECLARE @v_id_huesped INT;

    -- Obtener datos de la reservacion
    SELECT @v_estado_reserva = estado_reserva, @v_id_huesped = id_huesped
    FROM reservacion
    WHERE id_reservacion = @p_id_reservacion;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50001, 'No existe la reservacion especificada.', 1;
        RETURN;
    END

    IF @v_estado_reserva != 'CONFIRMADA'
    BEGIN
        RAISERROR('La reservacion no esta confirmada.', 16, 1);
        RETURN;
    END

    -- Verificar estado de la habitacion
    SELECT @v_estado_habitacion = estado_habitacion
    FROM habitacion
    WHERE id_habitacion = @p_id_habitacion;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50002, 'No existe la habitacion especificada.', 1;
        RETURN;
    END

    IF @v_estado_habitacion != 'DISPONIBLE'
    BEGIN
        RAISERROR('La habitacion no esta disponible.', 16, 1);
        RETURN;
    END

    -- Crear registro de estancia
    INSERT INTO estancia (
        fecha_checkin,
        fecha_checkout,
        estado_estancia,
        id_reservacion,
        id_habitacion,
        id_empleado_checkin
    )
    VALUES (
        GETDATE(),
        NULL,
        'ACTIVA',
        @p_id_reservacion,
        @p_id_habitacion,
        @p_id_empleado
    );

    SET @p_id_estancia_out = SCOPE_IDENTITY();

    -- Registrar huesped titular como acompanante
    INSERT INTO acompanante (es_titular, id_estancia, id_huesped)
    VALUES (1, @p_id_estancia_out, @v_id_huesped);

    -- Actualizar estado de la habitacion a ocupada
    UPDATE habitacion
    SET estado_habitacion = 'OCUPADA'
    WHERE id_habitacion = @p_id_habitacion;

    -- Actualizar estado de la reservacion
    UPDATE reservacion
    SET estado_reserva = 'CONFIRMADA'
    WHERE id_reservacion = @p_id_reservacion;
END;
GO

-- Procedimiento 2: Realiza el proceso completo de check-out de una estancia activa
CREATE OR ALTER PROCEDURE sp_realizar_checkout
    @p_id_estancia INT,
    @p_id_empleado INT,
    @p_tipo_pago VARCHAR(30),
    @p_metodo_pago VARCHAR(30),
    @p_descuento NUMERIC(10,2),
    @p_id_factura_out INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_estado_estancia VARCHAR(20);
    DECLARE @v_id_habitacion INT;
    DECLARE @v_costo_habitacion NUMERIC(10,2);
    DECLARE @v_total_servicios NUMERIC(10,2);
    DECLARE @v_subtotal NUMERIC(10,2);
    DECLARE @v_impuestos NUMERIC(10,2);
    DECLARE @v_total NUMERIC(10,2);
    DECLARE @v_tasa_impuesto NUMERIC(5,4) = 0.13; -- IVA 13%
    DECLARE @v_desc NUMERIC(10,2);
    DECLARE @v_noches INT;
    DECLARE @v_precio_noche NUMERIC(10,2);
    DECLARE @v_nombre_habitacion VARCHAR(50);

    -- Validar que la estancia existe y esta activa
    SELECT @v_estado_estancia = estado_estancia, @v_id_habitacion = id_habitacion
    FROM estancia
    WHERE id_estancia = @p_id_estancia;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50003, 'No existe la estancia especificada.', 1;
        RETURN;
    END

    IF @v_estado_estancia != 'ACTIVA'
    BEGIN
        RAISERROR('La estancia no esta activa.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM factura WHERE id_estancia = @p_id_estancia)
    BEGIN
        RAISERROR('Ya existe una factura para esta estancia.', 16, 1);
        RETURN;
    END

    -- Registrar fecha/hora de checkout
    UPDATE estancia
    SET fecha_checkout = GETDATE(),
        estado_estancia = 'FINALIZADA'
    WHERE id_estancia = @p_id_estancia;

    -- Liberar la habitacion a limpieza
    UPDATE habitacion
    SET estado_habitacion = 'LIMPIEZA'
    WHERE id_habitacion = @v_id_habitacion;

    -- Calcular costos
    SET @v_costo_habitacion = dbo.fn_calcular_costo_habitacion(@p_id_estancia);
    SET @v_noches = dbo.fn_calcular_noches(@p_id_estancia);
    SET @v_total_servicios = dbo.fn_calcular_total_servicios(@p_id_estancia);

    SELECT @v_precio_noche = th.precio_noche, @v_nombre_habitacion = th.nombre_tipo
    FROM estancia e
    JOIN habitacion h ON h.id_habitacion = e.id_habitacion
    JOIN tipo_habitacion th ON th.id_tipo_habitacion = h.id_tipo_habitacion
    WHERE e.id_estancia = @p_id_estancia;

    SET @v_desc = COALESCE(@p_descuento, 0);
    SET @v_subtotal = @v_costo_habitacion + @v_total_servicios - @v_desc;
    SET @v_impuestos = ROUND(@v_subtotal * @v_tasa_impuesto, 2);
    SET @v_total = @v_subtotal + @v_impuestos;

    -- Crear cabecera de factura
    INSERT INTO factura (
        fecha_emision,
        subtotal,
        impuestos,
        descuento,
        total,
        estado_factura,
        fecha_pago,
        tipo_pago,
        metodo_pago,
        id_empleado,
        id_estancia
    )
    VALUES (
        GETDATE(),
        @v_subtotal,
        @v_impuestos,
        @v_desc,
        @v_total,
        CASE WHEN @p_metodo_pago = 'CONTADO' THEN 'PAGADO' ELSE 'PENDIENTE' END,
        CASE WHEN @p_metodo_pago = 'CONTADO' THEN GETDATE() ELSE NULL END,
        @p_tipo_pago,
        @p_metodo_pago,
        @p_id_empleado,
        @p_id_estancia
    );

    SET @p_id_factura_out = SCOPE_IDENTITY();

    -- Insertar detalle de habitacion
    INSERT INTO detalle_factura (
        tipo_detalle,
        concepto,
        cantidad,
        precio_unitario,
        subtotal,
        id_factura,
        id_consumo
    )
    VALUES (
        'HABITACION',
        'Alojamiento - ' + @v_nombre_habitacion + ' (' + CAST(@v_noches AS VARCHAR) + ' noche(s))',
        @v_noches,
        @v_precio_noche,
        @v_costo_habitacion,
        @p_id_factura_out,
        NULL
    );

    -- Insertar detalle por cada consumo de servicio mediante un cursor simple o inserción masiva
    INSERT INTO detalle_factura (
        tipo_detalle,
        concepto,
        cantidad,
        precio_unitario,
        subtotal,
        id_factura,
        id_consumo
    )
    SELECT 
        'SERVICIO',
        s.nombre,
        cs.cantidad,
        s.precio_unitario,
        cs.subtotal,
        @p_id_factura_out,
        cs.id_consumo
    FROM consumo_servicio cs
    JOIN servicio s ON s.id_servicio = cs.id_servicio
    WHERE cs.id_estancia = @p_id_estancia;
END;
GO

-- Procedimiento 3: Registra el consumo de un servicio adicional durante una estancia activa
CREATE OR ALTER PROCEDURE sp_registrar_consumo_servicio
    @p_id_estancia INT,
    @p_id_servicio INT,
    @p_id_empleado INT,
    @p_cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_precio_unitario NUMERIC(10,2);
    DECLARE @v_subtotal NUMERIC(10,2);
    DECLARE @v_estado_estancia VARCHAR(20);
    DECLARE @v_estado_servicio VARCHAR(20);

    IF @p_cantidad <= 0
    BEGIN
        RAISERROR('La cantidad debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    SELECT @v_estado_estancia = estado_estancia
    FROM estancia
    WHERE id_estancia = @p_id_estancia;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50004, 'No existe la estancia especificada.', 1;
        RETURN;
    END

    IF @v_estado_estancia != 'ACTIVA'
    BEGIN
        RAISERROR('La estancia no esta activa.', 16, 1);
        RETURN;
    END

    SELECT @v_precio_unitario = precio_unitario, @v_estado_servicio = estado_servicio
    FROM servicio
    WHERE id_servicio = @p_id_servicio;

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50005, 'No existe el servicio especificado.', 1;
        RETURN;
    END

    IF @v_estado_servicio != 'ACTIVO'
    BEGIN
        RAISERROR('El servicio no esta disponible actualmente.', 16, 1);
        RETURN;
    END

    SET @v_subtotal = @p_cantidad * @v_precio_unitario;

    INSERT INTO consumo_servicio (
        fecha_consumo,
        cantidad,
        subtotal,
        id_estancia,
        id_servicio,
        id_empleado
    )
    VALUES (
        GETDATE(),
        @p_cantidad,
        @v_subtotal,
        @p_id_estancia,
        @p_id_servicio,
        @p_id_empleado
    );
END;
GO
GO
