-- Trigger 1: Validar estado y fechas de reservaciones
DROP TRIGGER IF EXISTS trg_verificar_disponibilidad_reservacion;
GO

CREATE TRIGGER trg_verificar_disponibilidad_reservacion
ON reservacion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE estado_reserva NOT IN ('PENDIENTE', 'CONFIRMADA')
           OR fecha_salida <= fecha_entrada
    )
    BEGIN
        RAISERROR('Error: Estado de reserva inválido o rango de fechas incorrecto.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Trigger 2: Actualiza automáticamente el estado de la habitacion tras finalizar/cancelar estancia
CREATE OR ALTER TRIGGER trg_actualizar_estado_habitacion_checkout
ON estancia
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(estado_estancia)
    BEGIN
        -- Si la estancia pasa a FINALIZADA, la habitación pasa a LIMPIEZA
        UPDATE h
        SET h.estado_habitacion = 'LIMPIEZA'
        FROM habitacion h
        JOIN inserted i ON h.id_habitacion = i.id_habitacion
        JOIN deleted d ON i.id_estancia = d.id_estancia
        WHERE i.estado_estancia = 'FINALIZADA' AND d.estado_estancia != 'FINALIZADA';

        -- Si la estancia pasa a CANCELADA, la habitación vuelve a DISPONIBLE
        UPDATE h
        SET h.estado_habitacion = 'DISPONIBLE'
        FROM habitacion h
        JOIN inserted i ON h.id_habitacion = i.id_habitacion
        JOIN deleted d ON i.id_estancia = d.id_estancia
        WHERE i.estado_estancia = 'CANCELADA' AND d.estado_estancia != 'CANCELADA';
    END
END;
GO

-- Trigger 3: Valida y corrige automáticamente el subtotal en consumo_servicio
CREATE OR ALTER TRIGGER trg_validar_subtotal_consumo
ON consumo_servicio
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualiza el subtotal asegurando que coincida exactamente con la cantidad por el precio unitario oficial
    UPDATE cs
    SET cs.subtotal = cs.cantidad * s.precio_unitario
    FROM consumo_servicio cs
    JOIN inserted i ON cs.id_consumo = i.id_consumo
    JOIN servicio s ON cs.id_servicio = s.id_servicio
    WHERE cs.subtotal <> (cs.cantidad * s.precio_unitario);
END;
GO
