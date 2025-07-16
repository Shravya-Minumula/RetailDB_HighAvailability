---Create Triggers
CREATE TRIGGER trg_LogLowInventory
ON Inventory
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted WHERE QuantityAvailable < 10
    )
    BEGIN
        INSERT INTO AuditLog (EventType, Description)
        VALUES (
            'Low Inventory Alert',
            'Product quantity dropped below 10 units'
        );
    END
END;
